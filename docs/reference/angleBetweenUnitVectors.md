# Angle Between Two Normalized Vectors

Computes the angle between two three-dimensional vectors that have been
previously normalized, using the dot product directly.

## Usage

``` r
angleBetweenUnitVectors(a, b)
```

## Arguments

- a:

  Numeric vector of dimension 3, normalized to unit length.

- b:

  Numeric vector of dimension 3, normalized to unit length.

## Value

A numeric value corresponding to the angle between the vectors, in
radians.

## Examples

``` r
a <- c(1, 0, 0)
b <- c(0, 1, 0)
angleBetweenUnitVectors(a, b)
#> Error in angleBetweenUnitVectors(a, b): could not find function "angleBetweenUnitVectors"
```
