# Angles Between Vectors and Reference Vectors

Computes angles between the columns of `v` and one or more reference
vectors.

## Usage

``` r
angleFromVectors(v, w, normalized = FALSE, deg = TRUE)
```

## Arguments

- v:

  Numeric vector or matrix. If a matrix, each column represents one
  vector.

- w:

  Numeric vector or matrix used as reference. If a vector, it is used as
  a common reference for all columns of `v`; if a matrix, it must be
  compatible with `v` for column-wise angle computation.

- normalized:

  Logical. If `TRUE`, vectors are assumed to be already normalized. If
  `FALSE`, internal normalization is performed.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise in
  radians.

## Value

A numeric vector containing the computed angles.

## Details

If `w` is a vector, it is used as a single reference vector for all
columns of `v`. If `w` is a matrix, angles are computed column by column
between `v` and `w`.

If `normalized = FALSE`, vectors are internally normalized before
computing the angles. If `normalized = TRUE`, all vectors are assumed to
be unit vectors, i.e., vectors with Euclidean norm equal to 1.

To avoid numerical errors in
[`acos()`](https://rdrr.io/r/base/Trig.html), cosine values are clamped
to the interval \\\[-1, 1\]\\.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

w <- c(1, 0, 0)

angleFromVectors(v, w, normalized = FALSE, deg = TRUE)
#> [1]  0 90 90
```
