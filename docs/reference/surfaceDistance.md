# Calculate Distance over a 3D Surface

Computes the total length of a 3D path by summing the Euclidean
distances between consecutive points. Useful for estimating the distance
traveled over a 3D surface.

## Usage

``` r
surfaceDistance(segmento)
```

## Arguments

- segmento:

  A matrix or data frame with three columns (`x`, `y`, `z`) representing
  the coordinates of consecutive points in 3D space.

## Value

A numeric value indicating the total distance traveled along the
surface.
