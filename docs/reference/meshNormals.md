# Compute Face Normals of a Triangular Mesh

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

A 4 x nTri matrix containing the homogeneous normals of each triangle.
Each column represents a unit normal vector, with the fourth row set to
1.

## Details

For each triangle, the normal is computed as the cross product of two of
its edges and then normalized to unit length. If the vertices are in
homogeneous coordinates, they are converted before computing the
normals.

## See also

[`Rvcg::vcgFaceNormals()`](https://rdrr.io/pkg/Rvcg/man/vcgFaceNormals.html),
[`addNormals()`](https://modes-cemi.github.io/dimControl/reference/addNormals.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a triangular mesh
mesh <- rgl::subdivision3d(rgl::icosahedron3d(), depth = 1)

# Compute triangle normals
normals <- meshNormals(mesh)

# Display the first five normals
normals[, 1:5]
} # }
```
