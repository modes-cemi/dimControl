#' Compute the Spatial Bounds (Bounding Box) of a 3D Mesh
#'
#' Computes the minimum and maximum coordinates of the vertices of a 3D mesh, returning
#' a matrix with the extreme values along the `X`, `Y`, and `Z` axes.
#'
#' @param x A `mesh3d` object containing the mesh vertices in the `vb` component.
#'
#' @returns
#' A matrix with 3 rows and 2 columns containing the minimum and maximum coordinate
#' values of the mesh vertices:
#' - Each row corresponds to an axis (`X`, `Y`, `Z`).
#' - The first column (`min`) contains the minimum values.
#' - The second column (`max`) contains the maximum values.
#'
#' @details
#' Internally, the function converts homogeneous coordinates in `x$vb` to Euclidean
#' coordinates using `rgl::asEuclidean2()`, and computes per-axis ranges using `apply(..., range)`.
#'
#' @seealso `rgl::asEuclidean2()`
#'
#' @examples
#' # Create a cubic mesh
#' cube <- rgl::cube3d()
#'
#' # Compute its bounding box
#' bbox(cube)
#'
#' @export
bbox <- function(x) {
  t(matrix(
    apply(rgl::asEuclidean2(x$vb), 1, range),
    nrow = 2,
    dimnames = list(c("min", "max"), c("X", "Y", "Z"))
  ))
}
