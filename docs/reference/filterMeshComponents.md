# Filter Mesh Components by Minimum Size

Filters the connected components of a triangular mesh according to their
number of triangles and rebuilds the mesh using only the retained
components.

## Usage

``` r
filterMeshComponents(
  mesh,
  comps,
  minSize = 1000,
  color = FALSE,
  plot = FALSE,
  palette = grDevices::rainbow
)
```

## Arguments

- mesh:

  A `mesh3d` object containing a triangular mesh. It must include the
  `it` matrix, where each column represents a triangle.

- comps:

  A list of integer vectors containing triangle indices for each
  connected component, typically returned by
  [`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md).

- minSize:

  Minimum number of triangles required for a component to be retained.
  Default is `1000`. If `NULL`, all components are retained.

- color:

  Logical. If `TRUE`, creates an additional rendering mesh with a
  distinct color assigned to each retained component. Default is
  `FALSE`. This argument is automatically set to `TRUE` when
  `plot = TRUE`.

- plot:

  Logical. If `TRUE`, plots the retained components using
  [`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html).
  Default is `FALSE`.

- palette:

  A function receiving the number of retained components and returning
  the corresponding colors. Default is
  [`grDevices::rainbow()`](https://rdrr.io/r/grDevices/palettes.html).

## Value

A list containing:

- `mesh`: a `mesh3d` object containing the retained triangles.

- `triIdx`: triangle-column indices retained from the input `mesh$it`.

- `compId`: original component index associated with each retained
  triangle.

- `render`: `NULL` unless `color = TRUE` or `plot = TRUE`; otherwise, a
  list containing the rendering mesh and its per-vertex color vector.

## Details

Components are retained when their number of triangles is greater than
or equal to `minSize`. The original vertex indices and the `mesh$vb`
matrix are preserved in the filtered mesh.

When coloring is requested, the vertices of each triangle are duplicated
so that every retained component can be displayed with an independent
color. The resulting mesh stored in `render$mesh` is intended only for
visualization.

## See also

[`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md),
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a mesh with two disconnected components
vertices <- t(rbind(
  c(0, 0, 0),
  c(1, 0, 0),
  c(0, 1, 0),
  c(1, 1, 0),
  c(3, 0, 0),
  c(4, 0, 0),
  c(3, 1, 0)
))

triangles <- t(rbind(
  c(1, 2, 3),
  c(2, 4, 3),
  c(5, 6, 7)
))

mesh <- rgl::tmesh3d(
  vertices = vertices,
  indices = triangles
)

# Identify connected components
components <- splitTrianglesInd(mesh)

# Retain components with at least two triangles
result <- filterMeshComponents(
  mesh = mesh,
  comps = components,
  minSize = 2,
  color = TRUE
)

# Display original and filtered meshes side by side
rgl::clear3d()
rgl::mfrow3d(1, 2)

rgl::shade3d(mesh, color = "lightgray")
rgl::title3d("Original mesh", level = 10)

rgl::next3d()
rgl::shade3d(result$render$mesh, color = result$render$col)
rgl::title3d("Filtered mesh", level = 4)
} # }
```
