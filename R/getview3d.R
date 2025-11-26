#' Get the Current 3D View
#'
#' Retrieves the current 3D view parameters from the active `rgl` device.
#'
#' @returns A list containing the current `zoom`, `userMatrix`, and `userProjection`.
#'
#' @export
getview3d <- function() {
  rgl::par3d()[c("zoom", "userMatrix", "userProjection")]
}
