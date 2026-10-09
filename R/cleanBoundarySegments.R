#' Clean and reconnect boundary segments of a 3D mesh
#'
#' Cleans boundary segments extracted from a `mesh3d` object by optionally removing
#' segments associated with specified intersection vertices, removing redundant connections,
#' long segments, and small connected groups, and reconnecting disconnected boundary
#' endpoints.
#'
#' @param iBorder Integer 2 x n matrix containing the boundary segment indices, where
#' each column defines a segment by the indices of its two vertices.
#' @param baseMesh `mesh3d` object containing the mesh geometry associated with the
#' boundary segments.
#' @param intersection Integer vector or list of integer vectors containing vertex
#' indices associated with intersections to be removed from the boundary. Segments
#' whose two endpoints belong to these vertices are removed. Default is `NULL`.
#' @param lengthProb Numeric value between 0 and 1 defining the quantile used to remove
#' unusually long boundary segments. Default is `0.98`.
#' @param minGroupSize Integer. Minimum number of segments required for a connected
#' group to be retained. Default is `10`.
#'
#' @returns
#' Integer 2 x n matrix containing the cleaned and reconnected boundary segments.
#'
#' @details
#' Boundary segments are processed in several steps. If `intersection` is provided,
#' segments whose two endpoints belong to the specified intersection vertices are
#' removed first. This can be used, for example, to remove boundary segments associated
#' with intersections between different mesh components.
#'
#' Vertices incident to more than two boundary segments are then simplified by retaining
#' only two connections. Segments whose length exceeds the quantile specified by `lengthProb`
#' are removed, followed by connected groups containing fewer than `minGroupSize` segments.
#'
#' Finally, vertices incident to a single remaining boundary segment are identified
#' as disconnected endpoints. These endpoints are paired according to their nearest
#' neighbor in the XY plane, and the corresponding connecting segments are added to
#' the boundary.
#'
#' The indices supplied through `iBorder` and `intersection` must refer to the vertex
#' indexing of `baseMesh`.
#'
#' @seealso [getBoundarySegments()]
#'
#' @examples
#' # Create a rectangular mesh with a triangular hole
#' vertices <- matrix(
#'   c(
#'     0, 0, 0,
#'     4, 0, 0,
#'     4, 2, 0,
#'     0, 2, 0,
#'     1.5, 0.8, 0,
#'     2.2, 0.8, 0,
#'     1.8, 1.4, 0
#'   ),
#'   ncol = 3,
#'   byrow = TRUE
#' )
#'
#' # Define the triangular faces around the hole
#' triangles <- matrix(
#'   c(
#'     1, 2, 5,
#'     2, 6, 5,
#'     2, 3, 6,
#'     3, 7, 6,
#'     3, 4, 7,
#'     4, 1, 7,
#'     1, 5, 7
#'   ),
#'   ncol = 3,
#'   byrow = TRUE
#' )
#'
#' # Create the mesh
#' baseMesh <- tmesh3d(vertices = t(vertices), indices = t(triangles),
#'                     homogeneous = FALSE)
#'
#' # Extract boundary segment indices
#' iBorder <- getBoundarySegments(baseMesh)
#'
#' # Clean the boundary segments
#' cleanBorder <- cleanBoundarySegments(iBorder, baseMesh, minGroupSize = 4)
#'
#' # Represent the original mesh and boundaries
#' open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#' mfrow3d(1, 3)
#'
#' shade3d(baseMesh, color = "lightgray")
#' title3d("Mesh", line = 8, level = 2)
#'
#' next3d()
#' shade3d(mesh3d(vertices = baseMesh$vb, segments = iBorder))
#' title3d("Original boundary", line = 8, level = 2)
#'
#' next3d()
#' shade3d(mesh3d(vertices = baseMesh$vb, segments = cleanBorder))
#' title3d("Cleaned boundary", line = 8, level = 2)
#'
#' @export
cleanBoundarySegments <- function(iBorder,
                                  baseMesh,
                                  intersection = NULL,
                                  lengthProb = 0.98,
                                  minGroupSize = 10) {

  # Remove segments associated with specified intersections
  if (!is.null(intersection)) {

    # Combine all intersection vertex indices
    intersectionVertices <- unique(unlist(intersection))

    # Count how many endpoints of each segment belong to an intersection
    nIntersection <- (iBorder[1, ] %in% intersectionVertices) +
                     (iBorder[2, ] %in% intersectionVertices)

    # Remove segments whose two endpoints belong to an intersection
    removeSegments <- nIntersection == 2

    iBorder <- iBorder[ , !removeSegments, drop = FALSE]
  }

  # Remove extra connections from vertices with degree greater than 2
  count <- table(as.vector(iBorder))
  problematic <- as.integer(names(count[count > 2]))

  for (i in problematic) {
    idxSegs <- which(iBorder[1, ] == i | iBorder[2, ] == i)

    nRemove <- length(idxSegs) - 2

    if (nRemove > 0) {
      iBorder <- iBorder[ , -utils::tail(idxSegs, nRemove), drop = FALSE]
    }
  }

  # Remove long boundary segments
  coords1 <- t(baseMesh$vb[1:2, iBorder[1, ], drop = FALSE])

  coords2 <- t(baseMesh$vb[1:2, iBorder[2, ], drop = FALSE])

  lengths <- sqrt(rowSums((coords2 - coords1)^2))

  threshold <- stats::quantile(lengths, probs = lengthProb)

  iBorder <- iBorder[ , lengths <= threshold, drop = FALSE]

  # Remove small connected groups of segments
  n <- ncol(iBorder)
  group <- rep(0L, n)
  groupNum <- 0L

  for (i in seq_len(n)) {
    if (group[i] > 0) next

    groupNum <- groupNum + 1L
    queue <- i
    group[i] <- groupNum

    while (length(queue)) {
      current <- queue[1]
      queue <- queue[-1]

      neighbors <- which(iBorder[1, ] %in% iBorder[, current] |
                         iBorder[2, ] %in% iBorder[, current])

      newNeighbors <- neighbors[group[neighbors] == 0]

      group[newNeighbors] <- groupNum
      queue <- c(queue, newNeighbors)
    }
  }

  validGroups <- which(table(group) >= minGroupSize)

  validSegments <- which(group %in% validGroups)

  iBorder <- iBorder[ , validSegments, drop = FALSE]

  # Reconnect disconnected boundary endpoints
  count <- table(as.vector(iBorder))

  endPoints <- as.integer(names(count[count == 1]))

  newPairs <- list()
  connectedEndPoints <- integer(0)

  for (v in endPoints) {
    if (v %in% connectedEndPoints) next

    others <- setdiff(endPoints, c(v, connectedEndPoints))

    if (length(others) == 0) next

    coordV <- t(baseMesh$vb[1:2, v, drop = FALSE])

    coordsOthers <- t(baseMesh$vb[1:2, others, drop = FALSE])

    if (!requireNamespace("FNN", quietly = TRUE)) stop("package 'FNN' is required")

    nn <- FNN::get.knnx(coordsOthers, coordV, k = 1)$nn.index[1]

    neighbor <- others[nn]

    newPairs <- append(newPairs, list(c(v, neighbor)))

    connectedEndPoints <- c(connectedEndPoints, v, neighbor)
  }

  # Add the new boundary connections
  if (length(newPairs) > 0) {
    newPairs <- do.call(rbind, newPairs)

    iBorder <- cbind(iBorder, t(newPairs))
  }

  return(iBorder)
}
