#' Compute the Euclidean Distance Between Two Points
#'
#' Computes the linear (Euclidean) distance from a vector of differences between the
#' coordinates of two points.
#'
#' @param h A numeric vector containing the differences between the coordinates of
#' two points (for example, \code{(x2 - x1, y2 - y1, z2 - z1)}).
#'
#' @returns A numeric value representing the Euclidean distance between the two points.
#'
#' @examples
#' # Differences between two points in 3D
#' h <- c(3 - 0, 4 - 0, 0 - 0)
#'
#' # Compute the Euclidean distance
#' deuclid(h)
#'
#' @export
deuclid <- function(h) {
  sqrt(sum((h)^2))
}
