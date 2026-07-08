#' Angle Between Two Vectors
#'
#' Computes the angle between two numeric vectors.
#'
#' If `normalized = FALSE`, the vectors are internally normalized before
#' computing the angle. If `normalized = TRUE`, both `a` and `b` are assumed to
#' be unit vectors, i.e., vectors with Euclidean norm equal to 1.
#'
#' To avoid numerical errors in `acos()`, the cosine value is clamped to the
#' interval \eqn{[-1, 1]}.
#'
#' @param a Numeric vector.
#' @param b Numeric vector with the same length as `a`.
#' @param normalized Logical. If `TRUE`, `a` and `b` are assumed to be already
#' normalized. If `FALSE`, internal normalization is performed.
#' @param deg Logical. If `TRUE`, the angle is returned in degrees; otherwise
#' in radians.
#'
#' @returns A numeric value containing the angle between `a` and `b`.
#'
#' @examples
#' a <- c(1, 0, 0)
#' b <- c(0, 1, 0)
#'
#' angleBetween(a, b, normalized = FALSE, deg = TRUE)
#'
#' @export
angleBetween <- function(a, b, normalized = FALSE, deg = TRUE) {
  if (normalized) {
    cosval <- sum(a * b)
  } else {
    cosval <- sum(a * b) / sqrt(sum(a^2) * sum(b^2))
  }

  # Numerical correction
  cosval <- min(1, max(-1, cosval))

  res <- acos(cosval)

  if (deg) res <- rad2deg(res)

  res
}
