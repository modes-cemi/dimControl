# Conversion from Radians to Degrees

Converts angular values expressed in radians to degrees.

## Usage

``` r
rad2deg(x)
```

## Arguments

- x:

  A numeric value or numeric vector in radians.

## Value

A numeric value or numeric vector with the angles converted to degrees.

## Examples

``` r
rad2deg(pi)
#> [1] 180
rad2deg(c(0, pi/2, pi))
#> [1]   0  90 180
```
