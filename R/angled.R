#' Directional Angles of Normalized Vectors
#'
#' Computes the directional angle between each column of a matrix of
#' normalized vectors and the canonical axis specified by `dim`,
#' optionally reversed by `dir`.
#'
#' The angle is computed as \eqn{\theta = \arccos(dir * v[dim, ])}.
#' All vectors must be unit vectors (Euclidean norm equal to 1).
#' No internal normalization is performed.
#'
#' @param v Numeric matrix of dimension \code{d x n} containing normalized vectors.
#' @param dim Integer specifying the reference dimension (\code{1 <= dim <= d}).
#' @param dir Numeric scalar equal to `1` or `-1` indicating the orientation of the reference axis.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise in radians.
#'
#' @returns A numeric vector of length `n` containing the directional
#'   angles between each column of `v` and the axis \eqn{\pm e_{dim}}.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#' angled(v, dim = 1, dir = 1, deg = TRUE)
#'
#' @export
angled <- function(v, dim, dir = 1, deg = TRUE) {
  res <- acos(dir * v[dim, ])
  if (deg) res <- rad2deg(res)
  return(res)
}
