#' Detect modes in a dataset
#'
#' Detects modes in a numeric dataset using kernel density estimation and
#' determines an approximate interval associated with each detected mode.
#'
#' @param x Numeric vector containing the data.
#' @param bw Bandwidth used for kernel density estimation. By default, `"nrd0"`
#' selects the bandwidth automatically. A positive numeric value or another
#' method supported by [stats::density()] can also be supplied.
#' @param adjust Positive numeric factor used to adjust the bandwidth. Values
#' greater than 1 increase smoothing, whereas values below 1 decrease smoothing.
#' Default is `1`.
#' @param q1 Numeric value between 0 and 1 specifying the density quantile used
#' to retain the most relevant peaks. Default is `0.95`.
#' @param plot Logical. If `TRUE`, the estimated density and detected modes are
#' plotted. Default is `TRUE`.
#' @param showRanges Logical. If `TRUE`, vertical dashed lines indicating the left
#' and right endpoints associated with each detected mode are added to the plot.
#' Default is `FALSE`.
#'
#' @returns
#' Numeric matrix with one row per detected mode and three columns: `left`, `mode`,
#' and `right`. The `left` and `right` columns contain the endpoints of the
#' approximate interval associated with each mode, while `mode` contains the
#' location of the corresponding local maximum of the estimated density.
#'
#' @details
#' The density of `x` is estimated using [stats::density()]. By default, the
#' bandwidth is selected automatically using the `"nrd0"` method. The `adjust`
#' parameter allows the bandwidth to be increased or decreased without changing
#' the selection method.
#'
#' Local maxima are identified by comparing each density value with its immediate
#' neighbours.
#'
#' Peaks are retained only when their estimated density is greater than the
#' quantile specified by `q1`. For each retained peak, the function searches
#' toward both sides while the density decreases away from the peak, defining
#' an approximate interval associated with the mode.
#'
#' The location of each detected mode corresponds to the X coordinate of the
#' local maximum of the estimated density.
#'
#' The number and location of detected modes depend on the bandwidth. Smaller
#' bandwidths may detect more local peaks, whereas larger bandwidths produce
#' smoother density estimates and may merge nearby modes.
#'
#' @seealso [stats::density()], [stats::quantile()]
#'
#' @examples
#' set.seed(123)
#'
#' x <- c(
#'   rnorm(200, mean = 2, sd = 0.3),
#'   rnorm(5, mean = 3.5, sd = 0.1),
#'   rnorm(200, mean = 5, sd = 0.3)
#' )
#'
#' # Detect modes using automatic bandwidth selection
#' modes <- findModes(x, q1 = 0.5, showRanges = TRUE)
#' modes
#'
#' # Increase the smoothing
#' findModes(x, adjust = 1.5, q1 = 0.5)
#'
#' # Decrease the smoothing
#' findModes(x, adjust = 0.5, q1 = 0.5)
#'
#' # Specify a fixed bandwidth
#' findModes(x, bw = 0.2, q1 = 0.5)
#'
#' @export
findModes <- function(x, bw = "nrd0", adjust = 1, q1 = 0.95, plot = TRUE,
                      showRanges = FALSE) {

  # Estimate the density of x
  densX <- stats::density(x, bw = bw, adjust = adjust)

  y <- densX$y
  xVals <- densX$x

  # Identify local density maxima
  peakIndices <- which(
    (y[1:(length(y) - 2)] < y[2:(length(y) - 1)]) &
    (y[2:(length(y) - 1)] > y[3:length(y)])) + 1

  # Retain peaks above the selected density quantile
  pQ1 <- stats::quantile(y, q1)

  filteredPeaks <- peakIndices[y[peakIndices] > pQ1]

  # Initialize output matrix
  modes <- matrix(nrow = length(filteredPeaks), ncol = 3,
                  dimnames = list(paste0("mode", seq_along(filteredPeaks)),
                                  c("left", "mode", "right")))

  # Determine the range associated with each mode
  for (i in seq_along(filteredPeaks)) {
    peakIndex <- filteredPeaks[i]

    # Search toward the left density minimum
    startDescent <- peakIndex

    while (startDescent > 1 && y[startDescent] >= y[startDescent - 1]) {
      startDescent <- startDescent - 1
    }

    modeStart <- xVals[startDescent]

    # Search toward the right density minimum
    endDescent <- peakIndex

    while (endDescent < length(y) && y[endDescent] >= y[endDescent + 1]) {
      endDescent <- endDescent + 1
    }

    modeEnd <- xVals[min(endDescent + 1, length(xVals))]

    # Get the location of the detected mode
    modeValue <- xVals[peakIndex]

    # Store the left endpoint, mode and right endpoint
    modes[i, ] <- c(modeStart, modeValue, modeEnd)
  }

  # Plot density and detected modes
  if (plot) {
    graphics::plot(densX, main = "", xlab = deparse(substitute(x)), ylab = "Density")
    graphics::points(xVals[filteredPeaks], y[filteredPeaks], col = 6, pch = 19, cex = 0.7)

    if (showRanges && nrow(modes) > 0) {
      graphics::abline(v = modes[, "left"], col = "blue", lty = 2)
      graphics::abline(v = modes[, "right"], col = "red", lty = 2)
    }
  }

  modes
}
