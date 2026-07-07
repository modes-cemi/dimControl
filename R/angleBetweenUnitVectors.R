#' Angle Between Two Normalized Vectors
#'
#' Computes the angle between two three-dimensional vectors that have been
#' previously normalized, using the dot product directly.
#'
#' @param a Numeric vector of dimension 3, normalized to unit length.
#' @param b Numeric vector of dimension 3, normalized to unit length.
#'
#' @returns A numeric value corresponding to the angle between the vectors, in radians.
#'
#' @examples
#' a <- c(1, 0, 0)
#' b <- c(0, 1, 0)
#' angleBetweenUnitVectors(a, b)
#'
#' @export
angleBetweenUnitVectors <- function(a, b) {
  acos(sum(a*b))
}
