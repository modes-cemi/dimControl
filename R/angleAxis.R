#' Directional angle relative to an axis
#'
#' Computes the angle between vectors and a reference coordinate axis.
#'
#' @param v Numeric 3 x n or 4 x n matrix, where each column represents a vector.
#' @param dim Integer. Coordinate axis used as reference: `1` for X, `2` for Y, and
#' `3` for Z.
#' @param negative Logical. If `TRUE`, the negative direction of the selected axis
#' is used. If `FALSE`, the positive direction is used.
#' @param normalized Logical. If `TRUE`, the columns of `v` are assumed to be unit
#' vectors. If `FALSE`, they are internally normalized.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise, in radians.
#'
#' @returns
#' Numeric vector containing the directional angles.
#'
#' @details
#' The vectors in `v` are converted to Euclidean coordinates using `rgl::asEuclidean2()`.
#' Therefore, `v` can be provided as a 3 x n matrix of Euclidean vectors or a 4 x n
#' matrix of homogeneous coordinates.
#'
#' If `normalized = FALSE`, the Euclidean vectors are normalized to unit length before
#' computing the angles.
#'
#' The argument `dim` selects the coordinate axis used as reference: `dim = 1` for X,
#' `dim = 2` for Y, and `dim = 3` for Z. If `negative = TRUE`, the negative direction
#' of the selected axis is used.
#'
#' To avoid numerical errors in `acos()`, cosine values are clamped to the interval \eqn{[-1, 1]}.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' angleAxis(v, dim = 1)
#' angleAxis(v, dim = 1, negative = TRUE)
#'
#' # Non-normalized vectors
#' v2 <- v * 2
#'
#' angleAxis(v2, dim = 1, normalized = FALSE)
#'
#' @export
angleAxis <- function(v, dim, negative = FALSE, normalized = TRUE, deg = TRUE) {

  if (!requireNamespace("rgl", quietly = TRUE)) stop("package 'rgl' is required")

  # Check coordinate axis
  if (length(dim) != 1L || !dim %in% 1:3)
    stop("Argument 'dim' must be 1, 2, or 3")

  # Convert to Euclidean coordinates
  v <- rgl::asEuclidean2(v)

  # Normalize only when necessary
  if (!normalized) v <- .normalize(v)

  # Extract the cosine relative to the selected axis
  cosVal <- v[dim, ]

  # Numerical correction
  cosVal <- pmin(1, pmax(-1, cosVal))

  # Compute the angle relative to the selected axis
  res <- acos(cosVal)

  # Use the negative direction of the selected axis
  if (negative) res <- pi - res

  # Convert radians to degrees
  if (deg) res <- .radDeg(res)

  res
}
