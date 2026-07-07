# Angle Between Two 3D Vectors

Computes the angle between two three-dimensional vectors using the dot
product. The result is restricted to the interval \\\[0, \pi\]\\.

## Usage

``` r
angleBetweenVectors(a, b)
```

## Arguments

- a:

  Numeric vector of dimension 3.

- b:

  Numeric vector of dimension 3.

## Value

A numeric value corresponding to the angle between the vectors, in
radians.

## Details

The function applies a numerical correction to ensure that the argument
of [`acos()`](https://rdrr.io/r/base/Trig.html) lies within the interval
\\\[-1, 1\]\\.

## Examples

``` r
a <- c(1, 0, 0)
b <- c(0, 1, 0)
angleBetweenVectors(a, b)
#> [1] 1.570796
```
