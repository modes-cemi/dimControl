#' Establecer una vista 3D
#'
#' Aplica una vista previamente guardada al dispositivo rgl.
#'
#' @param view Lista obtenida con `getview3d()`.
#'
#' @export
setview3d <- function(view) {
  do.call(par3d, view)
}
