# Calculate Distance over a 3D Surface

Computes the total length of a 3D path by summing the Euclidean
distances between consecutive points.

## Usage

``` r
surfaceDistance(segment)
```

## Arguments

- segment:

  A matrix or data frame with three columns representing the X, Y, and Z
  coordinates of consecutive points in 3D space.

## Value

A numeric value representing the total length of the 3D path.

## Details

The distance between two consecutive points is computed as:

\$\$ d_i = \sqrt{(x\_{i+1} - x_i)^2 + (y\_{i+1} - y_i)^2 + (z\_{i+1} -
z_i)^2} \$\$

and the total path length is obtained by summing these distances.

## Examples

``` r
if (FALSE) { # \dontrun{
segment <- matrix(
  c(
    0, 0, 0,
    3, 4, 0,
    3, 4, 5
  ),
  ncol = 3,
  byrow = TRUE
)

surfaceDistance(segment)
} # }
```
