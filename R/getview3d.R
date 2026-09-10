#' Get the Current 3D View
#'
#' Retrieves the current 3D view parameters from the active `rgl` device.
#'
#' @returns
#' A list containing:
#' \itemize{
#'   \item `zoom`: current zoom factor.
#'   \item `userMatrix`: current user transformation matrix.
#'   \item `userProjection`: current projection matrix.
#' }
#'
#' @seealso [setView3d()], [rgl::par3d()]
#'
#' @examples
#' \dontrun{
#' rgl::open3d()
#'
#' view <- getView3d()
#' view
#' }
#'
#' @export
getView3d <- function() {
  rgl::par3d()[c("zoom", "userMatrix", "userProjection")]
}
