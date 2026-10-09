# Compute the bounding box of a 3D mesh

Computes the minimum and maximum coordinates of the vertices of a 3D
mesh along the `X`, `Y`, and `Z` axes.

## Usage

``` r
boundingBox(x)
```

## Arguments

- x:

  A `mesh3d` object containing the mesh vertices in the `vb` component.

## Value

A 3 x 2 matrix with rows corresponding to the `X`, `Y`, and `Z` axes and
columns `min` and `max`.

## Details

Homogeneous coordinates in `x$vb` are converted to Euclidean coordinates
using
[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)
before computing the coordinate ranges.

## See also

[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)

## Examples

``` r
# Create a cubic mesh
cube <- cube3d()

# Compute its bounding box
boundingBox(cube)
#>   min max
#> X  -1   1
#> Y  -1   1
#> Z  -1   1
```
