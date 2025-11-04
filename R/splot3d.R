#' Dibujar una barra de colores continua en 3D
#'
#' Genera una leyenda de colores continua en 3D que puede acompañar a mallas coloreadas
#' según valores numéricos (por ejemplo, con \code{\link{sshade3d}}). Cada cubito de
#' la barra representa un valor dentro del rango definido por \code{slim} y se colorea
#' según la paleta \code{col}.
#'
#' @param slim Vector numérico de longitud 2. Valores mínimo y máximo de la escala de colores.
#' @param col Vector de colores que define la paleta de la leyenda.
#' @param legend.zoom Número. Zoom de la leyenda.
#' @param legend.width Número. Anchura relativa de la leyenda.
#' @param legend.mar Número. Margen entre la malla y la leyenda.
#' @param legend.lab Vector de caracteres. Etiquetas para los ticks de la leyenda. Si \code{NULL},
#' se generan automáticamente.
#' @param box Lógico. Si \code{TRUE}, dibuja un marco alrededor de la leyenda.
#' @param lab.breaks Vector numérico o lógico. Define las posiciones de los ticks de la leyenda.
#' @param lab.ticksize Número. Tamaño de las marcas de los ticks.
#' @param lab.dist Distancia de las etiquetas respecto a la barra de la leyenda.
#' @param ... Argumentos adicionales pasados a funciones de \pkg{rgl}.
#'
#' @returns Devuelve invisiblemente el ID de la subescena creada para la leyenda, permitiendo
#' manipularla de forma independiente.
#'
#' @details
#' La función utiliza una subescena de \code{rgl} para colocar la leyenda junto a la
#' malla sin afectar la escena principal. Suspendiendo temporalmente el renderizado,
#' se optimiza la creación de la barra de colores y luego se reactiva.
#'
splot3d <- function(slim = c(0, 1), col = jet.colors(128), legend.zoom = 0.6,
                    legend.width = 0.1, legend.mar = 0.2, legend.lab = NULL,
                    box = TRUE, lab.breaks = NULL, lab.ticksize = 0.5,
                    lab.dist = 2.5, ...) {
  # Suspend drawing update
  rgl::par3d(skipRedraw = TRUE)
  # Split into subscenes
  subscene <- rgl::layout3d(matrix(c(2, 1), nrow = 1),
                       widths = c(1 - legend.mar, legend.mar))
  rgl::next3d() # move to the scene corresponding to the legend
  # Legend values
  legend.width = (slim[2] - slim[1]) * legend.width
  if(is.null(lab.breaks)) lab.breaks = TRUE
  # Legend breaks
  nbins <- length(col)
  binwidth <- (slim[2] - slim[1]) / nbins
  iz <- seq(slim[1] + binwidth/2, slim[2] - binwidth/2, by = binwidth) # midpoints
  # Draw legend
  cube <- rgl::cube3d(trans = rgl::scaleMatrix(legend.width/2, legend.width/2, binwidth),
                 meshColor = "faces", lit = FALSE, smooth = FALSE)
  rgl::shapelist3d(cube, x = 0, y = 0, z = iz, color = col)
  # Add legend axis
  axis3('z+-', line = FALSE, ticksize = lab.ticksize, labeldist = lab.dist,
        labels = lab.breaks, ...)
  # Draw a box around the legend?
  if (box) {
    xlim <- legend.width * c(-0.5, 0.5)
    zlim <- c(slim[1] - binwidth/2, slim[2] + binwidth/2)
    x <- c(rep(xlim[1], 8), rep(xlim, 4), rep(xlim[2], 8))
    y <- c(rep(xlim, 2), rep(xlim, c(2, 2)), rep(xlim, c(4, 4)), rep(xlim, 2),
           rep(xlim, c(2, 2)))
    z <- c(rep(zlim, c(2, 2)), rep(zlim, 2), rep(rep(zlim, c(2, 2)), 2),
           rep(zlim, c(2, 2)), rep(zlim, 2))
    rgl::segments3d(x, y, z)
  }
  # Set viewpoint
  rgl::view3d(phi = -90, fov = 0, zoom = legend.zoom)
  # Enable drawing update and move to the main plot scene
  rgl::par3d(skipRedraw = FALSE)
  rgl::next3d()
  # Return subscene id values
  return(invisible(subscene))
}
