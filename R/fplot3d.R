#' Representa una leyenda categórica en una escena 3D
#'
#' Crea una subescena lateral en una ventana 3D activa de `rgl`, que muestra una leyenda
#' compuesta por esferas de colores y sus etiquetas asociadas. Está pensada para acompañar
#' representaciones realizadas con [`fshade3d()`].
#'
#' @param labels Etiquetas que se mostrarán junto a los colores.
#' @param col Vector de colores que define el color de cada nivel de la leyenda.
#' @param legend.zoom Factor de zoom para ajustar el tamaño de la leyenda.
#' @param legend.width Ancho relativo de los símbolos de color (esferas).
#' @param legend.mar Proporción del espacio horizontal reservado para la leyenda respecto
#'   al total de la escena.
#' @param lab.dist Distancia entre las etiquetas y los símbolos de color.
#' @param lab.rev Si es `TRUE`, invierte el orden de las etiquetas en el eje Z.
#' @param ... parámetros adicionales que se pasan a [`axis3()`].
#'
#' @details
#' La función crea una disposición de subescenas mediante [`layout3d()`], reservando
#' una franja lateral para la leyenda. Los símbolos se dibujan con [`spheres3d()`] y
#' las etiquetas mediante [`axis3()`].
#'
#' Por defecto, la leyenda se orienta verticalmente, con las etiquetas alineadas en el eje Z.
#'
#' @returns Devuelve (invisiblemente) el identificador del subescenario creado, que
#' puede usarse para modificar o actualizar la leyenda.
#'
#' @seealso
#' [`fshade3d()`], [`rgl::layout3d()`], [`rgl::spheres3d()`], [`axis3()`]
#'
fplot3d <- function(labels, col = seq_along(labels), legend.zoom = 0.6,
                    legend.width = 0.1, legend.mar = 0.2,
                    lab.dist = 2.5, lab.rev = FALSE, ...) {
  if (missing(labels)) labels <- seq_along(col)
  # Suspend drawing update
  rgl::par3d(skipRedraw = TRUE)
  # Split into subscenes
  subscene <- rgl::layout3d(matrix(c(2, 1), nrow = 1),
                       widths = c(1 - legend.mar, legend.mar))
  rgl::next3d() # move to the scene corresponding to the legend
  # Legend values
  slim <- c(0, 1)
  nbins <- length(labels)
  binwidth <- (slim[2] - slim[1]) / nbins
  radius <- binwidth * legend.width
  iz <- seq(slim[2] - binwidth/2, slim[1] + binwidth/2, len = nbins) # midpoints
  # iz <- seq(slim[1] + binwidth/2, slim[2] - binwidth/2, by = binwidth) # midpoints
  if (lab.rev) iz <- sort(iz)
  # Draw legend
  rgl::spheres3d(x = 0, y = 0, z = iz, radius = radius, color = col)
  # Add legend axis
  axis3('z+-', at = iz, tick = FALSE, line = FALSE, ticksize = 0.5,
        labeldist = lab.dist, labels = labels, ...)
  # Set viewpoint
  rgl::view3d(phi = -90, fov = 0, zoom = legend.zoom)
  # Enable drawing update and move to the main plot scene
  rgl::par3d(skipRedraw = FALSE)
  rgl::next3d()
  # Return subscene id values
  return(invisible(subscene))
}
