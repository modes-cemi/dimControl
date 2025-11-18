#' Representación 3D con colores categóricos
#'
#' Aplica una escala de color categórica a una malla tridimensional según un factor
#' y, opcionalmente, muestra una leyenda asociada a las categorías. Es una extensión
#' de `rgl::shade3d()` que permite representar grupos o clases discretas sobre una
#' superficie 3D.
#'
#' @param x Objeto de tipo `mesh3d`. Malla tridimensional que se desea colorear.
#' @param f Factor o vector que indica la categoría asignada a cada cara o vértice
#'   de la malla, dependiendo del modo definido en `meshColor`.
#' @param meshColor Cadena de texto. Especifica cómo se aplica el color:
#'   \itemize{
#'     \item `"faces"`: el color se asigna por cara (valor por defecto).
#'     \item `"vertices"`: el color se asigna por vértice.
#'     }
#' @param legend.lab Vector de caracteres. Etiquetas mostradas en la leyenda.
#'   Por defecto, `levels(f)`.
#' @param col Vector de colores. Paleta utilizada para colorear las categorías. Si se omite,
#'   se genera automáticamente mediante `col.pal`.
#' @param col.pal Función generadora de paletas de colores categóricos. Por defecto, `cat.colors`.
#' @param legend.zoom Número. Nivel de zoom aplicado a la leyenda.
#' @param legend.width Número. Anchura relativa de la leyenda respecto a la malla.
#' @param legend.mar Número. Margen horizontal entre la malla y la leyenda.
#' @param lab.dist Número. Distancia de las etiquetas respecto a la barra de la leyenda.
#' @param lab.rev Lógico. Si es `TRUE`, invierte el orden de las etiquetas en la leyenda.
#' @param add Lógico. Si es `TRUE`, añade la malla a una escena 3D ya existente sin
#'   generar una nueva leyenda.
#' @param ... rgumentos adicionales pasados a `rgl::shade3d()`.
#'
#' @returns
#' Devuelve (invisiblemente) el identificador del objeto dibujado en la escena de `rgl`.
#'
#' @seealso
#' `fplot3d()` para la generación de leyendas categóricas.
#'
#' @details
#' Esta función facilita la representación de categorías o regiones diferenciadas sobre
#' mallas 3D, coloreando cada zona según la categoría correspondiente. Cuando `add = FALSE`,
#' se genera además una leyenda lateral mediante `fplot3d()` que asocia cada color
#' con su categoría.
#'
#' @examples
#' # Generar una superficie 3D (dataset `volcano`)
#' z <- 2 * volcano                 # Aumentar el relieve
#' x <- 10 * (seq_len(nrow(z)) - 1) # Espaciado de 10 m (S a N)
#' y <- 10 * (seq_len(ncol(z)) - 1) # Espaciado de 10 m (E a W)
#' rgl::surface3d(x, y, z, back = "lines")
#' mesh <- rgl::as.mesh3d()
#' mesh$meshColor <- "faces"
#'
#' # Valor por triangulo (media de los vértices)
#' vb2tri <- function(x, s) {
#' if (!length(x$it)) stop("Argument 'x' must be a triangular mesh")
#' return(apply(x$it, 2, function(tri) mean(s[tri])))
#' }
#' z_tri <- vb2tri(mesh, mesh$vb[3, ])
#'
#' # Factor con 5 niveles de altura
#' fz_tri <- cut(z_tri, 5)
#'
#' # Representar la superficie coloreada por niveles con leyenda
#' rgl::open3d()
#' fshade3d(mesh, fz_tri, legend.lab = seq_along(levels(fz_tri)))
#'
#' @export
fshade3d <- function(x, f, meshColor = c("faces", "vertices"), legend.lab = levels(f),
                     col = col.pal(length(legend.lab)), col.pal = cat.colors,  # col.pal = terrain.colors
                     legend.zoom = 1, legend.width = 0.1, legend.mar = 0.15,
                     lab.dist = 3, lab.rev = FALSE, add = FALSE, ...) {
  meshColor <- match.arg(meshColor)
  if (!add) fplot3d(labels = legend.lab, col = col, legend.zoom = legend.zoom,
                    legend.width = legend.width, legend.mar = legend.mar,
                    lab.dist = lab.dist, lab.rev = lab.rev)
  rgl::shade3d(x, override = TRUE, meshColor = meshColor, col = col[f], ...)
}

# Función interna para colores categóricos
cat.colors <- function(n) {
  rep(c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c',
        '#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928'),
      length.out = n)
}


