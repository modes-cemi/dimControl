#' Clean and Reconnect Boundary Segments of a 3D Mesh
#'
#' Cleans a set of boundary segments previously extracted from a `mesh3d`
#' object. The function removes redundant connections at vertices with degree
#' greater than two, filters abnormally long segments, removes small connected
#' groups of segments, reconnects disconnected endpoints using the nearest
#' neighbor and retains only the main connected boundary.
#'
#' @param iborde A two-row matrix containing the boundary segment indices, where
#' each column represents a segment defined by the indices of its two vertices.
#' @param base_mesh A `mesh3d` object containing the mesh geometry to which the
#' boundary segments belong.
#' @param length_prob A numeric value between 0 and 1 defining the percentile
#' used to identify and remove abnormally long boundary segments. Default is
#' `0.98`.
#' @param min_group_size Minimum number of segments required for a connected
#' component to be retained. Smaller groups are removed. Default is `20`.
#'
#' @returns A two-row matrix containing the indices of the cleaned and
#' reconnected boundary segments.
#'
#' @seealso `getBoundarySegments()`
#'
#' @importFrom FNN get.knnx
#' @importFrom igraph graph_from_edgelist components
#' @importFrom stats quantile
#' @importFrom utils tail
#'
#' @export
cleanBoundarySegments <- function(iborde,
                                  base_mesh,
                                  length_prob = 0.98,
                                  min_group_size = 20) {

  # Remove extra connections from vertices with degree greater than 2
  count <- table(as.vector(iborde))
  problematic <- as.integer(names(count[count > 2]))

  for (i in problematic) {
    idx_segs <- which(iborde[1, ] == i | iborde[2, ] == i)
    n_remove <- length(idx_segs) - 2

    if (n_remove > 0) {
      iborde <- iborde[, -tail(idx_segs, n_remove), drop = FALSE]
    }
  }

  # Remove long boundary segments
  coords1 <- t(base_mesh$vb[1:2, iborde[1, ]])
  coords2 <- t(base_mesh$vb[1:2, iborde[2, ]])

  lengths <- sqrt(rowSums((coords2 - coords1)^2))
  threshold <- stats::quantile(lengths, length_prob)

  iborde <- iborde[, lengths <= threshold, drop = FALSE]

  # Remove small connected groups of segments
  n <- ncol(iborde)
  group <- rep(0, n)
  group_num <- 0

  for (i in 1:n) {
    if (group[i] > 0) next

    group_num <- group_num + 1
    queue <- i
    group[i] <- group_num

    while (length(queue)) {
      current <- queue[1]
      queue <- queue[-1]

      neighbors <- which(
        iborde[1, ] %in% iborde[, current] |
          iborde[2, ] %in% iborde[, current]
      )

      new_neighbors <- neighbors[group[neighbors] == 0]
      group[new_neighbors] <- group_num
      queue <- c(queue, new_neighbors)
    }
  }

  valid_groups <- which(table(group) >= min_group_size)
  valid_segments <- which(group %in% valid_groups)

  iborde <- iborde[, valid_segments, drop = FALSE]

  # Reconnect disconnected boundary endpoints
  count <- table(as.vector(iborde))
  endpoints <- as.integer(names(count[count == 1]))

  new_pairs <- list()
  connected_endpoints <- c()

  for (v in endpoints) {
    if (v %in% connected_endpoints) next

    coord_v <- t(base_mesh$vb[1:2, v, drop = FALSE])

    others <- setdiff(endpoints, c(v, connected_endpoints))
    coords_others <- t(base_mesh$vb[1:2, others, drop = FALSE])

    if (length(others) > 0) {
      nn <- FNN::get.knnx(coords_others, coord_v, k = 1)$nn.index[1]
      neighbor <- others[nn]

      new_pairs <- append(new_pairs, list(c(v, neighbor)))
      connected_endpoints <- c(connected_endpoints, v, neighbor)
    }
  }

  if (length(new_pairs) > 0) {
    new_pairs <- do.call(rbind, new_pairs)
    iborde <- cbind(iborde, t(new_pairs))
  }

  # Keep only the main connected boundary
  get_main_boundary <- function(isegments) {
    g <- igraph::graph_from_edgelist(t(isegments), directed = FALSE)

    comp <- igraph::components(g)

    main_vertices <- which(comp$membership == which.max(comp$csize))

    keep <- isegments[1, ] %in% main_vertices &
      isegments[2, ] %in% main_vertices

    isegments[, keep, drop = FALSE]
  }

  iborde <- get_main_boundary(iborde)

  return(iborde)
}
