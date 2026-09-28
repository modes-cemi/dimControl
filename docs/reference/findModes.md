# Detect modes in a dataset

Detects modes in a numeric dataset using kernel density estimation and
determines an approximate interval associated with each detected mode.

## Usage

``` r
findModes(x, bw = 0.2, q1 = 0.95, plot = TRUE, showRanges = FALSE)
```

## Arguments

- x:

  Numeric vector containing the data.

- bw:

  Numeric value specifying the bandwidth used for kernel density
  estimation. Default is `0.2`.

- q1:

  Numeric value between 0 and 1 specifying the density quantile used to
  retain the most relevant peaks. Default is `0.95`.

- plot:

  Logical. If `TRUE`, the estimated density and detected modes are
  plotted. Default is `TRUE`.

- showRanges:

  Logical. If `TRUE`, vertical dashed lines indicating the lower and
  upper limits associated with each detected mode are added to the plot.
  Default is `FALSE`.

## Value

Numeric matrix with one row per detected mode and two columns, `min` and
`max`, containing the X-axis limits associated with each mode.

## Details

The density of `x` is estimated using
[`stats::density()`](https://rdrr.io/r/stats/density.html). Local maxima
are identified by comparing each density value with its immediate
neighbours.

Peaks are retained only when their estimated density is greater than the
quantile specified by `q1`. For each retained peak, the function
searches toward both sides while the density decreases away from the
peak, defining an approximate interval associated with the mode.

The number and location of detected modes depend on the bandwidth `bw`.
Smaller values may detect more local peaks, whereas larger values
produce a smoother density estimate.

## See also

[`stats::density()`](https://rdrr.io/r/stats/density.html),
[`stats::quantile()`](https://rdrr.io/r/stats/quantile.html)

## Examples

``` r
set.seed(123)

x <- c(
  rnorm(200, mean = 2, sd = 0.3),
  rnorm(5, mean = 3.5, sd = 0.1),
  rnorm(200, mean = 5, sd = 0.3)
)

# Detect and plot modes
modes <- findModes(x, bw = 0.2, q1 = 0.5, showRanges = TRUE)

modes
#>             min      max
#> mode1 0.7072493 3.156928
#> mode2 3.9328437 6.371437
```
