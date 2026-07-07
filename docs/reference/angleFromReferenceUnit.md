# Angle Between Normalized Vectors and a Reference Vector

Computes the angle between each column of a matrix of normalized vectors
and a normalized reference vector.

## Usage

``` r
angleFromReferenceUnit(v, a, deg = TRUE)
```

## Arguments

- v:

  Numeric matrix of dimension `d x n` containing normalized vectors.

- a:

  Numeric normalized vector of length `d`.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise in
  radians.

## Value

A numeric vector of length `n` containing the angles between each column
of `v` and `a`.

## Details

Both `v` and `a` must contain unit vectors (i.e., Euclidean norm equal
to 1). No internal normalization is performed.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0), nrow = 3)
a <- c(1, 0, 0)
angleFromReferenceUnit(v, a, deg = TRUE)
#> [1]  0 90
```
