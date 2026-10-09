# Triangular distribution ----

#' Triangular distribution
#'
#' Density, quantile function, and random generation for the triangular
#' distribution.
#'
#' @param x Numeric vector of values at which the density is evaluated.
#' @param p Numeric vector of probabilities.
#' @param n Number of observations to generate.
#' @param min Lower limit of the distribution.
#' @param max Upper limit of the distribution.
#' @param mode Mode of the distribution. By default, the midpoint between
#'   `min` and `max`.
#' @param lower.tail Logical. If `TRUE` (default), probabilities are
#'   \eqn{P[X \le x]}; otherwise, \eqn{P[X > x]}.
#'
#' @return
#' `dtri()` returns the density evaluated at `x`.
#'
#' `qtri()` returns the quantiles corresponding to `p`.
#'
#' `rtri()` returns a numeric vector of `n` random values.
#'
#' @details
#' The triangular distribution is defined on the interval from `min` to `max`,
#' with its mode specified by `mode`.
#'
#' The functions `dtri()`, `qtri()`, and `rtri()` provide the density,
#' quantile function, and random generation, respectively.
#'
#' @examples
#' # Density of a symmetric triangular distribution
#' x <- seq(-1, 1, length.out = 200)
#' plot(
#'   x,
#'   dtri(x, min = -1, max = 1, mode = 0),
#'   type = "l",
#'   xlab = "x",
#'   ylab = "Density"
#' )
#'
#' # Generate random values
#' set.seed(1)
#' values <- rtri(1000, min = -1, max = 1, mode = 0)
#' hist(values, probability = TRUE)
#'
#' @name Triangular
NULL

#' @rdname Triangular
#' @export
dtri <- function (x, min = 0, max = 1, mode = (min + max)/2) {
  if ((mode < min) | (mode > max)) stop("Mode outside interval")
  d <- ifelse(x <= mode, 2 * (x - min)/((max - min) * (mode -  min)),
              2 * (max - x)/((max - min) * (max - mode)))
  d[x < min | x > max] <- 0
  return(d)
}

#' @rdname Triangular
#' @export
qtri <- function (p, min = 0, max = 1, mode = (min + max)/2, lower.tail = TRUE) {
  if (!lower.tail) p <- 1 - p
  if ((mode < min) | (mode > max)) stop("Mode outside interval")
  if (any((p < 0) | (p > 1))) stop("p must be in the interval (0,1)")
  return(ifelse(p <= (mode - min)/(max - min),
                min + sqrt(p * (max - min) * (mode - min)),
                max - sqrt((1 - p) * (max - min) * (max - mode))))
}

#' @rdname Triangular
#' @export
rtri <- function (n, min = 0, max = 1, mode = (min + max)/2) {
  p <- stats::runif(n, min = 0, max = 1)
  return(qtri(p, min, max, mode))
}

# Truncated normal distribution ----

#' Truncated normal distribution
#'
#' Density, quantile function, and random generation for the truncated
#' normal distribution.
#'
#' @param x Numeric vector of values at which the density is evaluated.
#' @param p Numeric vector of probabilities.
#' @param n Number of observations to generate.
#' @param mean Mean of the normal distribution. Default is 0.
#' @param sd Standard deviation of the normal distribution. Default is 1.
#' @param a Lower truncation point. Default is `-Inf`.
#' @param b Upper truncation point. Default is `Inf`.
#'
#' @return
#' `dtnorm()` returns the density evaluated at `x`.
#'
#' `qtnorm()` returns the quantiles corresponding to `p`.
#'
#' `rtnorm()` returns a numeric vector of `n` random values.
#'
#' @details
#' The truncated normal distribution corresponds to a normal distribution
#' with mean `mean` and standard deviation `sd`, restricted to the interval
#' from `a` to `b`.
#'
#' The functions `dtnorm()`, `qtnorm()`, and `rtnorm()` provide the density,
#' quantile function, and random generation, respectively.
#'
#' @examples
#' # Density of a truncated normal distribution
#' x <- seq(-2, 2, length.out = 200)
#' plot(
#'   x,
#'   dtnorm(x, mean = 0, sd = 1, a = -2, b = 2),
#'   type = "l",
#'   xlab = "x",
#'   ylab = "Density"
#' )
#'
#' # Generate random values
#' set.seed(1)
#' values <- rtnorm(1000, mean = 0, sd = 1, a = -2, b = 2)
#' hist(values, probability = TRUE)
#'
#' @name TruncatedNormal
NULL

#' @rdname TruncatedNormal
#' @export
dtnorm <- function(x, mean = 0, sd = 1, a = -Inf, b = Inf) {
  truncnorm::dtruncnorm(x = x,  mean = mean, sd = sd, a = a, b = b)
}

#' @rdname TruncatedNormal
#' @export
qtnorm <- function(p, mean = 0, sd = 1, a = -Inf, b = Inf) {
  truncnorm::qtruncnorm(p = p, mean = mean, sd = sd, a = a, b = b)
}

#' @rdname TruncatedNormal
#' @export
rtnorm <- function(n, mean = 0, sd = 1, a = -Inf, b = Inf) {
  truncnorm::rtruncnorm(n = n, mean = mean, sd = sd, a = a, b = b)
}
