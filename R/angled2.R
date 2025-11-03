#' Cálculo de ángulos direccionales de vectores normalizados
#'
#' Calcula el ángulo direccional entre un conjunto de vectores normalizados y una
#' dirección de referencia en una dimensión específica. Permite obtener el resultado
#' en grados o radianes y considerar la dirección negativa si es necesario.
#'
#' @param v Matriz numérica de dimensión \eqn{d \times n}. Cada columna representa un vector normalizado.
#' @param dim Índice de la dimensión de referencia, con \eqn{1 \leq \text{dim} \leq d}.
#' @param negdir Valor lógico. Si es `TRUE`, considera la dirección negativa en el cálculo del ángulo.
#' @param deg Valor lógico. Si es `TRUE`, devuelve los ángulos en grados; si es `FALSE`, en radianes.
#'
#' @returns Vector numérico con los ángulos correspondientes a cada vector de entrada.
#'
#' @examples
#' # Ejemplo con tres vectores normalizados
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
