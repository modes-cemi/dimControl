#' Calcular los límites espaciales (bounding box) de una malla 3D
#'
#' Determina las coordenadas mínimas y máximas de los vértices de una malla 3D, devolviendo
#' una matriz con los valores extremos en los ejes `X`, `Y` y `Z`.
#'
#' @param x Objeto de clase `mesh3d` que contiene los vértices de la malla en el componente `vb`.
#'
#' @returns
#' Una matriz de 3 filas y 2 columnas con los valores mínimos y máximos de las coordenadas
#' de los vértices:
#' - Cada fila corresponde a un eje (`x`, `y`, `z`).
#' - La primera columna (`min`) contiene los valores mínimos.
#' - La segunda columna (`max`) contiene los valores máximos.
#'
#' @details
#' Internamente, la función convierte las coordenadas homogéneas de `x$vb` en coordenadas
#' euclidianas mediante `rgl::asEuclidean2()` y calcula los rangos por eje con `apply(..., range)`.
#'
#' @seealso `rgl::asEuclidean2()`
#'
#' @examples
#' \dontrun{
#' # Crear una malla cúbica
#' cube <- rgl::cube3d()
#'
#' # Calcular su bounding box
#' bbox(cube)
#' }
#'
#' @export
bbox <- function(x) {
  t(matrix(
    apply(rgl::asEuclidean2(x$vb), 1, range),
    nrow = 2,
    dimnames = list(c("min", "max"), c("x", "y", "z"))
  ))
}
