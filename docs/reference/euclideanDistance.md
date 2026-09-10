# Compute the Euclidean Distance Between Two Points

Computes the Euclidean distance between two points from a vector
containing the differences between their coordinates.

## Usage

``` r
euclideanDistance(h)
```

## Arguments

- h:

  A numeric vector containing the differences between the coordinates of
  two points, for example `c(x2 - x1, y2 - y1, z2 - z1)`.

## Value

A numeric value representing the Euclidean distance between the two
points.

## Details

The Euclidean distance is computed as: \$\$d = \sqrt{\sum_i h_i^2}\$\$,
where \\h_i\\ represents the coordinate differences between the two
points.

## Examples

``` r
if (FALSE) { # \dontrun{
# Differences between two points in 3D
h <- c(3 - 0, 4 - 0, 0 - 0)

# Compute the Euclidean distance
euclideanDistance(h)
} # }
```
