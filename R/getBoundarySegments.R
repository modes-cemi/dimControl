#' Extract the boundary of a 3D mesh
#'
#' Identifies the unshared edges of a `mesh3d` object, i.e., edges belonging to only
#' one face of the mesh.
#'
#' @param mesh `mesh3d` object representing the 3D mesh.
#' @param returnMesh Logical. If `TRUE`, returns a `mesh3d` object containing the
#' boundary segments. If `FALSE`, returns a matrix containing the corresponding vertex
#' indices. Default is `FALSE`.
#' @param simplify Logical. If `TRUE` and `returnMesh = TRUE`, removes unused vertices
#' from the resulting boundary mesh using [cleanMesh3d()]. Default is `TRUE`.
#'
#' @returns
#' Integer 2 x n matrix containing the vertex indices of the boundary segments if
#' `returnMesh = FALSE`; otherwise, a `mesh3d` object containing the boundary segments.
#'
#' @details
#' The function is adapted from [rgl::getBoundary3d()]. Edges are extracted from the
#' faces of the input mesh. Both triangular (`it`) and quadrilateral (`ib`) faces are
#' supported.
#'
#' The vertex indices of each edge are sorted so that edges are treated as undirected.
#' Their frequencies are then counted, and edges appearing only once are identified
#' as boundary edges.
#'
#' If `returnMesh = TRUE`, the boundary edges are returned as segments of a `mesh3d`
#' object. If `simplify = TRUE`, unused vertices are removed from the resulting mesh
#' using [cleanMesh3d()].
#'
#' @seealso [rgl::getBoundary3d()], [cleanMesh3d()]
#'
#' @import data.table
#'
#' @examples
#' library(rgl)
#'
#' # Create a cube and remove two faces
#' mesh <- cube3d(color = "lightblue")
#' mesh$ib <- mesh$ib[, -(1:2)]
#'
#' # Extract boundary segments
#' boundary <- getBoundarySegments(mesh, returnMesh = TRUE)
#'
#' # Represent mesh and boundary side by side
#' open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#' mfrow3d(1, 2)
#'
#' shade3d(mesh, color = "lightgray", alpha = 0.4)
#' title3d("Mesh", level = 4)
#'
#' next3d()
#' shade3d(boundary, color = "red", lwd = 2)
#' title3d("Boundary", level = 4)
#'
#' @export
getBoundarySegments <- function(mesh, returnMesh = FALSE, simplify = TRUE) {

  # Validate the input mesh
  if (!inherits(mesh, "mesh3d"))
    stop(deparse(substitute(mesh)), " is not a mesh3d object.")

  # Extract edges from triangular and quadrilateral faces
  edges <- NULL

  if (length(mesh$it))
    edges <- cbind(edges, mesh$it[1:2,],  mesh$it[2:3,], mesh$it[c(3,1),])

  if (length(mesh$ib))
    edges <- cbind(edges, mesh$ib[1:2,], mesh$ib[2:3,], mesh$ib[3:4,], mesh$ib[c(4,1),])

  # Return an empty matrix if the mesh contains no edges
  if (is.null(edges) || ncol(edges) == 0) {
    return(matrix(integer(0), nrow = 2))
  }

  # Sort edge endpoints to represent undirected edges
  minV <- pmin(edges[1,], edges[2,])
  maxV <- pmax(edges[1,], edges[2,])

  if (!requireNamespace("data.table", quietly = TRUE)) stop("package 'data.table' is required")

  # Create a table of edge endpoints with data.table
  edgeTable <- data.table::data.table(v1 = minV, v2 = maxV)

  # Count the frequency of each edge
  edgeCounts <- edgeTable[, .N, by = .(v1, v2)]

  # Keep edges that appear only once
  boundaryEdges <- edgeCounts[N == 1]

  # Select edges satisfying the condition
  keep <- paste(edgeTable$v1, edgeTable$v2) %in% paste(boundaryEdges$v1, boundaryEdges$v2)

  # Extract boundary edges
  boundary <- edges[, keep, drop = FALSE]

  if (!requireNamespace("rgl", quietly = TRUE)) stop("package 'rgl' is required")

  # Return a mesh3d object if requested
  if (returnMesh) {
    result <- rgl::mesh3d(vertices = mesh$vb, segments = boundary)
    if (simplify)
      result <- cleanMesh3d(result)
    return(result)
  }

  boundary
}
