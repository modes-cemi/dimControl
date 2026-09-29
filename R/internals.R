#' Internal functions
#'
#' Supporting functions used internally by `dimControl`.
#'
#' @name dimControl-internals
#' @aliases .radDeg .normalize .sampleTriangle .rtnorm .qtri .rtri
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
#' `.rtnorm()` generates random values from a truncated normal distribution.
#'
#' `.qtri()` computes quantiles of a triangular distribution.
#'
#' `.rtri()` generates random values from a triangular distribution.
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

# Quantile function for the triangular distribution
.qtri <- function (p, min = 0, max = 1, mode = (min + max)/2, lower.tail = TRUE) {
  if (!lower.tail) p <- 1 - p
  if ((mode < min) | (mode > max)) stop("Mode outside interval")
  if (any((p < 0) | (p > 1))) stop("p must be in the interval (0,1)")
  return(ifelse(p <= (mode - min)/(max - min),
                min + sqrt(p * (max - min) * (mode - min)),
                max - sqrt((1 - p) * (max - min) * (max - mode))))
}

# Generate random values from a truncated normal distribution
.rtnorm <- function(n, mean = 0, sd = 0.2, a = -0.5, b = 0.5) {
  truncnorm::rtruncnorm(n = n, mean = mean, sd = sd, a = a, b = b)
}

# Generate random values from a triangular distribution
.rtri <- function (n, min = 0, max = 1, mode = (min + max)/2) {
  p <- stats::runif(n, min = 0, max = 1)
  return(.qtri(p, min, max, mode))
}
