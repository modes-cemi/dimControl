# Angle Between a Set of Vectors and a Reference Vector

Computes the angle between each column of a matrix of vectors and a
reference vector.

## Usage

``` r
angleFromReference(v, a, deg = TRUE)
```

## Arguments

- v:

  Numeric matrix of dimension `d x n`. Each column represents a vector.

- a:

  Numeric vector of dimension `d`.

- deg:

  Logical. If `TRUE`, returns the angles in degrees; if `FALSE`, in
  radians.

## Value

A numeric vector containing the angles between each vector in `v` and
`a`.

## Details

The function uses
[`angle0()`](https://modes-cemi.github.io/dimControl/reference/angle0.md)
to calculate each angle, ensuring numerical stability by limiting the
argument of [`acos()`](https://rdrr.io/r/base/Trig.html) to the interval
\\\[-1, 1\]\\. The matrix `v` can have any number of columns, and the
vector `a` must have the same dimension as the columns of `v`.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0), nrow = 3)
a <- c(1, 0, 0)
angleFromReference(v, a, deg = TRUE)
#> Error in angleFromReference(v, a, deg = TRUE): could not find function "angleFromReference"
```
