#' Clean and Reconnect Boundary Segments of a 3D Mesh
#'
#' Cleans boundary segments extracted from a `mesh3d` object by removing redundant
#' connections, long segments, and small connected components, reconnecting endpoints,
#' and retaining the main connected boundary.
#'
#' @param iBorder A two-row matrix containing the boundary segment indices, where each
#' column defines a segment by the indices of its two vertices.
#' @param baseMesh A `mesh3d` object containing the mesh geometry associated with the
#' boundary segments.
#' @param lengthProb A numeric value between 0 and 1 defining the quantile used to
#' remove abnormally long boundary segments. Default is `0.98`.
#' @param minGroupSize Minimum number of segments required for a connected component
#' to be retained. Default is `20`.
#'
#' @returns
#' A two-row matrix containing the cleaned and reconnected boundary segments.
#'
#' @details
#' Vertices with more than two incident boundary segments are simplified, unusually
#' long segments and small connected components are removed, disconnected endpoints
#' are paired by nearest-neighbor distance, and only the largest connected boundary
#' is retained.
#'
#' @seealso [getBoundarySegments()]
#'
#' @importFrom FNN get.knnx
#' @importFrom igraph graph_from_edgelist components
#' @importFrom stats quantile
#' @importFrom utils tail
#'
#' @examples
#' \dontrun{
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
#' baseMesh <- rgl::tmesh3d(
#'   vertices = t(vertices),
#'   indices = t(triangles),
#'   homogeneous = FALSE
#' )
#'
#' # Extract boundary segment indices
#' iBorder <- getBoundarySegments(baseMesh)
#'
#' # Clean the boundary segments
#' cleanBorder <- cleanBoundarySegments(
#'   iBorder,
#'   baseMesh,
#'   lengthProb = 1,
#'   minGroupSize = 4
#' )
#'
#' # Display the original mesh and boundaries
#' rgl::clear3d()
#' rgl::mfrow3d(1, 3)
#'
#' rgl::shade3d(baseMesh, color = "lightgray")
#' rgl::title3d("Mesh", level = 8)
#'
#' rgl::next3d()
#' rgl::shade3d(rgl::mesh3d(vertices = baseMesh$vb, segments = iBorder))
#' rgl::title3d("Original boundary", level = 8)
#'
#' rgl::next3d()
#' rgl::shade3d(rgl::mesh3d(vertices = baseMesh$vb, segments = cleanBorder))
#' rgl::title3d("Cleaned boundary", level = 8)
#' }
#'
#' @export
cleanBoundarySegments <- function(iBorder,
                                  baseMesh,
                                  lengthProb = 0.98,
                                  minGroupSize = 20) {

  # Remove extra connections from vertices with degree greater than 2
  count <- table(as.vector(iBorder))
  problematic <- as.integer(names(count[count > 2]))

  for (i in problematic) {
    idxSegs <- which(iBorder[1, ] == i | iBorder[2, ] == i)
    nRemove <- length(idxSegs) - 2

    if (nRemove > 0) {
      iBorder <- iBorder[, -tail(idxSegs, nRemove), drop = FALSE]
    }
  }

  # Remove long boundary segments
  coords1 <- t(baseMesh$vb[1:2, iBorder[1, ]])
  coords2 <- t(baseMesh$vb[1:2, iBorder[2, ]])

  lengths <- sqrt(rowSums((coords2 - coords1)^2))
  threshold <- stats::quantile(lengths, lengthProb)

  iBorder <- iBorder[, lengths <= threshold, drop = FALSE]

  # Remove small connected groups of segments
  n <- ncol(iBorder)
  group <- rep(0, n)
  groupNum <- 0

  for (i in 1:n) {
    if (group[i] > 0) next

    groupNum <- groupNum + 1
    queue <- i
    group[i] <- groupNum

    while (length(queue)) {
      current <- queue[1]
      queue <- queue[-1]

      neighbors <- which(
        iBorder[1, ] %in% iBorder[, current] |
        iBorder[2, ] %in% iBorder[, current]
      )

      newNeighbors <- neighbors[group[neighbors] == 0]
      group[newNeighbors] <- groupNum
      queue <- c(queue, newNeighbors)
    }
  }

  validGroups <- which(table(group) >= minGroupSize)
  validSegments <- which(group %in% validGroups)

  iBorder <- iBorder[, validSegments, drop = FALSE]

  # Reconnect disconnected boundary endpoints
  count <- table(as.vector(iBorder))
  endPoints <- as.integer(names(count[count == 1]))

  newPairs <- list()
  connectedEndPoints <- c()

  for (v in endPoints) {
    if (v %in% connectedEndPoints) next

    coordV <- t(baseMesh$vb[1:2, v, drop = FALSE])

    others <- setdiff(endPoints, c(v, connectedEndPoints))
    coordsOthers <- t(baseMesh$vb[1:2, others, drop = FALSE])

    if (length(others) > 0) {
      nn <- FNN::get.knnx(coordsOthers, coordV, k = 1)$nn.index[1]
      neighbor <- others[nn]

      newPairs <- append(newPairs, list(c(v, neighbor)))
      connectedEndPoints <- c(connectedEndPoints, v, neighbor)
    }
  }

  if (length(newPairs) > 0) {
    newPairs <- do.call(rbind, newPairs)
    iBorder <- cbind(iBorder, t(newPairs))
  }

  # Keep only the main connected boundary
  getMainBoundary <- function(iSegments) {
    g <- igraph::graph_from_edgelist(t(iSegments), directed = FALSE)

    comp <- igraph::components(g)

    mainVertices <- which(comp$membership == which.max(comp$csize))

    keep <- iSegments[1, ] %in% mainVertices &
            iSegments[2, ] %in% mainVertices

    iSegments[, keep, drop = FALSE]
  }

  iBorder <- getMainBoundary(iBorder)

  return(iBorder)
}
