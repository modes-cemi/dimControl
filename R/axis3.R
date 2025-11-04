#' Dibujar ejes y ticks en 3D
#'
#' Añade un eje tridimensional con ticks y etiquetas a la escena 3D actual. Se puede
#' usar para complementar visualizaciones con mallas coloreadas o superficies.
#'
#' @param edge Carácter de longitud 3. Indica la orientación y signo del eje a dibujar.
#' @param at Vector numérico. Posiciones donde colocar los ticks del eje. Si es \code{NULL}, se generan automáticamente.
#' @param labels Lógico o vector de caracteres. Si es \code{TRUE}, se usan valores de \code{at} como etiquetas; si es \code{FALSE}, no se dibujan; si es un vector, se usan directamente.
#' @param tick Lógico. Si \code{TRUE}, dibuja las marcas de los ticks.
#' @param line Lógico. Si \code{TRUE}, dibuja la línea del eje.
#' @param pos Vector numérico de longitud 3. Posición fija de los ticks y etiquetas; si \code{NULL}, se calcula según \code{edge}.
#' @param nticks Número de ticks sugeridos si \code{at = NULL}.
#' @param ticksize Número. Tamaño relativo de las marcas de los ticks.
#' @param labeldist Número. Distancia de las etiquetas respecto a los ticks.
#' @param ... Argumentos adicionales pasados a \code{\link[rgl]{segments3d}} o \code{\link[rgl]{text3d}}.
#'
#' @returns Devuelve invisiblemente el ID de la subescena creada para la leyenda,
#' permitiendo manipularla de forma independiente.
#'
#' @details
#' La función calcula la posición de los ticks y etiquetas según la orientación del eje
#' y la escena actual de \code{rgl}. Permite dibujar ejes en cualquier borde de la caja 3D
#' y ajustar su tamaño y distancia de etiquetas. Es útil para añadir referencias visuales
#' a mallas coloreadas o superficies.
#'
axis3 <- function (edge, at = NULL, labels = TRUE, tick = TRUE, line = TRUE,
                   pos = NULL, nticks = 5, ticksize = 0.05, labeldist = 3, ...) {
  save <- par3d(skipRedraw = TRUE, ignoreExtent = TRUE)
  on.exit(par3d(save))

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
