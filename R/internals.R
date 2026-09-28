#' Internal functions
#'
#' Supporting functions used internally by `dimControl`.
#'
#' @name dimControl-internals
#' @aliases .radDeg .normalize .sampleTriangle
#'
#' @details
#' `.radDeg()` converts angular values expressed in radians to degrees.
#'
#' `.normalize()` normalizes the columns of a numeric matrix so that each column has
#' unit Euclidean length.
#'
#' `.sampleTriangle()` generates uniformly distributed points inside a triangle using
#' barycentric coordinates.
#'
#' `.rtnormDefault()` generates random values from a truncated normal distribution
#' using the default parameters employed by `simulateCloud()`.
#'
#' @keywords internal
NULL


# Conversion from radians to degrees
.radDeg <- function(x) {
  (x / pi) * 180
}

# Normalize the columns of a numeric matrix
.normalize <- function(v) {
  apply(v, 2, function(n) n / sqrt(sum(n^2)))
}

# Sample uniformly distributed points inside a triangle
.sampleTriangle <- function(tri, n) {
  u <- matrix(stats::runif(2 * n), nrow = 2)

  # Reflect points outside the unit triangle
  index <- colSums(u) > 1
  u[, index] <- 1 - u[, index]

  # Transform barycentric coordinates to 3D coordinates
  result <- tri[, 1] + cbind(tri[, 2] - tri[, 1], tri[, 3] - tri[, 1]) %*% u
  result
}

# Generate values from the default truncated normal distribution
.rtnormDefault <- function(n,
                           mean = 0,
                           sd = 0.2,
                           a = -0.5,
                           b = 0.5) {

  truncnorm::rtruncnorm(n = n, mean = mean, sd = sd, a = a, b = b)
}
