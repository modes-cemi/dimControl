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

  Logical. If `TRUE`, `a` and `b` are assumed to be unit vectors. If
  `FALSE`, they are internally normalized.

- deg:

  Logical. If `TRUE`, the angle is returned in degrees; otherwise, in
  radians.

## Value

A numeric value containing the angle between `a` and `b`.

## Details

The angle between two vectors is computed as:

\$\$ \theta = \arccos\left( \frac{a \cdot b}{\lVert a \rVert \lVert b
\rVert} \right) \$\$

To avoid numerical errors in
[`acos()`](https://rdrr.io/r/base/Trig.html), the cosine value is
clamped to the interval \\\[-1, 1\]\\.

## See also

[`radDeg()`](https://modes-cemi.github.io/dimControl/reference/radDeg.md)

## Examples

``` r
if (FALSE) { # \dontrun{
a <- c(1, 0, 0)
b <- c(0, 1, 0)

angleBetween(a, b, normalized = FALSE, deg = TRUE)
} # }
```
