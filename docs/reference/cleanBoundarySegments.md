# Clean and Reconnect Boundary Segments of a 3D Mesh

Cleans boundary segments extracted from a `mesh3d` object by removing
redundant connections, long segments, and small connected components,
reconnecting endpoints, and retaining the main connected boundary.

## Usage

``` r
cleanBoundarySegments(iBorde, baseMesh, lengthProb = 0.98, minGroupSize = 20)
```

## Arguments

- iBorde:

  A two-row matrix containing the boundary segment indices, where each
  column defines a segment by the indices of its two vertices.

- baseMesh:

  A `mesh3d` object containing the mesh geometry associated with the
  boundary segments.

- lengthProb:

  A numeric value between 0 and 1 defining the quantile used to remove
  abnormally long boundary segments. Default is `0.98`.

- minGroupSize:

  Minimum number of segments required for a connected component to be
  retained. Default is `20`.

## Value

A two-row matrix containing the cleaned and reconnected boundary
segments.

## Details

Vertices with more than two incident boundary segments are simplified,
unusually long segments and small connected components are removed,
disconnected endpoints are paired by nearest-neighbor distance, and only
the largest connected boundary is retained.

## See also

[`getBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/getBoundarySegments.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a rectangular mesh with a triangular hole
vertices <- matrix(
  c(
    0, 0, 0,
    4, 0, 0,
    4, 2, 0,
    0, 2, 0,
    1.5, 0.8, 0,
    2.2, 0.8, 0,
    1.8, 1.4, 0
  ),
  ncol = 3,
  byrow = TRUE
)

# Define the triangular faces around the hole
triangles <- matrix(
  c(
    1, 2, 5,
    2, 6, 5,
    2, 3, 6,
    3, 7, 6,
    3, 4, 7,
    4, 1, 7,
    1, 5, 7
  ),
  ncol = 3,
  byrow = TRUE
)

# Create the mesh
baseMesh <- rgl::tmesh3d(
  vertices = t(vertices),
  indices = t(triangles),
  homogeneous = FALSE
)

# Extract boundary segment indices
iBorde <- getBoundarySegments(baseMesh)

# Clean the boundary segments
cleanBorde <- cleanBoundarySegments(
  iBorde,
  baseMesh,
  lengthProb = 1,
  minGroupSize = 4
)

# Display the original mesh and boundaries
rgl::clear3d()
rgl::mfrow3d(1, 3)

rgl::shade3d(baseMesh, color = "lightgray")
rgl::title3d("Mesh", level = 8)

rgl::next3d()
rgl::shade3d(rgl::mesh3d(vertices = baseMesh$vb, segments = iBorde))
rgl::title3d("Original boundary", level = 8)

rgl::next3d()
rgl::shade3d(rgl::mesh3d(vertices = baseMesh$vb, segments = cleanBorde))
rgl::title3d("Cleaned boundary", level = 8)
} # }
```
