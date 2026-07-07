# Compute the Euclidean Distance Between Two Points

Computes the linear (Euclidean) distance from a vector of differences
between the coordinates of two points.

## Usage

``` r
euclideanDistance(h)
```

## Arguments

- h:

  A numeric vector containing the differences between the coordinates of
  two points (for example, `(x2 - x1, y2 - y1, z2 - z1)`).

## Value

A numeric value representing the Euclidean distance between the two
points.

## Examples

``` r
# Differences between two points in 3D
h <- c(3 - 0, 4 - 0, 0 - 0)

# Compute the Euclidean distance
euclideanDistance(h)
#> Error in euclideanDistance(h): could not find function "euclideanDistance"
```
