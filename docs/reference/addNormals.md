# Compute Vertex Normals by Averaging Triangle Normals

Computes the normals of the vertices of a triangular mesh by averaging
the normals of the triangles.

## Usage

``` r
addNormals(x, normalsTri)
```

## Arguments

- x:

  A `mesh3d` object.

- normalsTri:

  A 4 x nTri matrix of triangle normals. If not provided, they are
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
if (FALSE) { # \dontrun{
# Create a triangular mesh
mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)

# Compute triangle normals
normTri <- meshNormals(mesh)

# Compute vertex normals by averaging triangle normals
mesh <- addNormals(mesh, normTri)

# Show the first five vertex normals
mesh$normals[, 1:5]
} # }
```
