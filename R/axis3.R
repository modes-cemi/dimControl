#' Ejes 3D con control de la distancia de etiquetas y longitud de marcas
#'
#' Dibuja ejes 3D con opciones adicionales para ajustar la distancia de las etiquetas
#' respecto al eje y la longitud de las marcas (*ticks*). Esta función extiende la
#' funcionalidad de `rgl::axis3d()`, ofreciendo un control más preciso sobre la apariencia
#' de los ejes en gráficos tridimensionales.
#'
#' @param edge Carácter de longitud 3. Indica la orientación y signo del eje a dibujar.
#' @param at Vector numérico. Posiciones donde colocar las marcas del eje. Si es `NULL`,
#' se calculan automáticamente.
#' @param labels Etiquetas de texto de las marcas. Si es `TRUE`, se generan a partir de `at`.
#' @param tick Lógico. Si es `TRUE` (por defecto), se dibujan las marcas del eje.
#' @param line Lógico. Si es `TRUE`, dibuja la línea del eje.
#' @param pos Posición donde se dibuja el eje o las etiquetas.
#' @param nticks Número sugerido de marcas si `at` es `NULL`.
#' @param ticksize Longitud de las marcas (*ticks*). Parámetro adicional respecto a `rgl::axis3d()`.
#' @param labeldist Distancia entre las etiquetas y el eje. Parámetro adicional respecto a `rgl::axis3d()`.
#' @param ... Argumentos adicionales pasados a `rgl::text3d()` o `rgl::segments3d()`.
#'
#' @returns Devuelve los identificadores de los objetos añadidos a la escena (`object IDs`),
#' de forma coherente con las funciones gráficas de `rgl`.
#'
#' @details
#' Modificación de `rgl::axis3d()` que permite controlar la posición de las etiquetas
#' y la longitud de las marcas mediante los nuevos parámetros `ticksize` y `labeldist`.
#'
#' - `ticksize`: ajusta la longitud de las marcas del eje.
#' - `labeldist`: controla la distancia entre las etiquetas y el eje.
#'
#' Estos parámetros son útiles cuando las etiquetas se solapan con la geometría del
#' modelo o se desea mejorar la legibilidad de la representación.
#'
#' @note
#' La función se basa parcialmente en la implementación original de `rgl::axis3d()`
#' desarrollada por Duncan Murdoch y el equipo de **rgl**. Esta versión ha sido modificada
#' en el paquete `controlDim` para proporcionar un mayor control sobre el diseño gráfico.
#'
axis3 <- function (edge, at = NULL, labels = TRUE, tick = TRUE, line = TRUE,
                   pos = NULL, nticks = 5, ticksize = 0.05, labeldist = 3, ...) {
  save <- rgl::par3d(skipRedraw = TRUE, ignoreExtent = TRUE)
  on.exit(rgl::par3d(save))

  # Función local equivalente a rgl:::.getRanges()
  getRanges <- function (expand = 1.03, ranges = rgl::par3d("bbox")) {
    ranges <- list(xlim = ranges[1:2], ylim = ranges[3:4], zlim = ranges[5:6])
    strut <- FALSE
    ranges <- lapply(ranges, function(r) {
      d <- diff(r)
      if (d > 0)
        return(r)
      strut <<- TRUE
      if (d < 0)
        return(c(0, 1))
      else if (r[1] == 0)
        return(c(-1, 1))
      else return(r[1] + 0.4 * abs(r[1]) * c(-1, 1))
    })
    ranges$strut <- strut
    ranges$x <- (ranges$xlim - mean(ranges$xlim)) * expand + mean(ranges$xlim)
    ranges$y <- (ranges$ylim - mean(ranges$ylim)) * expand + mean(ranges$ylim)
    ranges$z <- (ranges$zlim - mean(ranges$zlim)) * expand + mean(ranges$zlim)
    ranges
  }

  # Sustituir llamada interna
  ranges <- getRanges()

  edge <- c(strsplit(edge, "")[[1]], "-", "-")[1:3]
  coord <- match(toupper(edge[1]), c("X", "Y", "Z"))
  if (coord == 2)
    edge[1] <- edge[2]
  else if (coord == 3)
    edge[1:2] <- edge[2:3]
  range <- ranges[[coord]]
  if (is.null(at)) {
    at <- pretty(range, nticks)
    at <- at[at >= range[1] & at <= range[2]]
  }
  if (is.logical(labels)) {
    if (labels)
      labels <- format(at)
    else labels <- NA
  }
  mpos <- matrix(NA, 3, length(at))
  if (edge[1] == "+")
    mpos[1, ] <- ranges$x[2]
  else mpos[1, ] <- ranges$x[1]
  if (edge[2] == "+")
    mpos[2, ] <- ranges$y[2]
  else mpos[2, ] <- ranges$y[1]
  if (edge[3] == "+")
    mpos[3, ] <- ranges$z[2]
  else mpos[3, ] <- ranges$z[1]
  ticksize <- ticksize * (mpos[, 1] - c(mean(ranges$x), mean(ranges$y),
                                        mean(ranges$z)))
  ticksize[coord] <- 0
  if (!is.null(pos))
    mpos <- matrix(pos, 3, length(at))
  mpos[coord, ] <- at
  result <- c()
  if (line) {
    x <- c(mpos[1, 1], mpos[1, length(at)])
    y <- c(mpos[2, 1], mpos[2, length(at)])
    z <- c(mpos[3, 1], mpos[3, length(at)])
    result <- c(line = rgl::segments3d(x, y, z, ...))
  }
  if (tick) {
    x <- as.double(rbind(mpos[1, ], mpos[1, ] + ticksize[1]))
    y <- as.double(rbind(mpos[2, ], mpos[2, ] + ticksize[2]))
    z <- as.double(rbind(mpos[3, ], mpos[3, ] + ticksize[3]))
    result <- c(result, ticks = rgl::segments3d(x, y, z, ...))
  }
  if (!all(is.na(labels)))
    result <- c(result, labels = rgl::text3d(mpos[1, ] + labeldist * ticksize[1],
                                        mpos[2, ] + labeldist * ticksize[2],
                                        mpos[3, ] + labeldist * ticksize[3],
                                        labels, ...))
  rgl::lowlevel(result)
}
