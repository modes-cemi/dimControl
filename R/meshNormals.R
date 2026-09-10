#' Compute Face Normals of a Triangular Mesh
#'
#' Computes unit normals for the triangles of a `mesh3d` object using cross products.
#'
#' @param x A `mesh3d` object with triangular topology. Must contain elements `vb`
#' (vertices) and `it` (triangle indices).
#'
#' @returns A 4 x nTri matrix containing the homogeneous normals of each triangle.
#' Each column represents a unit normal vector, with the fourth row set to 1.
#'
#' @details
#' For each triangle, the normal is computed as the cross product of two of its edges
#' and then normalized to unit length. If the vertices are in homogeneous coordinates,
#' they are converted before computing the normals.
#'
#' @seealso [Rvcg::vcgFaceNormals()], [addNormals()]
#'
#' @examples
#' \dontrun{
#' # Create a triangular mesh
#' mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)
#'
#' # Compute triangle normals
#' normals <- meshNormals(mesh)
#'
#' # Display the first five normals
#' normals[, 1:5]
#' }
#'
#' @export
meshNormals <- function(x) {
  if (!length(x$it))
    stop("Argument 'x' must be a triangular mesh")
  v <- x$vb
  # Make sure v is homogeneous with unit w
  if (nrow(v) == 4) {
    w <- v[4, ]
    v <- v[1:3,]
    if (!all(w == 1)) v <- t( t(v)/w )
  }
  # Compute normal from vertex indices
  normal <- function(it) {
    n <- xProd( v[, it[1]] - v[, it[3]],
                v[, it[2]] - v[, it[1]])
    # Normalize
    return(n/sqrt(sum(n^2)))
  }
  # Compute normals and homogenize
  normals <- rbind(apply(x$it, 2, normal), 1)
  normals
}

