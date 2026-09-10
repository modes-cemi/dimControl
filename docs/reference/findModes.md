# Detect Modes in a Dataset

Detects modes in a numeric dataset using kernel density estimation. For
each detected mode, the function determines the interval along the
X-axis bounded by the adjacent decreases in density.

## Usage

``` r
findModes(x, bw = 0.2, q1 = 0.95, plot = TRUE, showRanges = FALSE)
```

## Arguments

- x:

  A numeric vector containing the data.

- bw:

  A numeric value specifying the bandwidth used for kernel density
  estimation. Default is `0.2`.

- q1:

  A numeric value between 0 and 1 specifying the density quantile used
  to retain the most relevant peaks. Default is `0.95`.

- plot:

  Logical. If `TRUE`, plots the estimated density and the detected
  modes. Default is `TRUE`.

- showRanges:

  Logical. If `TRUE`, draws vertical dashed lines marking the lower and
  upper limits of each detected mode. Default is `FALSE`.

## Value

A matrix with one row per detected mode and two columns, `min` and
`max`, containing the X-axis limits associated with each mode.

## Details

The density of `x` is estimated using
[`stats::density()`](https://rdrr.io/r/stats/density.html). Local maxima
are identified by comparing each density value with its immediate
neighbours.

Peaks are retained only when their density is greater than the quantile
defined by `q1`. For each retained peak, the function searches in both
directions until the density stops decreasing, defining the approximate
interval associated with that mode.

The number and location of detected modes depend strongly on the
bandwidth `bw`: smaller values may detect more local peaks, whereas
larger values produce a smoother density estimate.

## See also

[`stats::density()`](https://rdrr.io/r/stats/density.html),
[`stats::quantile()`](https://rdrr.io/r/stats/quantile.html)

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(123)

x <- c(
  rnorm(200, mean = 2, sd = 0.3),
  rnorm(5, mean = 3.5, sd = 0.1),
  rnorm(200, mean = 5, sd = 0.3)
)

# Detect and plot modes
modes <- findModes(x, bw = 0.2, q1 = 0.5, plot = TRUE, showRanges = TRUE)
modes
} # }
```
