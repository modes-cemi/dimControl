# Filter Mesh Components by Minimum Size

Filters the connected components of a triangular mesh according to their
number of triangles and rebuilds the mesh using only the retained
components. Optionally, the surviving components can be assigned
distinct colors and plotted directly.

## Usage

``` r
filterMeshComponents(
  mesh,
  comps,
  min_size = 1000,
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
  connected component, typically returned by `splitTrianglesInd(mesh)`.
  The components must have been calculated from the same version and
  triangle order of `mesh`.

- min_size:

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
  The current `rgl` scene is not cleared. Default is `FALSE`.

- palette:

  A function that receives the number of retained components and returns
  the corresponding colors. Default is
  [`grDevices::rainbow`](https://rdrr.io/r/grDevices/palettes.html).

## Value

A list containing:

- `mesh`: a `mesh3d` object containing only the retained triangles.

- `tri_idx`: triangle-column indices retained from the input `mesh$it`.

- `comp_id`: original component index associated with each retained
  triangle.

- `render`: `NULL` unless `color = TRUE` or `plot = TRUE`; otherwise, a
  list containing an exploded rendering mesh and its per-vertex color
  vector.

## Details

The component list is normally obtained with
[`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md).
Each element of the list must contain triangle-column indices referring
to the same `mesh$it` matrix supplied to this function.

Filtering changes the column positions of the triangles in the returned
`mesh$it`, but it does not modify the vertex indices stored inside the
triangles or the layout of `mesh$vb`. The element `tri_idx` preserves
the correspondence with the triangle columns of the input mesh.

When coloring is requested, vertices are duplicated so that every
triangle has its own three vertices. This guarantees an unambiguous
solid color for each triangle using ordinary per-vertex coloring. The
exploded mesh stored in `render$mesh` is intended only for visualization
and should not replace the filtered mesh in subsequent geometric
analyses.

Creating the rendering mesh increases memory usage because adjacent
triangles no longer share vertices. For large meshes, use `color = TRUE`
or `plot = TRUE` only when visualization is required.

## See also

[`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md),
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# Alternative 1: filter and rebuild without coloring
components <- splitTrianglesInd(base_mesh)

result <- filterMeshComponents(
  mesh = base_mesh,
  comps = components,
  min_size = 1000
)

base_mesh_clean <- result$mesh

# Alternative 2: filter, color and plot
rgl::clear3d()

result_plot <- filterMeshComponents(
  mesh = base_mesh,
  comps = components,
  min_size = 1000,
  plot = TRUE
)

base_mesh_clean_plot <- result_plot$mesh
} # }
```
