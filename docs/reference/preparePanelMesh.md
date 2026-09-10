# Prepare a Theoretical Panel Mesh for Point Cloud Simulation

Prepares a theoretical steel panel mesh from a CAD `mesh3d` object for
use in point cloud simulation. The function removes the lower face,
identifies the panel base, translates the mesh to the origin, and
removes triangles located below the Z = 0 plane.

## Usage

``` r
preparePanelMesh(
  mesh,
  lowerAngle = 120,
  horizontalAngle = 40,
  boundaryStrip = 10
)
```

## Arguments

- mesh:

  A `mesh3d` object containing the CAD geometry of the panel. The mesh
  must contain a triangular `it` matrix.

- lowerAngle:

  Numeric. Angular threshold in degrees used to identify the lower face
  of the panel. Default is `120`.

- horizontalAngle:

  Numeric. Maximum angle in degrees used to identify approximately
  horizontal faces. Default is `40`.

- boundaryStrip:

  Numeric. Width of the strip along the Y direction used to identify the
  reference corner of the panel base. Default is `10`.

## Value

A processed `mesh3d` object translated to the origin and ready for point
cloud simulation.

## Details

Face normals are used to remove the lower face and identify
approximately horizontal components. The boundary of the base is
extracted with
[`getBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/getBoundarySegments.md),
and a reference corner is used to translate the mesh to the origin.

## See also

[`simulatePanelFloorCloud()`](https://modes-cemi.github.io/dimControl/reference/simulatePanelFloorCloud.md),
[`getBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/getBoundarySegments.md),
[`angleFromAxis()`](https://modes-cemi.github.io/dimControl/reference/angleFromAxis.md)

## Examples

``` r
if (FALSE) { # \dontrun{
data("cad", package = "dimControl")

meshTeor <- preparePanelMesh(cad)

rgl::clear3d()
rgl::shade3d(meshTeor, col = "gray")
rgl::decorate3d()
} # }
```
