#' Calculate Distance over a 3D Surface
#'
#' Computes the total length of a 3D path by summing the Euclidean distances between
#' consecutive points.
#'
#' @param segment A matrix or data frame with three columns representing the X, Y,
#' and Z coordinates of consecutive points in 3D space.
#'
#' @returns
#' A numeric value representing the total length of the 3D path.
#'
#' @details
#' The distance between two consecutive points is computed as:
#'
#' \deqn{
#' d_i = \sqrt{(x_{i+1} - x_i)^2 + (y_{i+1} - y_i)^2 + (z_{i+1} - z_i)^2}
#' }
#'
#' and the total path length is obtained by summing these distances.
#'
#' @examples
#' \dontrun{
#' segment <- matrix(
#'   c(
#'     0, 0, 0,
#'     3, 4, 0,
#'     3, 4, 5
#'   ),
#'   ncol = 3,
#'   byrow = TRUE
#' )
#'
#' surfaceDistance(segment)
#' }
#'
#' @export
surfaceDistance <- function(segment) {

  # Coordinate differences between consecutive points
  dx <- diff(segment[, 1])
  dy <- diff(segment[, 2])
  dz <- diff(segment[, 3])

  # Euclidean distance between consecutive points
  distances <- sqrt(dx^2 + dy^2 + dz^2)

  # Total path length
  totalLength <- sum(distances)

  return(totalLength)
}
