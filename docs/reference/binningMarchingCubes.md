# Generate a Triangular Mesh Using Binning and Marching Cubes

Reconstructs a triangular surface from a 3D point cloud and returns it
as a `mesh3d` object. The function performs linear binning using
[`npsp::binning()`](http://rubenfcasal.github.io/npsp/reference/binning.md),
adds external zero-valued layers in the Z direction, removes low-density
nodes, truncates high-density nodes and extracts the isosurface using
[`misc3d::contour3d()`](https://rdrr.io/pkg/misc3d/man/contour3d.html).

## Usage

``` r
binningMarchingCubes(
  panel,
  resol_nbin = c(4, 4, 2),
  mesh_cad = NULL,
  zero_layers_z = 1,
  k_factor = NULL,
  trunc_factor = 3.5,
  level_factor = 0.99,
  cad_coverage_tol = 0.99
)
```

## Arguments

- panel:

  A numeric matrix or data frame with three columns containing the X, Y
  and Z coordinates of the point cloud.

- resol_nbin:

  A numeric vector of length three defining the approximate binning
  resolution in the X, Y and Z directions. Default is `c(4, 4, 2)`.

- mesh_cad:

  Optional. A `mesh3d` object used as a reference to select or merge
  connected mesh components. Default is `NULL`.

- zero_layers_z:

  Integer. Number of zero-valued layers added above the binning grid in
  the Z direction. Default is `1`.

- k_factor:

  Numeric. Factor used to compute the tolerance for removing low-density
  nodes. If `NULL`, it is automatically assigned according to
  `resol_nbin`. Default is `NULL`.

- trunc_factor:

  Numeric. Factor used to truncate high-density node weights. Default is
  `3.5`.

- level_factor:

  Numeric. Factor used to define the isosurface extraction level from
  the truncated weights. Default is `0.99`.

- cad_coverage_tol:

  Numeric. Minimum proportion of the CAD model dimensions that must be
  covered by the reconstructed mesh when `mesh_cad` is provided. Default
  is `0.99`.

## Value

A list containing the reconstructed `mesh3d` object, the processed
binning object, the triangular surfaces returned by
[`misc3d::contour3d()`](https://rdrr.io/pkg/misc3d/man/contour3d.html)
and the parameters used during the reconstruction process.

## Details

If a CAD mesh is provided, disconnected mesh components are sorted by
size and merged until the reconstructed mesh reaches the specified
proportion of the CAD model dimensions.

## See also

[`npsp::binning()`](http://rubenfcasal.github.io/npsp/reference/binning.md),
[`npsp::coordvalues()`](http://rubenfcasal.github.io/npsp/reference/coordvalues.md),
[`misc3d::contour3d()`](https://rdrr.io/pkg/misc3d/man/contour3d.html),
[`rgl::tmesh3d()`](https://dmurdoch.github.io/rgl/dev/reference/mesh3d.html)

## Examples

``` r
if (FALSE) { # \dontrun{
result <- binningMarchingCubes(
  panel = panel,
  resol_nbin = c(4, 4, 2),
  mesh_cad = mesh_cad,
  zero_layers_z = 1
)

mesh <- result$mesh

rgl::open3d()
rgl::shade3d(mesh, col = "lightblue")
rgl::axes3d()
} # }
```
