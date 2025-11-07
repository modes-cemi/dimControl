#' Calcular la distancia euclidiana entre dos puntos
#'
#' Calcula la distancia lineal (euclidiana) a partir de un vector de diferencias entre
#' las coordenadas de dos puntos.
#'
#' Esta función aplica la fórmula clásica de la distancia euclidiana:
#' \deqn{d = \sqrt{\sum_i (h_i)^2}}, donde \eqn{h_i} representa la diferencia en cada
#' coordenada.
#'
#' @param h Vector numérico que contiene las diferencias entre las coordenadas de
#' dos puntos (por ejemplo, `c(x2 - x1, y2 - y1, z2 - z1)`).
#'
#' @returns Un valor numérico que representa la distancia euclidiana entre los dos puntos.
#'
#' @examples
#' # Diferencia entre dos puntos en 3D
#' h <- c(3 - 0, 4 - 0, 0 - 0)
#'
#' # Calcular la distancia euclidiana
#' deuclid(h)
#'
#' @export
deuclid <- function(h) {
  sqrt(sum((h)^2))
}
