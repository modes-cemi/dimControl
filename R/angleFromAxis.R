#' Directional Angle from an Axis
#'
#' Computes the directional angle between normalized vectors and a reference coordinate
#' axis.
#'
#' @param v Numeric matrix of dimension `d x n` containing normalized vectors by columns.
#' @param dim Integer. Coordinate axis used as reference.
#' @param negDir Logical. If `TRUE`, the negative direction of the selected axis is
#' used. Default is `FALSE`.
#' @param dir Optional numeric value, either \eqn{1} or \eqn{-1}. If provided, `dir = -1`
#' is equivalent to `negDir = TRUE`, and `dir = 1` to `negDir = FALSE`. Default is `NULL`.
#' @param deg Logical. If `TRUE`, angles are returned in degrees; otherwise, in radians.
#'
#' @returns A numeric vector containing the directional angles.
#'
#' @details
#' The argument `dim` selects the coordinate axis used as reference: `dim = 1` for
#' X, `dim = 2` for Y, and `dim = 3` for Z.
#'
#' @seealso [radDeg()]
#'
#' @examples
#' \dontrun{
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' angleFromAxis(v, dim = 1, negDir = FALSE, deg = TRUE)
#' angleFromAxis(v, dim = 1, negDir = TRUE,  deg = TRUE)
#' }
#'
#' @export
angleFromAxis <- function(v, dim, negDir = FALSE, dir = NULL, deg = TRUE) {
  if (!is.null(dir)) negDir <- (dir == -1)

  res <- acos(v[dim, ])

  if (negDir) res <- pi - res
  if (deg) res <- radDeg(res)

  res
}
