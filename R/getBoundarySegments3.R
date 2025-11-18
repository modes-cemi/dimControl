#' Extrae el borde de una malla tridimensional
#'
#' Identifica los bordes no compartidos de una malla 3D, es decir, aquellos que pertenecen
#' a una sola cara. Estos bordes pueden devolverse como índices de los vértices frontera
#' o como una malla `mesh3d` formada por los segmentos correspondientes.
#'
#' Esta función es una adaptación de `getBoundary3d()` del paquete `rgl`. A diferencia
#' de la versión original, que identifica los bordes frontera mediante la detección
#' de duplicados en las aristas, esta implementación utiliza una tabla de frecuencias
#' (`data.table`) para contabilizar cuántas veces aparece cada borde en las caras de
#' la malla. Los bordes que aparecen una sola vez se consideran frontera. Además, se
#' añade la opción de devolver los índices de los vértices frontera o una malla `mesh3d`
#' con los segmentos correspondientes, con la posibilidad de aplicar una simplificación
#' adicional.
#'
#' @param mesh Objeto de clase `mesh3d` que representa la malla 3D.
#' @param malla Lógico. Si es `TRUE`, devuelve un objeto `mesh3d` que contiene los
#' segmentos frontera; si es `FALSE`, devuelve únicamente los índices de los vértices
#' que forman los bordes frontera. Por defecto es `FALSE`.
#' @param simplify Lógico. Si es `TRUE` y `malla = TRUE`, simplifica la malla resultante
#' mediante `cleanMesh3d_rgl()`. Por defecto es `TRUE`.
#'
#' @returns Si `malla = FALSE`, devuelve una matriz con los índices de los vértices
#' que forman los bordes frontera. Si `malla = TRUE`, devuelve una malla de tipo `mesh3d`
#' formada por dichos bordes.
#'
#' @seealso `rgl::getBoundary3d()`, `cleanMesh3d_rgl()`
#'
#' @examples
#' \dontrun{
#' # Obtener el borde de un cubo y representarlo
#' require(data.table)
#'
#' # Crear un cubo y eliminar dos caras
#' x <- rgl::cube3d(col = "lightblue")
#' x$ib <- x$ib[, -(1:2)]
#'
#' # Generar el borde
#' b <- getBoundarySegments3(x, malla = TRUE)
#'
#' # Representar la malla y su borde
#' rgl::open3d()
#' rgl::shade3d(x, alpha = 0.2)
#' rgl::shade3d(b, col = "red", lwd = 2)
#' }
#'
#' @importFrom data.table data.table
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
    result <- rgl::mesh3d(vertices = mesh$vb, segments = boundary)
    if (simplify)
      result <- cleanMesh3d_rgl(result)
    return(result)
  }

  # Si no, devolver los índices de los segmentos frontera
  return(boundary)
}
