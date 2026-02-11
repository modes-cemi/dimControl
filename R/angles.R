#' Angles Between Two Sets of 3D Vectors
#'
#' Computes the angles between corresponding vectors from two sets
#' of three-dimensional vectors. Each column of the input matrices represents
#' a 3D vector.
#'
#' @param v Numeric vector or matrix with at least 3 rows. Each column represents a vector.
#' @param w Numeric vector or matrix with at least 3 rows. Each column represents a vector.
#' @param deg Logical. If `TRUE`, returns the angles in degrees; if `FALSE`, in radians.
#'
#' @returns A numeric vector containing the angles between each pair of corresponding vectors.
#'
#' @details
#' The function uses an internal helper `as.list2()` to convert the input
#' into a list of 3D vectors:
#' \itemize{
#'   \item If the input is a vector of length 3, it returns a list containing that vector.
#'   \item If the input is a matrix \eqn{3 \times n}, it returns a list where each element is a column of the matrix.
#' }
#' Angles are calculated using the dot product and the \code{acos()} function,
#' with numerical correction to ensure stability.
#'
#' @examples
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0), nrow = 3)
#' w <- matrix(c(0, 1, 0,
#'               1, 0, 0), nrow = 3)
#' angles(v, w, deg = TRUE)
#'
#' @export
angles <- function(v, w, deg = TRUE) {
  # Internal helper: converts a vector or matrix into a list of 3D vectors
  as.list2 <- function(a) {
    if (!is.matrix(a)) {
      # Single vector: wrap in a list
      list(a[1:3])
    } else {
      # Matrix: convert each column into a list element
      asplit(a[1:3, ], 2)
    }
  }
  # Compute angles for each corresponding pair of vectors
  res <- mapply(angle0, as.list2(v), as.list2(w))
  # Convert to degrees if requested
  if (deg) res <- rad2deg(res)
  return(res)
}
