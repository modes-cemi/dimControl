#' Calculate Distance over a 3D Surface
#'
#' Computes the total length of a 3D path by summing the Euclidean distances between
#' consecutive points. Useful for estimating the distance traveled over a 3D surface.
#'
#' @param segmento A matrix or data frame with three columns (`x`, `y`, `z`) representing
#' the coordinates of consecutive points in 3D space.
#'
#' @returns A numeric value indicating the total distance traveled along the surface.
#'
#' @export
surfaceDistance <- function(segmento) {
  dx <- diff(segmento[, 1])  # Differences in x
  dy <- diff(segmento[, 2])  # Differences in y
  dz <- diff(segmento[, 3])  # Differences in z

  # Euclidean distance between consecutive points
  distances <- sqrt(dx^2 + dy^2 + dz^2)

  # Total length of the path
  total_length <- sum(distances)

  return(total_length)
}
