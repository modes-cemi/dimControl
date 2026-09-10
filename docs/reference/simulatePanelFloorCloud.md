# Simulate a Steel Panel and Floor Point Cloud

Generates a simulated 3D point cloud representing a steel panel and its
surrounding floor.

## Usage

``` r
simulatePanelFloorCloud(
  mesh,
  nPanel = 1e+07,
  nFloor = 1e+06,
  prec = 0.5,
  sdPanel = 0.2,
  sdFloorZ = 0.2,
  marginXY = 20,
  gapZ = 2,
  seed = 1
)
```

## Arguments

- mesh:

  A theoretical `mesh3d` object representing the panel, typically
  obtained with
  [`preparePanelMesh()`](https://modes-cemi.github.io/dimControl/reference/preparePanelMesh.md).

- nPanel:

  Number of points sampled from the panel surface. Default is `1e7`.

- nFloor:

  Number of points generated for the surrounding floor. Default is
  `1e6`.

- prec:

  Positive numeric value defining the truncation limits of the noise
  applied to the panel coordinates. Default is `0.5`.

- sdPanel:

  Standard deviation of the truncated normal noise applied to the panel
  coordinates. Default is `0.2`.

- sdFloorZ:

  Standard deviation of the vertical noise applied to the floor points.
  Default is `0.2`.

- marginXY:

  Additional distance used to extend the simulated floor beyond the
  panel bounding box. Default is `20`.

- gapZ:

  Vertical distance between the lowest point of the panel and the mean
  height of the simulated floor. Default is `2`.

- seed:

  Integer used to initialise the random number generator. Default is
  `1`.

## Value

A data frame with numeric columns `X`, `Y`, and `Z`. The first `nPanel`
rows correspond to panel points and the remaining `nFloor` rows
correspond to floor points.

## Details

Panel points are sampled from a theoretical `mesh3d` surface using
[`sampleMesh()`](https://modes-cemi.github.io/dimControl/reference/sampleMesh.md)
and perturbed with truncated normal noise. Floor points are generated in
four regions surrounding the panel in the XY plane.

Setting `nFloor = 0` generates only points from the panel surface.

## See also

[`preparePanelMesh()`](https://modes-cemi.github.io/dimControl/reference/preparePanelMesh.md),
[`sampleMesh()`](https://modes-cemi.github.io/dimControl/reference/sampleMesh.md)

## Examples

``` r
if (FALSE) { # \dontrun{
data("cad", package = "dimControl")

meshTeor <- preparePanelMesh(cad)

data <- simulatePanelFloorCloud(
  mesh = meshTeor,
  nPanel = 1e7,
  nFloor = 1e6,
  seed = 1
)

dim(data)
head(data)

rgl::clear3d()
rgl::points3d(data, col = "gray")
rgl::decorate3d()
} # }
```
