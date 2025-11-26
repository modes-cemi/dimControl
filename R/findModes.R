#' Detect Modes in a Dataset
#'
#' Detects peaks (modes) in a numeric dataset `x` using kernel density estimation.
#' For each mode, it determines the range along the X-axis where the density decreases
#' toward the adjacent minima. The function can also plot the density and the detected modes.
#'
#' @param x Numeric vector. The data for which modes will be calculated.
#' @param bw  Numeric. Bandwidth for the density estimation. Default is `bw = 2`.
#' @param Q1 Numeric between 0 and 1. Percentile of the density used to filter the
#' most relevant peaks. Default is `Q1 = 0.95`.
#' @param plot Logical. If `TRUE`, generates a plot of the density with detected modes.
#' Default is `TRUE`.
#'
#' @returns A matrix with one row per detected mode and two columns (`min` and `max`)
#' representing the X-axis range of each mode.
#'
#' @examples
#' set.seed(123) # Seed
#' x <- c(
#'   rnorm(200, mean = 2, sd = 0.3),
#'   rnorm(5, mean = 3.5, sd = 0.1),
#'   rnorm(200, mean = 5, sd = 0.3)
#' )
#'
#' # Compute and plot modes
#' modes <- findModes(x, bw = 0.2, Q1 = 0.5, plot = TRUE)
#'
#' # X-axis ranges for each mode
#' modes
#'
#' @importFrom stats density quantile
#' @importFrom graphics points
#'
#' @export
findModes <- function(x, bw = 2, Q1 = 0.95, plot = TRUE) {

  # Density of X
  densX <- density(x, bw = bw)
  y <- densX$y
  xvals <- densX$x

  # Peak detection
  peak_indices <- which(
    (y[1:(length(y) - 2)] < y[2:(length(y) - 1)]) &
    (y[2:(length(y) - 1)] > y[3:length(y)])) + 1

  # Percentile Q1 to select the most relevant peaks
  PQ1 <- quantile(y, Q1)
  filtered_peaks <- peak_indices[y[peak_indices] > PQ1]

  # Store modes
  modes <- matrix(nrow = length(filtered_peaks), ncol = 2,
                  dimnames = list(paste0("mode", seq_along(filtered_peaks)), c("min", "max")))

  # Ranges of each mode
  for (i in seq_along(filtered_peaks)) {
    peak_index <- filtered_peaks[i]

    start_descent <- peak_index
    while (start_descent > 1 && y[start_descent] >= y[start_descent - 1]) {
      start_descent <- start_descent - 1
    }
    mode_start <- xvals[start_descent]

    end_descent <- peak_index
    while (end_descent < length(y) && y[end_descent] >= y[end_descent + 1]) {
      end_descent <- end_descent + 1
    }
    mode_end <- xvals[min(end_descent + 1, length(xvals))]

    modes[i, ] <- c(mode_start, mode_end)
  }

  if (plot) {
    plot(densX, main = "", xlab = deparse(substitute(x)), ylab = "Density")
    points(xvals[filtered_peaks], y[filtered_peaks], col = 6, pch = 19, cex = 0.7)
    # Optional lines to mark ranges
    # abline(v = modes[, 1], col = "blue", lty = 2)
    # abline(v = modes[, 2], col = "red", lty = 2)
  }

  return(modes)
}
