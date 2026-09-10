# Extract the Boundary of a 3D Mesh

Identifies the unshared edges of a `mesh3d` object, i.e., edges
belonging to only one face of the mesh.

## Usage

``` r
getBoundarySegments(mesh, returnMesh = FALSE, simplify = TRUE)
```

## Arguments

- mesh:

  A `mesh3d` object representing the 3D mesh.

- returnMesh:

  Logical. If `TRUE`, returns a `mesh3d` object containing the boundary
  segments. If `FALSE`, returns a matrix with the corresponding vertex
  indices. Default is `FALSE`.

- simplify:

  Logical. If `TRUE` and `returnMesh = TRUE`, simplifies the resulting
  boundary mesh using the internal mesh-cleaning routine. Default is
  `TRUE`.

## Value

If `returnMesh = FALSE`, a two-row matrix containing the vertex indices
of the boundary segments. If `returnMesh = TRUE`, a `mesh3d` object
containing the boundary segments.

## Details

The function is adapted from
[`rgl::getBoundary3d()`](https://dmurdoch.github.io/rgl/dev/reference/getBoundary3d.html).
Edge endpoints are sorted to represent undirected edges, and their
frequencies are counted. Edges appearing only once are identified as
boundary edges.

## See also

[`rgl::getBoundary3d()`](https://dmurdoch.github.io/rgl/dev/reference/getBoundary3d.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a cube and remove two faces
mesh <- rgl::cube3d(color = "lightblue")
mesh$ib <- mesh$ib[, -(1:2)]

# Extract boundary segments
boundary <- getBoundarySegments(mesh, returnMesh = TRUE)

# Display mesh and boundary side by side
rgl::clear3d()
rgl::mfrow3d(1, 2)

rgl::shade3d(mesh, color = "lightgray", alpha = 0.4)
rgl::title3d("Mesh", level = 4)

rgl::next3d()
rgl::shade3d(boundary, color = "red", lwd = 2)
rgl::title3d("Boundary", level = 4)
} # }
```
