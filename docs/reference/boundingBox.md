# Compute the Spatial Bounds (Bounding Box) of a 3D Mesh

Computes the minimum and maximum coordinates of the vertices of a 3D
mesh, returning a matrix with the extreme values along the `X`, `Y`, and
`Z` axes.

## Usage

``` r
boundingBox(x)
```

## Arguments

- x:

  A `mesh3d` object containing the mesh vertices in the `vb` component.

## Value

A matrix with 3 rows and 2 columns containing the minimum and maximum
coordinate values of the mesh vertices:

- Each row corresponds to an axis (`X`, `Y`, `Z`).

- The first column (`min`) contains the minimum values.

- The second column (`max`) contains the maximum values.

## Details

Internally, the function converts homogeneous coordinates in `x$vb` to
Euclidean coordinates using
[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html),
and computes per-axis ranges using `apply(..., range)`.

## See also

[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)

## Examples

``` r
# Create a cubic mesh
cube <- rgl::cube3d()

# Compute its bounding box
boundingBox(cube)
#> Error in boundingBox(cube): could not find function "boundingBox"
```
