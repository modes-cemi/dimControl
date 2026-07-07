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

# Display the first 5 normals
norm[, 1:5]
#>           [,1]       [,2]      [,3]      [,4]      [,5]
#> [1,] 0.1798157  0.1798157 0.6490360 0.3568221 0.2909479
#> [2,] 0.2899941 -0.2899941 0.0000000 0.0000000 0.5809420
#> [3,] 0.9399839  0.9399839 0.7607577 0.9341724 0.7601682
#> [4,] 1.0000000  1.0000000 1.0000000 1.0000000 1.0000000
```
