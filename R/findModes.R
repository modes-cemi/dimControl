#' Calcular modas de un conjunto de datos
#'
#' Esta función detecta los picos (modas) en un conjunto de datos `x` usando estimación
#' de densidad. Para cada moda, determina el rango en el eje X donde la densidad desciende
#' hacia los mínimos adyacentes. También permite representar la densidad y los picos
#' detectados.
#'
#' @param x Vector numérico. Los datos sobre los que se calcularán las modas.
#' @param bw  Número. Ancho de banda (\emph{bandwidth}) para la estimación de densidad.
#' Por defecto `bw = 2`.
#' @param Q1 Número entre 0 y 1. Percentil de la densidad que se usa para filtrar
#'   los picos más relevantes. Por defecto `Q1 = 0.95`.
#' @param plot Lógico. Si es `TRUE`, se genera un gráfico de la densidad con los picos
#'   detectados. Por defecto es `TRUE`.
#'
#' @returns Una matriz con tantas filas como modas detectadas y dos columnas: `min`
#' y `max`, que representan el rango en X de cada moda.
#'
#' @examples
#' set.seed(123) # Semilla
#' x <- c(
#'   rnorm(200, mean = 2, sd = 0.3),
#'   rnorm(5, mean = 3.5, sd = 0.1),
#'   rnorm(200, mean = 5, sd = 0.3)
#' )
#'
#' # Calcular y representar modas
#' modas <- findModes(x, bw = 0.2, Q1 = 0.5, plot = TRUE)
#'
#' # Rangos en X de cada moda
#' modas
#'
#' @importFrom stats density quantile
#' @importFrom graphics points
#'
#' @export
findModes <- function(x, bw = 2, Q1 = 0.95, plot = TRUE) {

  # Densidad de X
  densX <- density(x, bw = bw)
  y <- densX$y
  xvals <- densX$x

  # Detección de picos
  picos_indices <- which(
    (y[1:(length(y) - 2)] < y[2:(length(y) - 1)]) &
      (y[2:(length(y) - 1)] > y[3:length(y)])
  ) + 1

  # Percentil Q1 para seleccionar los picos más relevantes
  PQ1 <- quantile(y, Q1)
  picos_filtrados <- picos_indices[y[picos_indices] > PQ1]

  # Guardar modas
  modas <- matrix(nrow = length(picos_filtrados), ncol = 2,
                  dimnames = list(paste0("moda", seq_along(picos_filtrados)), c("min", "max")))

  # Rangos de cada moda
  for (i in seq_along(picos_filtrados)) {
    pico_index <- picos_filtrados[i]

    iinicio_descenso <- pico_index
    while (iinicio_descenso > 1 && y[iinicio_descenso] >= y[iinicio_descenso - 1]) {
      iinicio_descenso <- iinicio_descenso - 1
    }
    ini_moda <- xvals[iinicio_descenso]

    ifin_descenso <- pico_index
    while (ifin_descenso < length(y) && y[ifin_descenso] >= y[ifin_descenso + 1]) {
      ifin_descenso <- ifin_descenso + 1
    }
    fin_moda <- xvals[min(ifin_descenso + 1, length(xvals))]

    modas[i, ] <- c(ini_moda, fin_moda)
  }

  if (plot) {
    plot(densX, main = "", xlab = deparse(substitute(x)), ylab = "Densidad")
    points(xvals[picos_filtrados], y[picos_filtrados], col = 6, pch = 19, cex = 0.7)
    # Líneas opcionales para marcar los rangos
    # abline(v = modas[, 1], col = "blue", lty = 2)
    # abline(v = modas[, 2], col = "red", lty = 2)
  }

  return(modas)
}
