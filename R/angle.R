#' Angles between vectors
#'
#' Computes angles between vectors, either pairwise or between a single vector and
#' multiple vectors.
#'
#' @param v Numeric vector of length 3 or 4, or 3 x n or 4 x n matrix, where each column
#' represents a vector.
#' @param w Numeric vector of length 3 or 4, or 3 x n or 4 x n matrix, where each column
#' represents a vector.
#' @param normalized Logical. If `TRUE`, the vectors in `v` and `w` are assumed to be
#' unit vectors. If `FALSE`, they are internally normalized.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise, in radians.
#'
#' @returns
#' Numeric vector containing the angles between the vectors.
#'
#' @details
#' The vectors in `v` and `w` are converted to Euclidean coordinates using `rgl::asEuclidean2()`.
#' Therefore, vectors and matrices can be provided in Euclidean or homogeneous coordinates.
#'
#' If one argument is a single vector and the other contains multiple vectors, the angle
#' between the single vector and each of the other vectors is computed. If both arguments
#' contain multiple vectors, angles are computed column by column between corresponding
#' vectors.
#'
#' If `normalized = FALSE`, the Euclidean vectors are normalized to unit length before
#' computing the angles.
#'
#' To avoid numerical errors in `acos()`, cosine values are clamped to the interval \eqn{[-1, 1]}.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' # Compute angles with a single vector
#' w <- c(1, 0, 0)
#'
#' angle(v, w)
#'
#' # Compute angles between corresponding vectors
#' w2 <- matrix(c(1, 0, 0,
#'                1, 0, 0,
#'                0, 1, 0), nrow = 3)
#'
#' angle(v, w2)
#'
#' @export
angle <- function(v, w, normalized = TRUE, deg = TRUE) {

  if (!requireNamespace("rgl", quietly = TRUE)) stop("package 'rgl' is required")

  # Convert inputs to matrices
  v <- as.matrix(v)
  w <- as.matrix(w)

  # Convert to Euclidean coordinates
  v <- rgl::asEuclidean2(v)
  w <- rgl::asEuclidean2(w)

  # Check compatible dimensions
  if (nrow(v) != nrow(w))
    stop("Arguments 'v' and 'w' must have the same number of coordinates")

  if (ncol(v) != ncol(w) && ncol(v) != 1L && ncol(w) != 1L)
    stop("Arguments 'v' and 'w' must have the same number of vectors, or one must contain a single vector")

  # Normalize only when necessary
  if (!normalized) {
    v <- .normalize(v)
    w <- .normalize(w)
  }

  # Compute cosine values
  if (ncol(v) == 1L && ncol(w) > 1L)
    v <- v[, rep(1L, ncol(w)), drop = FALSE]

  if (ncol(w) == 1L && ncol(v) > 1L)
    w <- w[, rep(1L, ncol(v)), drop = FALSE]

  cosVal <- colSums(v * w)

  # Numerical correction
  cosVal <- pmin(1, pmax(-1, cosVal))

  # Compute angles
  res <- acos(cosVal)

  # Convert radians to degrees
  if (deg) res <- .radDeg(res)

  res
}
