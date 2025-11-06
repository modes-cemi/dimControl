#' Leyenda categórica en 3D
#'
#' Representa una leyenda de categorías en una subescena lateral de una ventana 3D
#' de `rgl`. Cada categoría se muestra como una esfera coloreada acompañada de su etiqueta.
#' Resulta útil para acompañar representaciones creadas con `fshade3d()`.
#'
#' @param labels Vector de texto con las etiquetas de las categorías.
#' @param col Vector de colores correspondiente a cada categoría.
#' @param legend.zoom Número. Controla el nivel de zoom de la leyenda.
#' @param legend.width Número. Ancho relativo de las esferas de color.
#' @param legend.mar Número. Proporción del espacio horizontal reservado para la leyenda.
#' @param lab.dist Número. Distancia entre las etiquetas y las esferas.
#' @param lab.rev Lógico. Si es `TRUE`, invierte el orden vertical de las etiquetas.
#' @param ... Argumentos adicionales que se pasan a `axis3()`.
#'
#' @details
#' La función crea una disposición de subescenas mediante `rgl::layout3d()`, reservando
#' una franja lateral para la leyenda. Los símbolos se dibujan con `rgl::spheres3d()`
#' y las etiquetas con `axis3()`, una versión modificada que permite ajustar la distancia
#' y el formato de las etiquetas.
#'
#' La leyenda se orienta verticalmente a lo largo del eje Z y se representa en una
#' subescena independiente, lo que permite modificarla sin afectar la vista principal.
#'
#' @returns Devuelve invisiblemente el identificador de la subescena creada, que puede
#' utilizarse para modificar o actualizar la leyenda.
#'
#' @seealso
#' `fshade3d()`, `splot3d()`, `rgl::layout3d()`, `rgl::spheres3d()`, `axis3()`
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
