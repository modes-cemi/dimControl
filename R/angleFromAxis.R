#' Directional Angle from an Axis
#'
#' Computes the directional angle between normalized vectors and a reference
#' coordinate axis.
#'
#' The input `v` must contain normalized vectors by columns. The argument `dim`
#' selects the coordinate axis used as reference. For example, `dim = 1` uses the
#' X axis, `dim = 2` uses the Y axis and `dim = 3` uses the Z axis.
#'
#' If `negdir = TRUE`, the angle is computed with respect to the negative
#' direction of the selected axis. The argument `dir` is kept for compatibility:
#' if provided, `dir = -1` is equivalent to `negdir = TRUE`, and `dir = 1` is
#' equivalent to `negdir = FALSE`.
#'
#' @param v Numeric matrix of dimension \code{d x n} containing normalized
#' vectors by columns.
#' @param dim Integer. Coordinate axis used as reference.
#' @param negdir Logical. If `TRUE`, the negative direction of the selected axis
#' is used. Default is `FALSE`.
#' @param dir Optional numeric value, either $1$ or $-1$. Compatibility argument
#' for selecting the positive or negative direction of the axis. Default is
#' `NULL`.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise in
#' radians.
#'
#' @returns A numeric vector containing the directional angles.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' angleFromAxis(v, dim = 1, negdir = FALSE, deg = TRUE)
#' angleFromAxis(v, dim = 1, negdir = TRUE,  deg = TRUE)
#'
#' @export
angleFromAxis <- function(v, dim, negdir = FALSE, dir = NULL, deg = TRUE) {
  if (!is.null(dir)) negdir <- (dir == -1)

  res <- acos(v[dim, ])

  if (negdir) res <- pi - res
  if (deg) res <- rad2deg(res)

  res
}
