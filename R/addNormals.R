#' Compute vertex normals by averaging triangle normals
#'
#' Computes the normals of the vertices of a triangular mesh
#' by averaging the normals of the triangles.
#'
#' @param x A `mesh3d` object.
#' @param normals.tri  A 4 x ntri matrix of triangle normals.
#' If not provided, they are computed internally using `normals.mesh3d()`.
#'
#' @returns A `mesh3d` object with the `normals` field updated,
#' containing the unit normals for each vertex.
#'
#' @details
#' This function simply averages the normals of the triangles for each vertex.
#' No weighting by area or angle is applied.
#'
#' @examples
#' # Create a triangular mesh
#' mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)
#'
#' # Compute triangle normals (for more robustness, Rvcg::vcgFaceNormals() can be used)
#' norm_tri <- normals.mesh3d(mesh)
#'
#' # Compute vertex normals by averaging triangle normals
#' mesh <- addNormals(mesh, norm_tri)
#'
#' # Show the first 5 vertex normals
#' mesh$normals[, 1:5]
#'
#' @export
addNormals <- function(x, normals.tri) {
  ntri <- ncol(x$it)
  if (!ntri)
    stop("Argument 'x' must be a triangular mesh")
  if (missing(normals.tri)) normals.tri <- normals.mesh3d(x)
  normals.tri <- normals.tri[1:3, ]
  normals <- matrix(0, nrow = 3, ncol = ncol(x$vb))
  for (j in seq_len(ntri)) {
    ivb <- x$it[, j]
    normals[, ivb] <- normals[, ivb] + normals.tri[, j]
  }
  normals <- rbind(apply(normals, 2, function(n) n/sqrt(sum(n^2))), 1)
  x$normals <- normals
  x
}
