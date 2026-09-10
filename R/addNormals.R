#' Compute Vertex Normals by Averaging Triangle Normals
#'
#' Computes the normals of the vertices of a triangular mesh by averaging the normals
#' of the triangles.
#'
#' @param x A `mesh3d` object.
#' @param normalsTri  A 4 x nTri matrix of triangle normals. If not provided, they
#' are computed internally using `meshNormals()`.
#'
#' @returns A `mesh3d` object with the `normals` field updated, containing the unit
#' normals for each vertex.
#'
#' @details
#' This function simply averages the normals of the triangles for each vertex. No
#' weighting by area or angle is applied.
#'
#' @examples
#' \dontrun{
#' # Create a triangular mesh
#' mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)
#'
#' # Compute triangle normals
#' normTri <- meshNormals(mesh)
#'
#' # Compute vertex normals by averaging triangle normals
#' mesh <- addNormals(mesh, normTri)
#'
#' # Show the first five vertex normals
#' mesh$normals[, 1:5]
#' }
#'
#' @export
addNormals <- function(x, normalsTri) {
  nTri <- ncol(x$it)
  if (!nTri)
    stop("Argument 'x' must be a triangular mesh")
  if (missing(normalsTri)) normalsTri <- meshNormals(x)
  normalsTri <- normalsTri[1:3, ]
  normals <- matrix(0, nrow = 3, ncol = ncol(x$vb))
  for (j in seq_len(nTri)) {
    ivb <- x$it[, j]
    normals[, ivb] <- normals[, ivb] + normalsTri[, j]
  }
  normals <- rbind(apply(normals, 2, function(n) n/sqrt(sum(n^2))), 1)
  x$normals <- normals
  x
}
