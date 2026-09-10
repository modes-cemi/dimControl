# Get the Current 3D View

Retrieves the current 3D view parameters from the active `rgl` device.

## Usage

``` r
getView3d()
```

## Value

A list containing:

- `zoom`: current zoom factor.

- `userMatrix`: current user transformation matrix.

- `userProjection`: current projection matrix.

## See also

[`setView3d()`](https://modes-cemi.github.io/dimControl/reference/setView3d.md),
[`rgl::par3d()`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html)

## Examples

``` r
if (FALSE) { # \dontrun{
rgl::open3d()

view <- getView3d()
view
} # }
```
