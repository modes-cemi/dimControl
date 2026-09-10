#' Angles Between Vectors and Reference Vectors
#'
#' Computes angles between the columns of `v` and one or more reference vectors.
#'
#' @param v Numeric vector or matrix. If a matrix, each column represents one vector.
#' @param w Numeric vector or matrix used as reference. If a vector, it is used as
#' a common reference for all columns of `v`; if a matrix, it must be compatible with
#' `v` for column-wise angle computation.
#' @param normalized Logical. If `TRUE`, vectors are assumed to be already normalized.
#' If `FALSE`, internal normalization is performed.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise, in radians.
#'
#' @returns A numeric vector containing the computed angles.
#'
#' @details
#' If `w` is a vector, it is used as a single reference vector for all columns of `v`.
#' If `w` is a matrix, angles are computed column by column between `v` and `w`.
#'
#' To avoid numerical errors in `acos()`, cosine values are clamped to the interval
#' \eqn{[-1, 1]}.
#'
#' @seealso [radDeg()]
#'
#' @examples
#' \dontrun{
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' w <- c(1, 0, 0)
#'
#' angleFromVectors(v, w, normalized = FALSE, deg = TRUE)
#' }
#'
#' @export
angleFromVectors <- function(v, w, normalized = FALSE, deg = TRUE) {
  v <- as.matrix(v)

  dots <- colSums(v * w)

  if (normalized) {
    cosVal <- dots
  } else {
    normV <- sqrt(colSums(v^2))
    normW <- if (is.matrix(w)) sqrt(colSums(as.matrix(w)^2)) else sqrt(sum(w^2))
    cosVal <- dots / (normV * normW)
  }

  cosVal <- pmin(1, pmax(-1, cosVal))

  res <- acos(cosVal)

  if (deg) res <- radDeg(res)

  res
}
