# Interactive 3D View Panning

Enables interactive panning in an `rgl` 3D scene by dragging the mouse
with the specified button. The view is translated without changing the
model orientation.

## Usage

``` r
pan3d(button, dev = rgl::cur3d(), subscene = rgl::currentSubscene3d(dev))
```

## Arguments

- button:

  Integer indicating the mouse button used for panning:

  - `1`: left mouse button.

  - `2`: right mouse button.

  - `3`: middle mouse button.

- dev:

  An `rgl` device ID. Default is
  [`rgl::cur3d()`](https://dmurdoch.github.io/rgl/dev/reference/open3d.html).

- subscene:

  Subscene to which the panning interaction is applied. Default is the
  active subscene returned by
  [`rgl::currentSubscene3d()`](https://dmurdoch.github.io/rgl/dev/reference/subscene3d.html).

## Value

Invisibly returns `NULL`. The function sets mouse callbacks on the
selected `rgl` device to enable interactive panning.

## Details

When the specified mouse button is pressed, the initial cursor position
and projection parameters are stored. During mouse movement, the
relative cursor displacement is converted into a translation matrix
using
[`rgl::translationMatrix()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html).

The resulting transformation is applied to `userProjection` for each
listening subscene, producing an interactive translation of the 3D view.

## Note

This function is based on code developed by Duncan Murdoch for the `rgl`
package and adapted for use in this package.

## See also

[`rgl::rgl.setMouseCallbacks()`](https://dmurdoch.github.io/rgl/dev/reference/callbacks.html),
[`rgl::par3d()`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html),
[`rgl::translationMatrix()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)

## Author

Duncan Murdoch

## Examples

``` r
if (FALSE) { # \dontrun{
rgl::open3d()

mesh <- rgl::icosahedron3d()
rgl::shade3d(mesh, col = "lightgray")

# Activate panning with the right mouse button
pan3d(2)
} # }
```
