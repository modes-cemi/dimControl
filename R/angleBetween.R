#' Angle Between Two Vectors
#'
#' Computes the angle between two numeric vectors.
#'
#' @param a Numeric vector.
#' @param b Numeric vector with the same length as `a`.
#' @param normalized Logical. If `TRUE`, `a` and `b` are assumed to be unit vectors.
#' If `FALSE`, they are internally normalized.
#' @param deg Logical. If `TRUE`, the angle is returned in degrees; otherwise, in radians.
#'
#' @returns A numeric value containing the angle between `a` and `b`.
#'
#' @details
#' The angle between two vectors is computed as:
#'
#' \deqn{
#' \theta = \arccos\left(
#' \frac{a \cdot b}{\lVert a \rVert \lVert b \rVert}
#' \right)
#' }
#'
#' To avoid numerical errors in `acos()`, the cosine value is clamped to the interval
#' \eqn{[-1, 1]}.
#'
#' @seealso [radDeg()]
#'
#' @examples
##' \dontrun{
#' a <- c(1, 0, 0)
#' b <- c(0, 1, 0)
#'
#' angleBetween(a, b, normalized = FALSE, deg = TRUE)
#' }
#'
#' @export
angleBetween <- function(a, b, normalized = FALSE, deg = TRUE) {
  if (normalized) {
    cosVal <- sum(a * b)
  } else {
    cosVal <- sum(a * b) / sqrt(sum(a^2) * sum(b^2))
  }

  # Numerical correction
  cosVal <- min(1, max(-1, cosVal))

  res <- acos(cosVal)

  if (deg) res <- radDeg(res)

  res
}
