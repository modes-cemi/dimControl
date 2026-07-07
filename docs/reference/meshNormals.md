# Compute face normals of a triangular mesh

Computes unit normals for the triangles of a `mesh3d` object using cross
products.

## Usage

``` r
meshNormals(x)
```

## Arguments

- x:

  A `mesh3d` object with triangular topology. Must contain elements `vb`
  (vertices) and `it` (triangle indices).

## Value

A 4 x ntri matrix containing the homogeneous normals of each triangle.
Each column represents a unit normal vector, with the fourth row set to
1 for homogeneous coordinates.

## Details

This function is primarily intended for teaching and comparison
purposes. For general use, it is recommended to use
[`Rvcg::vcgFaceNormals()`](https://rdrr.io/pkg/Rvcg/man/vcgFaceNormals.html),
which is more efficient and robust.

For each triangle, the normal is computed as the cross product of two of
its edges and then normalized to unit length. If the vertices are in
homogeneous coordinates (fourth row not equal to 1), they are normalized
before computing the normals.

## See also

[`vcgFaceNormals`](https://rdrr.io/pkg/Rvcg/man/vcgFaceNormals.html)

## Examples

``` r
# Create a triangular mesh
mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)

# Compute normals
norm <- meshNormals(mesh)
#> Error in meshNormals(mesh): could not find function "meshNormals"

# Display the first 5 normals
norm[, 1:5]
#> Error in norm[, 1:5]: object of type 'closure' is not subsettable
```
