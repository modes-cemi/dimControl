#' Angle Between Normalized Vectors and a Reference Vector
#'
#' Computes the angle between each column of a matrix of normalized
#' vectors and a normalized reference vector.
#'
#' Both `v` and `a` must contain unit vectors (i.e., Euclidean norm equal to 1).
#' No internal normalization is performed.
#'
#' @param v Numeric matrix of dimension \code{d x n} containing normalized vectors.
#' @param a Numeric normalized vector of length \code{d}.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise in radians.
#'
#' @returns A numeric vector of length \code{n} containing the angles
#'   between each column of `v` and `a`.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0), nrow = 3)
#' a <- c(1, 0, 0)
#' anglen(v, a, deg = TRUE)
#'
#' @export
anglen <- function(v, a, deg = TRUE) {
  res <- apply(v, 2, function(b) angleBetweenUnitVectors(b, a))
  if (deg) res <- rad2deg(res)
  return(res)
}
