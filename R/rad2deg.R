#' Conversion from Radians to Degrees
#'
#' Converts angular values expressed in radians to degrees.
#'
#' @param x A numeric value or numeric vector in radians.
#'
#' @returns A numeric value or numeric vector with the angles converted to degrees.
#'
#' @examples
#' rad2deg(pi)
#' rad2deg(c(0, pi/2, pi))
#'
#' @export
rad2deg <- function(x) {
  (x / pi) * 180
}
