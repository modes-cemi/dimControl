#' Obtener la vista 3D actual
#'
#' Recupera los parámetros actuales de la vista 3D del dispositivo activo de rgl.
#'
#' @returns Lista con `zoom`, `userMatrix` y `userProjection`.
#'
#' @export
getview3d <- function() {
  rgl::par3d()[c("zoom", "userMatrix", "userProjection")]
}
