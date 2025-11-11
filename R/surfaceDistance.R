#' Calcular la distancia sobre una superficie 3D
#'
#' Esta función calcula la longitud total de una trayectoria tridimensional, sumando
#' las distancias euclidianas entre puntos consecutivos. Es útil para estimar la distancia
#' desarrollada sobre una superficie 3D.
#'
#' @param segmento Matriz o data frame con tres columnas (`x`, `y`, `z`) que representan
#' las coordenadas de los puntos consecutivos en el espacio 3D.
#'
#' @returns Un valor numérico que indica la distancia total recorrida sobre la superficie.
#'
#' @export
surfaceDistance <- function(segmento) {
  dx <- diff(segmento[, 1])  # Diferencias en x
  dy <- diff(segmento[, 2])  # Diferencias en y
  dz <- diff(segmento[, 3])  # Diferencias en z
}
