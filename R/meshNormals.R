#' Compute face normals of a triangular mesh
#'
#' Computes unit normals for the triangles of a `mesh3d` object
#' using cross products.
#'
#' This function is primarily intended for teaching and comparison purposes.
#' For general use, it is recommended to use `Rvcg::vcgFaceNormals()`,
#' which is more efficient and robust.
#'
#' @param x A `mesh3d` object with triangular topology.
#' Must contain elements `vb` (vertices) and `it` (triangle indices).
#'
#' @returns A 4 x ntri matrix containing the homogeneous normals of each triangle.
#' Each column represents a unit normal vector, with the fourth row set to 1
#' for homogeneous coordinates.
#'
#' @details
#' For each triangle, the normal is computed as the cross product of two of its
#' edges and then normalized to unit length. If the vertices are in homogeneous
#' coordinates (fourth row not equal to 1), they are normalized before computing
#' the normals.
#'
#' @seealso \code{\link[Rvcg]{vcgFaceNormals}}
#'
#' @examples
#' # Create a triangular mesh
#' mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)
#'
#' # Compute normals
#' norm <- meshNormals(mesh)
#'
#' # Display the first 5 normals
#' norm[, 1:5]
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
    n <- xprod( v[, it[1]] - v[, it[3]],
                v[, it[2]] - v[, it[1]])
    # Normalize
    # return(c(n/sqrt(sum(n^2)), 1))
    return(n/sqrt(sum(n^2)))
  }
  # Compute normals and homogenize
  # normals <- apply(x$it, 2, normal)
  normals <- rbind(apply(x$it, 2, normal), 1)
  normals
}
