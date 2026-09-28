# Clean a 3D mesh

Removes non-finite or unused vertices from a `mesh3d` object and updates
the corresponding mesh indices.

## Usage

``` r
cleanMesh3d(mesh, onlyFinite = TRUE, allUsed = TRUE)
```

## Arguments

- mesh:

  `mesh3d` object representing the mesh to be cleaned.

- onlyFinite:

  Logical. If `TRUE`, vertices with non-finite coordinates are removed.
  Default is `TRUE`.

- allUsed:

  Logical. If `TRUE`, vertices that are not referenced by any mesh
  element are removed. Default is `TRUE`.

## Value

`mesh3d` object with the retained vertices and updated mesh indices.

## Details

This function is a simplified adaptation of the internal `cleanMesh3d()`
function from the `rgl` package. It retains only the functionality
required in `dimControl` to remove non-finite or unused vertices and
reindex the `ip`, `is`, `it`, and `ib` components.

If `onlyFinite = TRUE`, vertices containing non-finite coordinates are
removed. If `allUsed = TRUE`, vertices that are not referenced by any of
the `ip`, `is`, `it`, or `ib` components are removed.

Mesh elements that reference removed vertices are discarded, and the
remaining vertex indices are updated to match the new vertex matrix.

Unlike the original implementation, this version does not handle
additional mesh attributes such as tags, texture coordinates, vertex
attributes, or triangle rejoining.

## References

Murdoch, D., et al. *rgl: 3D Visualization Using OpenGL*. R package.
<https://CRAN.R-project.org/package=rgl>

## Examples

``` r
library(rgl)

# Create a cube mesh
cube <- cube3d()

# Add an unreferenced vertex
cube$vb <- cbind(cube$vb, c(10,10,10,1))

# Clean the mesh
cubeClean <- cleanMesh3d(cube)

# Compare the number of vertices
ncol(cube$vb)
#> [1] 9
ncol(cubeClean$vb)
#> [1] 8
```
