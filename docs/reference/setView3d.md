# Set a 3D View

Applies previously saved 3D view parameters to the active `rgl` device.
The view can be obtained using
[`getView3d()`](https://modes-cemi.github.io/dimControl/reference/getView3d.md).

## Usage

``` r
setView3d(view)
```

## Arguments

- view:

  A list containing 3D view parameters, typically obtained from
  [`getView3d()`](https://modes-cemi.github.io/dimControl/reference/getView3d.md).

## Value

Invisibly returns the result of
[`rgl::par3d()`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html).

## See also

[`getView3d()`](https://modes-cemi.github.io/dimControl/reference/getView3d.md),
[`rgl::par3d()`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html)

## Examples

``` r
if (FALSE) { # \dontrun{
mesh <- rgl::icosahedron3d()
rgl::shade3d(mesh, color = "lightgray")

# Save the current view
view <- getView3d()

# Restore the saved view
setView3d(view)
} # }
```
