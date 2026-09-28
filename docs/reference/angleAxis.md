# Directional angle relative to an axis

Computes the angle between vectors and a reference coordinate axis.

## Usage

``` r
angleAxis(v, dim, negative = FALSE, normalized = TRUE, deg = TRUE)
```

## Arguments

- v:

  Numeric 3 x n or 4 x n matrix, where each column represents a vector.

- dim:

  Integer. Coordinate axis used as reference: `1` for X, `2` for Y, and
  `3` for Z.

- negative:

  Logical. If `TRUE`, the negative direction of the selected axis is
  used. If `FALSE`, the positive direction is used.

- normalized:

  Logical. If `TRUE`, the columns of `v` are assumed to be unit vectors.
  If `FALSE`, they are internally normalized.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise, in
  radians.

## Value

Numeric vector containing the directional angles.

## Details

The vectors in `v` are converted to Euclidean coordinates using
[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html).
Therefore, `v` can be provided as a 3 x n matrix of Euclidean vectors or
a 4 x n matrix of homogeneous coordinates.

If `normalized = FALSE`, the Euclidean vectors are normalized to unit
length before computing the angles.

The argument `dim` selects the coordinate axis used as reference:
`dim = 1` for X, `dim = 2` for Y, and `dim = 3` for Z. If
`negative = TRUE`, the negative direction of the selected axis is used.

To avoid numerical errors in
[`acos()`](https://rdrr.io/r/base/Trig.html), cosine values are clamped
to the interval \\\[-1, 1\]\\.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

angleAxis(v, dim = 1)
#> [1]  0 90 90
angleAxis(v, dim = 1, negative = TRUE)
#> [1] 180  90  90

# Non-normalized vectors
v2 <- v * 2

angleAxis(v2, dim = 1, normalized = FALSE)
#> [1]  0 90 90
```
