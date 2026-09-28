# Compute vertex normals by averaging triangle normals

Computes vertex normals of a triangular mesh by combining the normals of
the triangles incident to each vertex.

## Usage

``` r
addNormals2(x, normalsTri, normalized = TRUE)
```

## Arguments

- x:

  `mesh3d` object representing a triangular mesh.

- normalsTri:

  Numeric 3 x n or 4 x n matrix containing the face normals, where n is
  the number of triangles. If not provided, face normals are computed
  internally using
  [`Rvcg::vcgFaceNormals()`](https://rdrr.io/pkg/Rvcg/man/vcgFaceNormals.html).

- normalized:

  Logical. If `TRUE`, the columns of `normalsTri` are assumed to be unit
  vectors. If `FALSE`, they are internally normalized. This argument is
  used only when `normalsTri` is provided.

## Value

`mesh3d` object with the `normals` field updated, containing the unit
normal vectors for each vertex in homogeneous coordinates.

## Details

When `normalsTri` is provided, the face normals are converted to
Euclidean coordinates using
[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html).
If `normalized = FALSE`, each face normal is subsequently normalized to
unit length.

When `normalsTri` is not provided, normalized face normals are computed
internally using
[`Rvcg::vcgFaceNormals()`](https://rdrr.io/pkg/Rvcg/man/vcgFaceNormals.html).

For each vertex, the normals of all incident triangles are summed and
the resulting vector is normalized to unit length. Therefore, when unit
face normals are used, each incident triangle contributes equally, with
no weighting by triangle area or vertex angle.

## Examples

``` r
library(rgl)
library(Rvcg)

# Create a triangular mesh
mesh <- subdivision3d(icosahedron3d(), depth = 1)

# Compute face normals
normTri <- vcgFaceNormals(mesh)

# Compute vertex normals from the supplied face normals
mesh <- addNormals2(mesh, normTri)

# Show the first five vertex normals
mesh$normals[, 1:5]
#>           [,1]       [,2]       [,3]       [,4]      [,5]
#> [1,] 0.0000000  0.0000000  0.0000000  0.0000000 0.5257311
#> [2,] 0.5257311  0.5257311 -0.5257311 -0.5257311 0.8506508
#> [3,] 0.8506508 -0.8506508  0.8506508 -0.8506508 0.0000000
#> [4,] 1.0000000  1.0000000  1.0000000  1.0000000 1.0000000
```
