#' Conversion from Radians to Degrees
#'
#' Converts angular values expressed in radians to degrees.
#'
#' @param x A numeric value or numeric vector in radians.
#'
#' @returns A numeric value or numeric vector with the angles converted to degrees.
#'
#' @details
#' The conversion from radians to degrees is defined as:
#'
#' \deqn{
#' \mathrm{degrees} = \mathrm{radians} \frac{180}{\pi}
#' }
#'
#' @examples
#' \dontrun{
#' radDeg(pi)
#' radDeg(c(0, pi/2, pi))
#' }
#'
#' @export
radDeg <- function(x) {
  (x / pi) * 180
}
