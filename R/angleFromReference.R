#' Angle Between a Set of Vectors and a Reference Vector
#'
#' Computes the angle between each column of a matrix of vectors and a reference vector.
#'
#' @param v Numeric matrix of dimension \code{d x n}. Each column represents a vector.
#' @param a Numeric vector of dimension \code{d}.
#' @param deg Logical. If `TRUE`, returns the angles in degrees; if `FALSE`, in radians.
#'
#' @returns A numeric vector containing the angles between each vector in \code{v} and \code{a}.
#'
#' @details
#' The function uses `angle0()` to calculate each angle, ensuring numerical stability
#' by limiting the argument of `acos()` to the interval \eqn{[-1, 1]}.
#' The matrix `v` can have any number of columns, and the vector `a` must have
#' the same dimension as the columns of `v`.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0), nrow = 3)
#' a <- c(1, 0, 0)
#' angleFromReference(v, a, deg = TRUE)
#'
#' @export
angleFromReference <- function(v, a, deg = TRUE) {
  res <- apply(v, 2, function(b) angle0(b, a))
  if (deg) res <- rad2deg(res)
  return(res)
}
