# Directional Angle from an Axis

Computes the directional angle between normalized vectors and a
reference coordinate axis.

## Usage

``` r
angleFromAxis(v, dim, negDir = FALSE, dir = NULL, deg = TRUE)
```

## Arguments

- v:

  Numeric matrix of dimension `d x n` containing normalized vectors by
  columns.

- dim:

  Integer. Coordinate axis used as reference.

- negDir:

  Logical. If `TRUE`, the negative direction of the selected axis is
  used. Default is `FALSE`.

- dir:

  Optional numeric value, either \\1\\ or \\-1\\. If provided,
  `dir = -1` is equivalent to `negDir = TRUE`, and `dir = 1` to
  `negDir = FALSE`. Default is `NULL`.

- deg:

  Logical. If `TRUE`, angles are returned in degrees; otherwise, in
  radians.

## Value

A numeric vector containing the directional angles.

## Details

The argument `dim` selects the coordinate axis used as reference:
`dim = 1` for X, `dim = 2` for Y, and `dim = 3` for Z.

## See also

[`radDeg()`](https://modes-cemi.github.io/dimControl/reference/radDeg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

angleFromAxis(v, dim = 1, negDir = FALSE, deg = TRUE)
angleFromAxis(v, dim = 1, negDir = TRUE,  deg = TRUE)
} # }
```
