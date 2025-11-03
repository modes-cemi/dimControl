#' Extrae el contorno de una malla 3D
#'
#' Construye una malla de segmentos de línea correspondientes a los bordes no compartidos
#' (es decir, los bordes frontera) de los triángulos o cuadriláteros que componen la
#' malla original.
#'
#' La función puede devolver los índices de los bordes frontera o, de forma alternativa,
#' generar un objeto de clase \code{mesh3d} que los contenga.
#'
#' @param mesh Objeto de clase \code{mesh3d} que representa la malla 3D.
#' @param malla Valor lógico que indica si se debe devolver un objeto \code{mesh3d}
#' con los segmentos frontera (\code{TRUE}) o solo los índices de los vértices frontera
#' (\code{FALSE}). Por defecto es \code{FALSE}.
#' @param simplify Valor lógico que indica si se debe simplificar la malla resultante
#' cuando \code{malla = TRUE}. Por defecto es \code{TRUE}.
#'
#' @returns
#' Si \code{malla = FALSE}, devuelve una matriz con los índices de los vértices que
#' forman los bordes frontera. Si \code{malla = TRUE}, devuelve un objeto de clase
#' \code{mesh3d} que contiene los segmentos frontera.
#'
#' @examples
#' # Obtener el borde de un cubo y representarlo
#' library(rgl)
#' library(data.table)
#'
#' # Crear un cubo y eliminar dos caras
#' x <- cube3d(col = "lightblue")
#' x$ib <- x$ib[, -(1:2)]
#'
#' # Calcular el borde
#' b <- getBoundarySegments3(x, malla = TRUE)
#'
#' # Representar la malla y su borde
#' open3d()
#' shade3d(x, alpha = 0.2)
#'
#' @importFrom data.table data.table
#' @importFrom rgl mesh3d
#'
#' @export
getBoundarySegments3 <- function(mesh, malla = FALSE, simplify = TRUE) {
  if (!inherits(mesh, "mesh3d"))
    stop(deparse(substitute(mesh)), " is not a mesh3d object.")
  edges <- NULL
  if (length(mesh$it))
    edges <- cbind(edges, mesh$it[1:2,],  mesh$it[2:3,], mesh$it[c(3,1),])
  if (length(mesh$ib))
    edges <- cbind(edges, mesh$ib[1:2,], mesh$ib[2:3,], mesh$ib[3:4,], mesh$ib[c(4,1),])
  if (!ncol(edges)) return(list(edges))

  # Ordenar los extremos de cada arista para volverlas no dirigidas
  minv <- pmin(edges[1,], edges[2,])
  maxv <- pmax(edges[1,], edges[2,])

  # data.table de extremos de cada arista
  dt_edges <- data.table(v1 = minv, v2 = maxv)

  # Contar frecuencia de cada arista
  counts <- dt_edges[, .N, by = .(v1, v2)]

  # Filtrar aristas que aparecen una sola vez
  boundary_edges <- counts[N == 1]

  # Seleccionar las que cumplen la condición
  keep <- paste(dt_edges$v1, dt_edges$v2) %in% paste(boundary_edges$v1, boundary_edges$v2)

  # Aristas de borde
  boundary <- edges[, keep, drop = FALSE]

  # Si malla = TRUE, crear mesh3d con esos segmentos
  if (malla) {
    result <- mesh3d(vertices = mesh$vb, segments = boundary)
    if (simplify)
      result <- cleanMesh3d_rgl(result)
    return(result)
  }

  # Si no, devolver los índices de los segmentos frontera
  return(boundary)
}
