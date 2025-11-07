#' Representa una superficie 3D coloreada con leyenda
#'
#' Combina la representación de una malla tridimensional con el color asociado a los
#' valores de una variable escalar y añade una leyenda lateral que indica el rango de
#' valores representados. Utiliza `splot3d()` para generar la leyenda y los ejes, y
#' `npsp::scolor()` para asignar colores a los triángulos o vértices de la malla.
#'
#' @param x Objeto de clase `mesh3d` que define la malla a representar.
#' @param s Vector numérico con los valores escalares asociados a los vértices o caras de la malla.
#' @param meshColor Tipo de coloración de la malla. Puede ser:
#'   \itemize{
#'     \item `"faces"`: colorea cada triángulo con el valor medio de sus vértices.
#'     \item `"facesvertices"`: interpola colores en las caras según los vértices.
#'     \item `"vertices"`: colorea directamente los vértices.
#'   }
#' @param slim Rango de valores de `s` utilizado para escalar los colores. Por defecto,
#' `range(s, finite = TRUE)`.
#' @param col Paleta de colores utilizada. Por defecto, `npsp::jet.colors(128)`.
#' @param legend.zoom Factor de escala del tamaño de la leyenda. Por defecto, `0.4`.
#' @param legend.width Ancho relativo de la leyenda. Por defecto, `0.1`.
#' @param legend.mar Margen entre la leyenda y la superficie. Por defecto, `0.15`.
#' @param legend.lab Texto de la etiqueta de la leyenda. Si es `NULL`, no se muestra.
#' @param box Lógico que indica si se dibuja la caja de los ejes. Por defecto, `TRUE`.
#' @param lab.breaks Vector con las posiciones de las marcas de graduación de la leyenda.
#' @param lab.ticksize Tamaño de las marcas de la leyenda. Por defecto, `0.5`.
#' @param lab.dist Distancia entre las etiquetas de la leyenda y las marcas. Por defecto, `3`.
#' @param add Si es `TRUE`, añade la superficie al gráfico 3D actual sin crear una nueva leyenda.
#' @param ... Argumentos adicionales pasados a `rgl::shade3d()`.
#'
#' @details
#' La función colorea la malla 3D de acuerdo con los valores de `s` utilizando la paleta
#' especificada en `col`. El color puede asignarse por vértices o por caras, en función
#' de `meshColor`. Posteriormente, se genera la representación tridimensional mediante
#' `rgl::shade3d()` y se añade una leyenda lateral mediante `splot3d()`.
#'
#' @returns
#' No devuelve ningún valor. Su efecto es generar la representación tridimensional
#' coloreada de la malla junto con su leyenda.
#'
#' @seealso
#' `axis3()`, `splot3d()` para funciones internas de representación;
#' `npsp::scolor()`, `npsp::jet.colors()` para el mapeo de color.
#'
#' @importFrom npsp scolor jet.colors
#'
#' @examples
#' require(rgl)
#'
#' # Generar una superficie 3D (dataset `volcano`)
#' z <- 2 * volcano                 # Aumentar el relieve
#' x <- 10 * (seq_len(nrow(z)) - 1) # Espaciado de 10 m (S a N)
#' y <- 10 * (seq_len(ncol(z)) - 1) # Espaciado de 10 m (E a W)
#' surface3d(x, y, z, back = "lines")
#' mesh <- as.mesh3d()
#' mesh$meshColor <- "faces"
#'
#' # Representar la superficie coloreada por altura con leyenda
#' open3d()
#' sshade3d(mesh, mesh$vb[3, ], meshColor = "facesvertices", lit = FALSE)
#'
#' @export
sshade3d <- function(x, s, meshColor = c("faces", "facesvertices", "vertices"),
                     slim = range(s, finite = TRUE),  col = jet.colors(128),
                     legend.zoom = 0.4, legend.width = 0.1, legend.mar = 0.15,
                     legend.lab = NULL, box = TRUE, lab.breaks = NULL,
                     lab.ticksize = 0.5, lab.dist = 3, add = FALSE, ...) {
  meshColor <- match.arg(meshColor)
  if (meshColor == "facesvertices") {
    meshColor <- "faces"
    s <- vb2tri(x, s) # Valor por triangulo (media vértices)
  }
  # Leyenda
  splot3d(slim = slim, col = col, legend.zoom = legend.zoom, legend.width = legend.width,
          legend.mar = legend.mar, legend.lab = legend.lab, box = box,
          lab.breaks = lab.breaks, lab.ticksize = lab.ticksize, lab.dist = lab.dist)

  # shade3d
  scol <- scolor(s, col = col, slim = slim)
  rgl::shade3d(x, override = TRUE, meshColor = meshColor, col = scol, ...)
}

# Función interna: Valor por triangulo (media vértices)
vb2tri <- function(x, s) {
  if (!length(x$it)) stop("Argument 'x' must be a triangular mesh")
  return(apply(x$it, 2, function(tri) mean(s[tri])))
}
