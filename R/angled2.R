#' Cálculo de ángulos direccionales de vectores normalizados
#'
#' Calcula el ángulo direccional entre un conjunto de vectores normalizados y una
#' dirección de referencia en una dimensión específica. Permite obtener los resultados
#' en grados o radianes, y considerar la dirección negativa si se requiere.
#'
#' @param v Matriz numérica de dimensión \eqn{d \times n}, donde cada columna representa un vector normalizado.
#' @param dim Entero que indica el índice de la dimensión (entre 1 y \eqn{d}) con respecto a la cual se calcula el ángulo.
#' @param negdir Lógico. Si es `TRUE`, se considera la dirección negativa en el cálculo del ángulo.
#' @param deg Lógico. Si es `TRUE`, los ángulos se devuelven en grados; si es `FALSE`, en radianes.
#'
#' @returns Un vector numérico con los ángulos correspondientes de cada vector.
#'
#' @examples
#' # Ejemplo con tres vectores normalizados en 3D
#' v <- matrix(c(1, 0, 0,
#'               0, 1, 0,
#'               0, 0, 1), nrow = 3)
#'
#' # Ángulo respecto al eje X
#' angled2(v, dim = 1)
#'
#' # Ángulo respecto al eje Y
#' angled2(v, dim = 2)
#'
#' # Ángulo respecto al eje Z
#' angled2(v, dim = 3)
#'
#' @export
angled2 <- function(v, dim, negdir = FALSE, deg = TRUE) {
  # Función para convertir radianes a grados
  rad2deg <- function(x) (x / pi) * 180

  # Cálculo del ángulo direccional
  res <- acos(v[dim, ])
  if (negdir) res <- pi - res
  if (deg) res <- rad2deg(res)
  return(res)
}
