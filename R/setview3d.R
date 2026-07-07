#' Set a 3D View
#'
#' Applies a previously saved 3D view to the active `rgl` device.
#'
#' @param view A list obtained from `getview3d()`.
#'
#' @export
setView3d <- function(view) {
  do.call(rgl::par3d, view)
}
