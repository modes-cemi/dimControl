#' Set a 3D View
#'
#' Applies previously saved 3D view parameters to the active `rgl` device. The view
#' can be obtained using [getView3d()].
#'
#' @param view A list containing 3D view parameters, typically obtained from [getView3d()].
#'
#' @returns
#' Invisibly returns the result of [rgl::par3d()].
#'
#' @seealso [getView3d()], [rgl::par3d()]
#'
#' @examples
#' \dontrun{
#' mesh <- rgl::icosahedron3d()
#' rgl::shade3d(mesh, color = "lightgray")
#'
#' # Save the current view
#' view <- getView3d()
#'
#' # Restore the saved view
#' setView3d(view)
#' }
#'
#' @export
setView3d <- function(view) {
  do.call(rgl::par3d, view)
}
