#' Directional Angle Computation for Normalized Vectors
#'
#' Computes the directional angle between a set of normalized vectors and a reference
#' direction in a specific dimension. The function allows returning the result in
#' degrees or radians and optionally considering the opposite direction.
#'
#' @param v A numeric matrix of dimension \code{d x n}. Each column represents a normalized vector.
#' @param dim Integer indicating the reference dimension, with \code{1 <= dim <= d}.
#' @param negdir Logical. If `TRUE`, considers the negative direction (complementary angle).
#' @param deg Logical. If `TRUE`, returns angles in degrees; if `FALSE`, returns them in radians.
#'
#' @returns A numeric vector containing the computed angles for each input vector.
#'
#' @examples
#' # Three normalized vectors in the X, Y, and Z directions
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' # Angle with respect to the X axis
#' angleFromAxisDirection(v, dim = 1)
#'
#' # Angle with respect to the Y axis
#' angleFromAxisDirection(v, dim = 2)
#'
#' # Angle with respect to the Z axis
#' angleFromAxisDirection(v, dim = 3)
#'
#' @export
angleFromAxisDirection <- function(v, dim, negdir = FALSE, deg = TRUE) {
  # Convert radians to degrees
  rad2deg <- function(x) (x / pi) * 180

  # Compute directional angle
  res <- acos(v[dim, ])
  if (negdir) res <- pi - res
  if (deg) res <- rad2deg(res)
  return(res)
}
