# Compute vertex normals by averaging triangle normals

Computes the normals of the vertices of a triangular mesh by averaging
the normals of the triangles.

## Usage

``` r
addNormals(x, normals.tri)
```

## Arguments

- x:

  A `mesh3d` object.

- normals.tri:

  A 4 x ntri matrix of triangle normals. If not provided, they are
  computed internally using
  [`meshNormals()`](https://modes-cemi.github.io/dimControl/reference/meshNormals.md).

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
norm_tri <- meshNormals(mesh)
#> Error in meshNormals(mesh): could not find function "meshNormals"

# Compute vertex normals by averaging triangle normals
mesh <- addNormals(mesh, norm_tri)
#> Error in addNormals(mesh, norm_tri): could not find function "addNormals"

# Show the first 5 vertex normals
mesh$normals[, 1:5]
#> NULL
```
