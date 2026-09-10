#' Interactive 3D View Panning
#'
#' Enables interactive panning in an `rgl` 3D scene by dragging the mouse with the
#' specified button. The view is translated without changing the model orientation.
#'
#' @param button Integer indicating the mouse button used for panning:
#' \itemize{
#'   \item `1`: left mouse button.
#'   \item `2`: right mouse button.
#'   \item `3`: middle mouse button.
#' }
#' @param dev An `rgl` device ID. Default is [rgl::cur3d()].
#' @param subscene Subscene to which the panning interaction is applied. Default is
#' the active subscene returned by [rgl::currentSubscene3d()].
#'
#' @returns
#' Invisibly returns `NULL`. The function sets mouse callbacks on the selected `rgl`
#' device to enable interactive panning.
#'
#' @details
#' When the specified mouse button is pressed, the initial cursor position and projection
#' parameters are stored. During mouse movement, the relative cursor displacement is
#' converted into a translation matrix using [rgl::translationMatrix()].
#'
#' The resulting transformation is applied to `userProjection` for each listening subscene,
#' producing an interactive translation of the 3D view.
#'
#' @note
#' This function is based on code developed by Duncan Murdoch for the `rgl` package
#' and adapted for use in this package.
#'
#' @author Duncan Murdoch
#'
#' @seealso [rgl::rgl.setMouseCallbacks()], [rgl::par3d()], [rgl::translationMatrix()]
#'
#' @examples
#' \dontrun{
#' rgl::open3d()
#'
#' mesh <- rgl::icosahedron3d()
#' rgl::shade3d(mesh, col = "lightgray")
#'
#' # Activate panning with the right mouse button
#' pan3d(2)
#' }
#'
#' @export
pan3d <- function(button, dev = rgl::cur3d(), subscene = rgl::currentSubscene3d(dev)) {
  start <- list()

  # Store initial mouse and projection parameters
  begin <- function(x, y) {
    activeSubscene <- rgl::par3d("activeSubscene", dev = dev)
    start$listeners <<- rgl::par3d("listeners", dev = dev, subscene = activeSubscene)

    for (sub in start$listeners) {
      init <- rgl::par3d(c("userProjection","viewport"), dev = dev, subscene = sub)

      init$pos <- c(x/init$viewport[3], 1 - y/init$viewport[4], 0.5)
      start[[as.character(sub)]] <<- init
    }
  }

  # Update projection according to mouse displacement
  update <- function(x, y) {

    for (sub in start$listeners) {
      init <- start[[as.character(sub)]]
      xlat <- 2*(c(x/init$viewport[3], 1 - y/init$viewport[4], 0.5) - init$pos)
      mouseMatrix <- rgl::translationMatrix(xlat[1], xlat[2], xlat[3])
      rgl::par3d(userProjection = mouseMatrix %*% init$userProjection, dev = dev, subscene = sub )
    }
  }

  # Register mouse callbacks
  rgl::rgl.setMouseCallbacks(button, begin, update, dev = dev, subscene = subscene)
  cat("Callbacks set on button", button, "of RGL device", dev, "in subscene", subscene, "\n")
}
