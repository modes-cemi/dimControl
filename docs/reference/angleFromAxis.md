# Directional Angle from an Axis

Computes the directional angle between normalized vectors and a
reference coordinate axis.

## Usage

``` r
angleFromAxis(v, dim, negdir = FALSE, dir = NULL, deg = TRUE)
```

## Arguments

- v:

  Numeric matrix of dimension `d x n` containing normalized vectors by
  columns.

- dim:

  Integer. Coordinate axis used as reference.

- negdir:

  Logical. If `TRUE`, the negative direction of the selected axis is
  used. Default is `FALSE`.

- dir:

  Optional numeric value, either \$1\$ or \$-1\$. Compatibility argument
  for selecting the positive or negative direction of the axis. Default
  is `NULL`.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise in
  radians.

## Value

A numeric vector containing the directional angles.

## Details

The input `v` must contain normalized vectors by columns. The argument
`dim` selects the coordinate axis used as reference. For example,
`dim = 1` uses the X axis, `dim = 2` uses the Y axis and `dim = 3` uses
the Z axis.

If `negdir = TRUE`, the angle is computed with respect to the negative
direction of the selected axis. The argument `dir` is kept for
compatibility: if provided, `dir = -1` is equivalent to `negdir = TRUE`,
and `dir = 1` is equivalent to `negdir = FALSE`.

## Examples

``` r
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

angleFromAxis(v, dim = 1, negdir = FALSE, deg = TRUE)
#> [1]  0 90 90
angleFromAxis(v, dim = 1, negdir = TRUE,  deg = TRUE)
#> [1] 180  90  90
```
