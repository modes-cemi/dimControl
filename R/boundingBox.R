#' Compute the Bounding Box of a 3D Mesh
#'
#' Computes the minimum and maximum coordinates of the vertices of a 3D mesh, along
#' the `X`, `Y`, and `Z` axes.
#'
#' @param x A `mesh3d` object containing the mesh vertices in the `vb` component.
#'
#' @returns
#' A 3 x 2 matrix with rows corresponding to the `X`, `Y`, and `Z` axes and columns
#' `min` and `max`.
#'
#' @details
#' Homogeneous coordinates in `x$vb` are converted to Euclidean coordinates using
#' [rgl::asEuclidean2()] before computing the coordinate ranges.
#'
#' @seealso [rgl::asEuclidean2()]
#'
#' @examples
#' \dontrun{
#' # Create a cubic mesh
#' cube <- rgl::cube3d()
#'
#' # Compute its bounding box
#' boundingBox(cube)
#' }
#'
#' @export
boundingBox <- function(x) {
  t(matrix(
    apply(rgl::asEuclidean2(x$vb), 1, range),
    nrow = 2,
    dimnames = list(c("min", "max"), c("X", "Y", "Z"))
  ))
}
