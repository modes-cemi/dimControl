#' Cálculo de ángulos direccionales de vectores normalizados
#'
#' Calcula el ángulo direccional entre un conjunto de vectores normalizados y una
#' dirección de referencia en una dimensión específica. Permite obtener el resultado
#' en grados o radianes, y considerar la dirección opuesta si se desea.
#'
#' @param v Matriz numérica de dimensión \eqn{d \times n}. Cada columna representa un vector normalizado.
#' @param dim Entero que indica la dimensión de referencia, con \eqn{1 \leq \text{dim} \leq d}.
#' @param negdir Lógico. Si es `TRUE`, considera la dirección negativa (ángulo complementario).
#' @param deg Lógico. Si es `TRUE`, devuelve los ángulos en grados; si es `FALSE`, en radianes.
#'
#' @returns Un vector numérico con los ángulos correspondientes a cada vector de entrada.
#'
#' @examples
#' \dontrun{
#' # Tres vectores normalizados en las direcciones X, Y y Z
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
#' }
#'
#' @export
angled2 <- function(v, dim, negdir = FALSE, deg = TRUE) {
  # Conversión de radianes a grados
  rad2deg <- function(x) (x / pi) * 180

  # Cálculo del ángulo direccional
  res <- acos(v[dim, ])
  if (negdir) res <- pi - res
  if (deg) res <- rad2deg(res)
  return(res)
}
