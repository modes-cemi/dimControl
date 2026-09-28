# Calculate distance over a 3D surface

Computes the total length of a 3D path by summing the Euclidean
distances between consecutive points.

## Usage

``` r
surfaceDistance(segment)
```

## Arguments

- segment:

  Numeric matrix or data frame with three columns representing the X, Y,
  and Z coordinates of consecutive points in 3D space.

## Value

Numeric value representing the total length of the 3D path.

## Details

The distance between two consecutive points is computed as:

\$\$ d_i = \sqrt{(x\_{i+1} - x_i)^2 + (y\_{i+1} - y_i)^2 + (z\_{i+1} -
z_i)^2} \$\$

The total path length is obtained by summing the distances between all
consecutive points.

## Examples

``` r
segment <- matrix(
  c(
    0, 0, 0,
    3, 4, 0,
    3, 4, 5
  ),
  ncol = 3,
  byrow = TRUE
)

# Compute the total path length
surfaceDistance(segment)
#> [1] 10
```
