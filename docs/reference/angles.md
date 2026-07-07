# Angles Between Two Sets of 3D Vectors

Computes the angles between corresponding vectors from two sets of
three-dimensional vectors. Each column of the input matrices represents
a 3D vector.

## Usage

``` r
angles(v, w, deg = TRUE)
```

## Arguments

- v:

  Numeric vector or matrix with at least 3 rows. Each column represents
  a vector.

- w:

  Numeric vector or matrix with at least 3 rows. Each column represents
  a vector.

- deg:

  Logical. If `TRUE`, returns the angles in degrees; if `FALSE`, in
  radians.

## Value

A numeric vector containing the angles between each pair of
corresponding vectors.

## Details

The function uses an internal helper `as.list2()` to convert the input
into a list of 3D vectors:

- If the input is a vector of length 3, it returns a list containing
  that vector.

- If the input is a matrix \\3 \times n\\, it returns a list where each
  element is a column of the matrix.

Angles are calculated using the dot product and the
[`acos()`](https://rdrr.io/r/base/Trig.html) function, with numerical
correction to ensure stability.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0), nrow = 3)
w <- matrix(c(0, 1, 0,
              1, 0, 0), nrow = 3)
angles(v, w, deg = TRUE)
#> [1] 90 90
```
