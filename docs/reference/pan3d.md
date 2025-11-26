# Interactive 3D View Panning

Enables camera panning in an **rgl** 3D scene, allowing the user to move
the view freely within the graphics window by dragging the mouse with
the specified button.

## Usage

``` r
pan3d(button, dev = rgl::cur3d(), subscene = rgl::currentSubscene3d(dev))
```

## Arguments

- button:

  Integer indicating the mouse button used for panning:

  - `1`: left button

  - `2`: right button

  - `3`: middle button (wheel)

- dev:

  RGL device ID (default
  [`rgl::cur3d()`](https://dmurdoch.github.io/rgl/dev/reference/open3d.html)).

- subscene:

  Subscene to which the movement is applied (default is the active
  subscene from
  [`rgl::currentSubscene3d()`](https://dmurdoch.github.io/rgl/dev/reference/subscene3d.html)).

## Value

No value is returned; the function sets mouse callbacks to pan the 3D
view interactively.

## Details

By default, **rgl** only allows rotation and zoom of 3D objects, but not
camera translation. This function extends the interaction by enabling
the user to translate the entire scene in any direction without altering
the model orientation.

Internally, the function uses mouse callbacks via
[`rgl::rgl.setMouseCallbacks()`](https://dmurdoch.github.io/rgl/dev/reference/callbacks.html),
so that when the mouse button is pressed and dragged, the projection
matrix (`userProjection`) is dynamically updated to simulate smooth
movement within the scene.

When the specified button is pressed, the function records the initial
cursor position (*begin* event). During mouse movement (*update* event),
it calculates the relative displacement and applies a translation
transformation on `userProjection` using
[`rgl::translationMatrix()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html),
allowing the camera to move in the drag direction and enabling free
movement of the scene in the graphics window.

## Note

The original code was developed by **Duncan Murdoch** as part of the
**rgl** package, where it is not exported. It is included here without
modifications to facilitate use within this package.

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
rgl::shade3d(mesh, col = "lightblue")
pan3d(2) # Activate panning with the right mouse button
} # }
```
