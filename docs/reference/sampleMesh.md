# Sample Points over a Triangular Mesh

Generates random points uniformly distributed over the surface of a
triangular mesh. The number of points assigned to each triangle is
proportional to its area.

## Usage

``` r
sampleMesh(mesh, n, shuffle = FALSE)
```

## Arguments

- mesh:

  A `mesh3d` object containing a triangular mesh. It must include:

  - `vb`: a 3 x N or 4 x N matrix containing the vertex coordinates.

  - `it`: a 3 x M matrix containing the vertex indices of each triangle.

- n:

  A positive integer specifying the total number of points to generate.

- shuffle:

  Logical. If `TRUE`, randomly shuffles the order of the generated
  points. Default is `FALSE`.

## Value

A numeric matrix with 3 rows and `n` columns, where each column
represents a sampled 3D point.

## Details

The surface area of each triangle is obtained using
[`Rvcg::vcgArea()`](https://rdrr.io/pkg/Rvcg/man/vcgArea.html). The
number of points assigned to each triangle is then generated from a
multinomial distribution with probabilities proportional to triangle
area.

Points within each triangle are generated uniformly using barycentric
coordinates.

If `mesh$vb` contains homogeneous coordinates, the vertices are
converted to Cartesian coordinates by dividing the first three
coordinates by the homogeneous coordinate.

## See also

[`Rvcg::vcgArea()`](https://rdrr.io/pkg/Rvcg/man/vcgArea.html),
[`rgl::points3d()`](https://dmurdoch.github.io/rgl/dev/reference/primitives.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a triangular sphere
mesh <- Rvcg::vcgSphere(1, subdiv = 1)

rgl::wire3d(mesh)

# Sample points over the mesh
points <- sampleMesh(mesh, 10000, shuffle = TRUE)

# Display sampled points
rgl::points3d(t(points), col = "red", size = 2)
} # }
```
