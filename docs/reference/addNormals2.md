# Compute vertex normals by averaging triangle normals

Computes the normals of the vertices of a triangular mesh by averaging
the normals of the triangles.

## Usage

``` r
addNormals2(x, normals.tri)
```

## Arguments

- x:

  A `mesh3d` object.

- normals.tri:

  A 4 x ntri matrix of triangle normals. If not provided, they are
  computed internally using
  [`normals.mesh3d()`](https://modes-cemi.github.io/dimControl/reference/normals.mesh3d.md).

## Value

A `mesh3d` object with the `normals` field updated, containing the unit
normals for each vertex.

## Details

This function simply averages the normals of the triangles for each
vertex. No weighting by area or angle is applied.

## Examples

``` r
# Create a triangular mesh
mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)

# Compute triangle normals (for more robustness, Rvcg::vcgFaceNormals() can be used)
norm_tri <- normals.mesh3d(mesh)

# Compute vertex normals by averaging triangle normals
mesh <- addNormals2(mesh, norm_tri)

# Show the first 5 vertex normals
mesh$normals[, 1:5]
#>              [,1]          [,2]          [,3]          [,4]      [,5]
#> [1,] 1.574277e-16  1.166131e-17 -7.710928e-17 -1.166131e-17 0.5257311
#> [2,] 5.257311e-01  5.257311e-01 -5.257311e-01 -5.257311e-01 0.8506508
#> [3,] 8.506508e-01 -8.506508e-01  8.506508e-01 -8.506508e-01 0.0000000
#> [4,] 1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00 1.0000000
```
