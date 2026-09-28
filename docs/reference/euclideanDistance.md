# Compute the Euclidean distance between two points

Computes the Euclidean distance between two points from a vector
containing the differences between their coordinates.

## Usage

``` r
euclideanDistance(h)
```

## Arguments

- h:

  Numeric vector containing the differences between the coordinates of
  two points, for example `c(x2 - x1, y2 - y1, z2 - z1)`.

## Value

Numeric value representing the Euclidean distance between the two
points.

## Details

The Euclidean distance is computed as:

\$\$d = \sqrt{\sum_i h_i^2}\$\$,

where \\h_i\\ represents the coordinate difference along dimension
\\i\\.

## Examples

``` r
# Differences between two points in 3D
h <- c(3 - 0, 4 - 0, 0 - 0)

# Compute the Euclidean distance
euclideanDistance(h)
#> [1] 5
```
