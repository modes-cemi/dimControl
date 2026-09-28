#' Compute the Euclidean distance between two points
#'
#' Computes the Euclidean distance between two points from a vector containing the
#' differences between their coordinates.
#'
#' @param h Numeric vector containing the differences between the coordinates of two
#' points, for example `c(x2 - x1, y2 - y1, z2 - z1)`.
#'
#' @returns
#' Numeric value representing the Euclidean distance between the two points.
#'
#' @details
#' The Euclidean distance is computed as:
#'
#' \deqn{d = \sqrt{\sum_i h_i^2}},
#'
#' where \eqn{h_i} represents the coordinate difference along dimension \eqn{i}.
#'
#' @examples
#' # Differences between two points in 3D
#' h <- c(3 - 0, 4 - 0, 0 - 0)
#'
#' # Compute the Euclidean distance
#' euclideanDistance(h)
#'
#' @export
euclideanDistance <- function(h) {
  sqrt(sum((h)^2))
}
