# Directional Angles of Normalized Vectors

Computes the directional angle between each column of a matrix of
normalized vectors and the canonical axis specified by `dim`, optionally
reversed by `dir`.

## Usage

``` r
angled(v, dim, dir = 1, deg = TRUE)
```

## Arguments

- v:

  Numeric matrix of dimension `d x n` containing normalized vectors.

- dim:

  Integer specifying the reference dimension (`1 <= dim <= d`).

- dir:

  Numeric scalar equal to `1` or `-1` indicating the orientation of the
  reference axis.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise in
  radians.

## Value

A numeric vector of length `n` containing the directional angles between
each column of `v` and the axis \\\pm e\_{dim}\\.

## Details

The angle is computed as \\\theta = \arccos(dir \* v\[dim, \])\\. All
vectors must be unit vectors (Euclidean norm equal to 1). No internal
normalization is performed.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)
angled(v, dim = 1, dir = 1, deg = TRUE)
#> [1]  0 90 90
```
