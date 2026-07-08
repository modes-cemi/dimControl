# Angle Between Two Vectors

Computes the angle between two numeric vectors.

## Usage

``` r
angleBetween(a, b, normalized = FALSE, deg = TRUE)
```

## Arguments

- a:

  Numeric vector.

- b:

  Numeric vector with the same length as `a`.

- normalized:

  Logical. If `TRUE`, `a` and `b` are assumed to be already normalized.
  If `FALSE`, internal normalization is performed.

- deg:

  Logical. If `TRUE`, the angle is returned in degrees; otherwise in
  radians.

## Value

A numeric value containing the angle between `a` and `b`.

## Details

If `normalized = FALSE`, the vectors are internally normalized before
computing the angle. If `normalized = TRUE`, both `a` and `b` are
assumed to be unit vectors, i.e., vectors with Euclidean norm equal to
1.

To avoid numerical errors in
[`acos()`](https://rdrr.io/r/base/Trig.html), the cosine value is
clamped to the interval \\\[-1, 1\]\\.

## Examples

``` r
a <- c(1, 0, 0)
b <- c(0, 1, 0)

angleBetween(a, b, normalized = FALSE, deg = TRUE)
#> [1] 90
```
