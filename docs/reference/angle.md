# Angles between vectors

Computes angles between vectors, either pairwise or between a single
vector and multiple vectors.

## Usage

``` r
angle(v, w, normalized = TRUE, deg = TRUE)
```

## Arguments

- v:

  Numeric vector of length 3 or 4, or 3 x n or 4 x n matrix, where each
  column represents a vector.

- w:

  Numeric vector of length 3 or 4, or 3 x n or 4 x n matrix, where each
  column represents a vector.

- normalized:

  Logical. If `TRUE`, the vectors in `v` and `w` are assumed to be unit
  vectors. If `FALSE`, they are internally normalized.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise, in
  radians.

## Value

Numeric vector containing the angles between the vectors.

## Details

The vectors in `v` and `w` are converted to Euclidean coordinates using
[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html).
Therefore, vectors and matrices can be provided in Euclidean or
homogeneous coordinates.

If one argument is a single vector and the other contains multiple
vectors, the angle between the single vector and each of the other
vectors is computed. If both arguments contain multiple vectors, angles
are computed column by column between corresponding vectors.

If `normalized = FALSE`, the Euclidean vectors are normalized to unit
length before computing the angles.

To avoid numerical errors in
[`acos()`](https://rdrr.io/r/base/Trig.html), cosine values are clamped
to the interval \\\[-1, 1\]\\.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

# Compute angles with a single vector
w <- c(1, 0, 0)

angle(v, w)
#> [1]  0 90 90

# Compute angles between corresponding vectors
w2 <- matrix(c(1, 0, 0,
               1, 0, 0,
               0, 1, 0), nrow = 3)

angle(v, w2)
#> [1]  0 90 90
```
