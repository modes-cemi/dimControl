# Conversion from Radians to Degrees

Converts angular values expressed in radians to degrees.

## Usage

``` r
radDeg(x)
```

## Arguments

- x:

  A numeric value or numeric vector in radians.

## Value

A numeric value or numeric vector with the angles converted to degrees.

## Details

The conversion from radians to degrees is defined as:

\$\$ \mathrm{degrees} = \mathrm{radians} \frac{180}{\pi} \$\$

## Examples

``` r
if (FALSE) { # \dontrun{
radDeg(pi)
radDeg(c(0, pi/2, pi))
} # }
```
