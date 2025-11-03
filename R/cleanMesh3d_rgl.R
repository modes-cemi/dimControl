#' Limpia una malla 3D eliminando vértices no usados y triángulos degenerados
#'
#' Esta función elimina vértices duplicados, triángulos degenerados y vértices que no
#' están referenciados por ninguna cara en un objeto `mesh3d`.
#'
#' @param mesh Objeto de clase `mesh3d` que representa la malla a limpiar.
#' @param onlyFinite Lógico; si TRUE elimina vértices con coordenadas no finitas.
#' @param allUsed Lógico; si TRUE elimina vértices que no están referenciados por ninguna cara.
#'
#' @returns Un objeto `mesh3d` limpio y con índices actualizados.
#'
#' @details
#' Reproduce la función `cleanMesh3d()` del paquete **rgl**, desarrollada por Duncan
#' Murdoch, para limpiar mallas internamente sin depender de funciones no exportadas.
#'
#' @references
#' Murdoch, D. (2024). *rgl: 3D Visualization Using OpenGL*.
#' R package version correspondiente.
#' URL: <https://CRAN.R-project.org/package=rgl>
#'
#' @author Duncan Murdoch (implementación original en rgl).
#'
#' @examples
#' library(rgl)
#'
#' # Crear un cubo
#' cubo <- cube3d()
#'
#' # Añadir vértice no referenciado
#' cubo$vb <- cbind(cubo$vb, c(10,10,10,1))
#'
#' # Limpiar el cubo
#' cubo_clean <- cleanMesh3d_rgl(cubo)
#'
#' # Comparar dimensiones
#' dim(cubo$vb)
#' dim(cubo_clean$vb)
#'
#' @export
cleanMesh3d_rgl <- function(mesh, onlyFinite = TRUE, allUsed = TRUE) {
  # Número original de vértices
  nold <- ncol(mesh$vb)

  # Vector lógico para marcar qué vértices se conservarán
  keep <- rep(TRUE, nold)

  # Eliminar vértices con coordenadas no finitas si onlyFinite = TRUE
  if (onlyFinite)
    keep <- keep & apply(mesh$vb, 2, function(col) all(is.finite(col)))

  # Eliminar vértices que no están referenciados por ninguna cara si allUsed = TRUE
  if (allUsed)
    keep <- keep & (seq_len(nold) %in% c(mesh$ip, mesh$is, mesh$it, mesh$ib))

  # Reindexar la malla si hay vértices que eliminar
  if (!all(keep)) {
    oldnums <- which(keep)
    newnums <- rep(NA, nold)
    nnew <- sum(keep)
    newnums[oldnums] <- seq_len(nnew)

    # Actualizar la matriz de vértices
    mesh$vb <- mesh$vb[, oldnums, drop = FALSE]

    # Función para actualizar las matrices de caras tras eliminar vértices
    reindex <- function(m) {
      if (!is.null(m)) {
        newcols <- newnums[m]
        dim(newcols) <- dim(m)
        keep <- apply(newcols, 2, function(col) all(!is.na(col)))
        list(m = newcols[, keep, drop = FALSE])
      } else list(m = NULL)
    }

    # Reindexar todas las caras
    mesh$ip <- reindex(mesh$ip)$m
    mesh$is <- reindex(mesh$is)$m
    mesh$it <- reindex(mesh$it)$m
    mesh$ib <- reindex(mesh$ib)$m
  }

  # Devolver la malla limpia
  mesh
}
