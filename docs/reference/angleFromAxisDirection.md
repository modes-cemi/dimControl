# Directional Angle Computation for Normalized Vectors

Computes the directional angle between a set of normalized vectors and a
reference direction in a specific dimension. The function allows
returning the result in degrees or radians and optionally considering
the opposite direction.

## Usage

``` r
angleFromAxisDirection(v, dim, negdir = FALSE, deg = TRUE)
```

## Arguments

- v:

  A numeric matrix of dimension `d x n`. Each column represents a
  normalized vector.

- dim:

  Integer indicating the reference dimension, with `1 <= dim <= d`.

- negdir:

  Logical. If `TRUE`, considers the negative direction (complementary
  angle).

- deg:

  Logical. If `TRUE`, returns angles in degrees; if `FALSE`, returns
  them in radians.

## Value

A numeric vector containing the computed angles for each input vector.

## Examples

``` r
# Three normalized vectors in the X, Y, and Z directions
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

# Angle with respect to the X axis
angleFromAxisDirection(v, dim = 1)
#> [1]  0 90 90

# Angle with respect to the Y axis
angleFromAxisDirection(v, dim = 2)
#> [1] 90  0 90

# Angle with respect to the Z axis
angleFromAxisDirection(v, dim = 3)
#> [1] 90 90  0
```
