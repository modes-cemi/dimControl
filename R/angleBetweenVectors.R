#' Angle Between Two 3D Vectors
#'
#' Computes the angle between two three-dimensional vectors using the dot product.
#' The result is restricted to the interval \eqn{[0, \pi]}.
#'
#' @param a Numeric vector of dimension 3.
#' @param b Numeric vector of dimension 3.
#'
#' @returns A numeric value corresponding to the angle between the vectors, in radians.
#'
#' @details
#' The function applies a numerical correction to ensure that the argument of
#' `acos()` lies within the interval \eqn{[-1, 1]}.
#'
#' @examples
#' a <- c(1, 0, 0)
#' b <- c(0, 1, 0)
#' angleBetweenVectors(a, b)
#'
#' @export
angleBetweenVectors <- function(a, b) {
  acos(min(1, max(-1, sum(a*b)/sqrt(sum(a^2) * sum(b^2)))))
}
