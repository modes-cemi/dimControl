#' Barra de colores continua en 3D
#'
#' Dibuja una barra de colores continua en una subescena 3D que acompaña a una malla
#' coloreada según valores numéricos, como las generadas con `sshade3d`. Cada cubo
#' de la barra representa un intervalo del rango definido por `slim` y se colorea
#' según la paleta `col`.
#'
#' @param slim Vector numérico de longitud 2 que indica los valores mínimo y máximo
#' de la escala de colores.
#' @param col Vector de colores que define la paleta utilizada en la leyenda.
#' @param legend.zoom Número que controla el nivel de zoom aplicado a la leyenda.
#' @param legend.width Número que define la anchura relativa de la barra de la leyenda.
#' @param legend.mar Número que establece la separación entre la malla principal y la leyenda.
#' @param legend.lab Vector de caracteres con las etiquetas de los ticks. Si es `NULL`,
#' se generan automáticamente.
#' @param box Lógico. Si es `TRUE`, se dibuja un marco que delimita la barra de la leyenda.
#' @param lab.breaks Lógico o vector. Si es `TRUE`, las etiquetas de la escala se
#' generan automáticamente. Si es un vector, se utiliza como etiquetas personalizadas
#' para los ticks de la leyenda.
#' @param lab.ticksize Número que especifica la longitud de las marcas de los ticks.
#' @param lab.dist Número que determina la distancia de las etiquetas respecto a la barra.
#' @param ... Argumentos adicionales pasados a funciones de `rgl`.
#'
#' @returns Devuelve de forma invisible el identificador de la subescena creada para
#' la leyenda, permitiendo manipularla o eliminarla independientemente de la escena principal.
#'
#' @details
#' Esta función utiliza una subescena de `rgl` para representar una leyenda continua
#' sin interferir con la malla principal. Para optimizar el renderizado, se suspende
#' temporalmente la actualización gráfica mientras se genera la barra y luego se reactiva.
#'
#' La barra se compone de una secuencia de cubos (`rgl::cube3d()`) coloreados con la
#' paleta especificada y dispuestos a lo largo del eje Z.
#'
#' Se emplea una versión modificada de `rgl::axis3d()` (`axis3()`) que permite controlar
#' la distancia de las etiquetas y la longitud de las marcas mediante los parámetros
#' `lab.dist` y `lab.ticksize`.
#'
#' Algunas partes del comportamiento original de `rgl` relacionadas con la actualización
#' automática de la vista y la disposición de etiquetas se han eliminado, con el fin
#' de simplificar la representación y mantener una apariencia limpia y controlada
#' dentro del paquete `controlDim`.
#'
#' @seealso `sshade3d()`, `axis3()`
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
