#' Interactive 3D View Panning
#'
#' Enables camera panning in an **rgl** 3D scene, allowing the user to move the view
#' freely within the graphics window by dragging the mouse with the specified button.
#'
#' By default, **rgl** only allows rotation and zoom of 3D objects, but not camera
#' translation. This function extends the interaction by enabling the user to translate
#' the entire scene in any direction without altering the model orientation.
#'
#' Internally, the function uses mouse callbacks via `rgl::rgl.setMouseCallbacks()`,
#' so that when the mouse button is pressed and dragged, the projection matrix (`userProjection`)
#' is dynamically updated to simulate smooth movement within the scene.
#'
#' @param button Integer indicating the mouse button used for panning:
#'   \itemize{
#'     \item `1`: left button
#'     \item `2`: right button
#'     \item `3`: middle button (wheel)
#'   }
#' @param dev RGL device ID (default `rgl::cur3d()`).
#' @param subscene Subscene to which the movement is applied (default is the active
#' subscene from `rgl::currentSubscene3d()`).
#'
#' @returns No value is returned; the function sets mouse callbacks to pan the 3D
#'          view interactively.
#'
#' @details
#' When the specified button is pressed, the function records the initial cursor position
#' (*begin* event). During mouse movement (*update* event), it calculates the relative
#' displacement and applies a translation transformation on `userProjection` using
#' `rgl::translationMatrix()`, allowing the camera to move in the drag direction and
#' enabling free movement of the scene in the graphics window.
#'
#' @note The original code was developed by **Duncan Murdoch** as part of the **rgl**
#' package, where it is not exported. It is included here without modifications to
#' facilitate use within this package.
#'
#' @author Duncan Murdoch
#'
#' @seealso `rgl::rgl.setMouseCallbacks()`, `rgl::par3d()`, `rgl::translationMatrix()`
#'
#' @examples
#' \dontrun{
#' rgl::open3d()
#' mesh <- rgl::icosahedron3d()
#' rgl::shade3d(mesh, col = "lightblue")
#' pan3d(2) # Activate panning with the right mouse button
#' }
#'
#' @export
pan3d <- function(button, dev = rgl::cur3d(), subscene = rgl::currentSubscene3d(dev)) {
  start <- list()

  begin <- function(x, y) {
    activeSubscene <- rgl::par3d("activeSubscene", dev = dev)
    start$listeners <<- rgl::par3d("listeners", dev = dev, subscene = activeSubscene)
    for (sub in start$listeners) {
      init <- rgl::par3d(c("userProjection","viewport"), dev = dev, subscene = sub)
      init$pos <- c(x/init$viewport[3], 1 - y/init$viewport[4], 0.5)
      start[[as.character(sub)]] <<- init
    }
  }

  update <- function(x, y) {
    for (sub in start$listeners) {
      init <- start[[as.character(sub)]]
      xlat <- 2*(c(x/init$viewport[3], 1 - y/init$viewport[4], 0.5) - init$pos)
      mouseMatrix <- rgl::translationMatrix(xlat[1], xlat[2], xlat[3])
      rgl::par3d(userProjection = mouseMatrix %*% init$userProjection, dev = dev, subscene = sub )
    }
  }
  rgl::rgl.setMouseCallbacks(button, begin, update, dev = dev, subscene = subscene)
  cat("Callbacks set on button", button, "of RGL device", dev, "in subscene", subscene, "\n")
}
