#' Extract the Boundary of a 3D Mesh
#'
#' Identifies the unshared edges of a 3D mesh, i.e., edges belonging to only one face.
#' These edges can be returned either as vertex indices or as a `mesh3d` object consisting
#' of the corresponding segments.
#'
#' This function is an adaptation of `rgl::getBoundary3d()`. Unlike the original version,
#' which detects boundary edges by finding duplicates in the edge list, this implementation
#' uses a frequency table (`data.table`) to count how many times each edge appears in the mesh faces.
#' Edges that appear only once are considered boundary edges. Additionally, the function
#' allows returning either the vertex indices of the boundary edges or a `mesh3d` mesh
#' of the segments, with an optional additional simplification.
#'
#' @param mesh A `mesh3d` object representing the 3D mesh.
#' @param malla Logical. If `TRUE`, returns a `mesh3d` object containing the boundary segments;
#' if `FALSE`, returns only the vertex indices forming the boundary edges. Default is `FALSE`.
#' @param simplify Logical. If `TRUE` and `malla = TRUE`, simplifies the resulting mesh
#' using `cleanMesh3d()`. Default is `TRUE`.
#'
#' @returns If `malla = FALSE`, a matrix with the vertex indices forming the boundary edges.
#' If `malla = TRUE`, a `mesh3d` object representing the boundary segments.
#'
#' @seealso `rgl::getBoundary3d()`, `cleanMesh3d()`
#'
#' @examples
#' # Extract the boundary of a cube and visualize it
#' require(data.table)
#'
#' # Create a cube and remove two faces
#' x <- rgl::cube3d(col = "lightblue")
#' x$ib <- x$ib[, -(1:2)]
#'
#' # Generate the boundary
#' b <- getBoundarySegments(x, malla = TRUE)
#'
#' # Visualize the mesh and its boundary
#' rgl::open3d()
#' rgl::shade3d(x, alpha = 0.2)
#' rgl::shade3d(b, col = "red", lwd = 2)
#'
#' @importFrom data.table data.table
#'
#' @export
getBoundarySegments <- function(mesh, malla = FALSE, simplify = TRUE) {
  if (!inherits(mesh, "mesh3d"))
    stop(deparse(substitute(mesh)), " is not a mesh3d object.")
  edges <- NULL
  if (length(mesh$it))
    edges <- cbind(edges, mesh$it[1:2,],  mesh$it[2:3,], mesh$it[c(3,1),])
  if (length(mesh$ib))
    edges <- cbind(edges, mesh$ib[1:2,], mesh$ib[2:3,], mesh$ib[3:4,], mesh$ib[c(4,1),])
  if (!ncol(edges)) return(list(edges))

  # Sort the endpoints of each edge to make them undirected
  minv <- pmin(edges[1,], edges[2,])
  maxv <- pmax(edges[1,], edges[2,])

  # data.table of edge endpoints
  dt_edges <- data.table(v1 = minv, v2 = maxv)

  # Count frequency of each edge
  counts <- dt_edges[, .N, by = .(v1, v2)]

  # Filter edges that appear only once
  boundary_edges <- counts[N == 1]

  # Select edges satisfying the condition
  keep <- paste(dt_edges$v1, dt_edges$v2) %in% paste(boundary_edges$v1, boundary_edges$v2)

  # Boundary edges
  boundary <- edges[, keep, drop = FALSE]

  # If malla = TRUE, create a mesh3d with these segments
  if (malla) {
    result <- rgl::mesh3d(vertices = mesh$vb, segments = boundary)
    if (simplify)
      result <- cleanMesh3d(result)
    return(result)
  }

  # Otherwise, return the indices of boundary segments
  return(boundary)
}
