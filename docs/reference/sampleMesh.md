# Sampling points over a triangular mesh

Generates random points uniformly distributed over a triangular mesh.
Each triangle receives a number of points proportional to its area, and
the points are generated using barycentric coordinates.

## Usage

``` r
sampleMesh(mesh, n, shuffle = FALSE)
```

## Arguments

- mesh:

  A list representing a triangular mesh, containing:

  - `vb`: a 3xN (or 4xN homogeneous) matrix with the mesh vertex
    coordinates.

  - `it`: a 3xM matrix with the vertex indices for each triangle (each
    column is a triangle).

- n:

  Integer greater than 0. Total number of points to generate.

- shuffle:

  Logical. Whether to shuffle the generated points randomly.

## Value

A numeric matrix of dimension 3 x n, where each column represents a
point sampled in 3D space.

## Details

Internally, this function uses `sampleTriangle()` to sample points
within each triangle.

If the mesh uses homogeneous coordinates (4th row in `vb`), points are
converted to 3D by dividing by the w component. The points are returned
as columns of a 3xN matrix. If `shuffle = TRUE`, the point order is
shuffled randomly.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a triangular sphere
mesh <- Rvcg::vcgSphere(1, subdiv = 1)
rgl::wire3d(mesh) # visualize the mesh
# Sample 10000 points over the mesh
pts <- sampleMesh(mesh, 10000, shuffle = TRUE)
# Plot the sampled points
rgl::points3d(t(pts), col = "red", size = 5)
} # }
```
