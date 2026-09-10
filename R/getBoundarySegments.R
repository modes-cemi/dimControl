#' Extract the Boundary of a 3D Mesh
#'
#' Identifies the unshared edges of a `mesh3d` object, i.e., edges belonging to only
#' one face of the mesh.
#'
#' @param mesh A `mesh3d` object representing the 3D mesh.
#' @param returnMesh Logical. If `TRUE`, returns a `mesh3d` object containing the boundary
#' segments. If `FALSE`, returns a matrix with the corresponding vertex indices. Default
#' is `FALSE`.
#' @param simplify Logical. If `TRUE` and `returnMesh = TRUE`, simplifies the resulting
#' boundary mesh using the internal mesh-cleaning routine. Default is `TRUE`.
#'
#' @returns
#' If `returnMesh = FALSE`, a two-row matrix containing the vertex indices of the boundary
#' segments. If `returnMesh = TRUE`, a `mesh3d` object containing the boundary segments.
#'
#' @details
#' The function is adapted from [rgl::getBoundary3d()]. Edge endpoints are sorted
#' to represent undirected edges, and their frequencies are counted. Edges appearing
#' only once are identified as boundary edges.
#'
#' @seealso [rgl::getBoundary3d()]
#'
#' @examples
#' \dontrun{
#' # Create a cube and remove two faces
#' mesh <- rgl::cube3d(color = "lightblue")
#' mesh$ib <- mesh$ib[, -(1:2)]
#'
#' # Extract boundary segments
#' boundary <- getBoundarySegments(mesh, returnMesh = TRUE)
#'
#' # Display mesh and boundary side by side
#' rgl::clear3d()
#' rgl::mfrow3d(1, 2)
#'
#' rgl::shade3d(mesh, color = "lightgray", alpha = 0.4)
#' rgl::title3d("Mesh", level = 4)
#'
#' rgl::next3d()
#' rgl::shade3d(boundary, color = "red", lwd = 2)
#' rgl::title3d("Boundary", level = 4)
#' }
#'
#' @import data.table
#'
#' @export
getBoundarySegments <- function(mesh, returnMesh = FALSE, simplify = TRUE) {
  if (!inherits(mesh, "mesh3d"))
    stop(deparse(substitute(mesh)), " is not a mesh3d object.")
  edges <- NULL
  if (length(mesh$it))
    edges <- cbind(edges, mesh$it[1:2,],  mesh$it[2:3,], mesh$it[c(3,1),])
  if (length(mesh$ib))
    edges <- cbind(edges, mesh$ib[1:2,], mesh$ib[2:3,], mesh$ib[3:4,], mesh$ib[c(4,1),])
  if (is.null(edges) || ncol(edges) == 0) {
    return(matrix(integer(0), nrow = 2))
  }

  # Sort edge endpoints to represent undirected edges
  minV <- pmin(edges[1,], edges[2,])
  maxV <- pmax(edges[1,], edges[2,])

  # Create a table of edge endpoints with data.table
  edgeTable <- data.table::data.table(v1 = minV, v2 = maxV)

  # Count the frequency of each edge
  edgeCounts <- edgeTable[, .N, by = .(v1, v2)]

  # Keep edges that appear only once
  boundaryEdges <- edgeCounts[N == 1]

  # Select edges satisfying the condition
  keep <- paste(edgeTable$v1, edgeTable$v2) %in% paste(boundaryEdges$v1, boundaryEdges$v2)

  # Boundary edges
  boundary <- edges[, keep, drop = FALSE]

  # Return a mesh3d object if requested
  if (returnMesh) {
    result <- rgl::mesh3d(vertices = mesh$vb, segments = boundary)
    if (simplify)
      result <- cleanMesh3d(result)
    return(result)
  }

  boundary
}
