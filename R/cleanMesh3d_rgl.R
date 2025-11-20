#' Limpieza de una malla 3D
#'
#' Elimina vértices no usados o no finitos y actualiza los índices de las caras en
#' un objeto de clase `mesh3d`.
#'
#' Esta función es una versión simplificada de `rgl::cleanMesh3d()`, adaptada para
#' tareas básicas de depuración de mallas.
#'
#' @param mesh Objeto `mesh3d` que representa la malla a limpiar.
#' @param onlyFinite Lógico. Si es `TRUE` (por defecto), elimina vértices con coordenadas
#' no finitas.
#' @param allUsed Lógico. Si es `TRUE` (por defecto), elimina vértices que no están
#' referenciados por ninguna cara.
#'
#' @returns Objeto `mesh3d` limpio, con los vértices e índices de las caras actualizados.
#'
#' @details
#' Esta función está basada en `rgl::cleanMesh3d()` (D. Murdoch, 2024), pero se han
#' eliminado elementos no necesarios para las operaciones de limpieza estructural,
#' como la gestión de etiquetas (`tags`), texturas, normales o colores de vértices,
#' así como el parámetro `rejoin`.
#'
#' El objetivo es conservar únicamente la funcionalidad esencial:
#' \itemize{
#'   \item Eliminación de vértices con valores no finitos (`NA`, `NaN`, `Inf`) cuando `onlyFinite = TRUE`.
#'   \item Eliminación de vértices no usados en ninguna cara cuando `allUsed = TRUE`.
#'   \item Reindexación automática de las matrices de caras (`ip`, `is`, `it`, `ib`) tras la limpieza.
#' }
#'
#' @references
#' Murdoch, D. (2024). *rgl: 3D Visualization Using OpenGL*.
#' R package version correspondiente.
#' URL: <https://CRAN.R-project.org/package=rgl>
#'
#' @author Duncan Murdoch
#'
#' @examples
#' \dontrun{
#' # Crear un cubo
#' cubo <- rgl::cube3d()
#'
#' # Añadir vértice no referenciado
#' cubo$vb <- cbind(cubo$vb, c(10,10,10,1))
#'
#' # Limpiar el cubo
#' cubo_clean <- cleanMesh3d_rgl(cubo)
#'
#' # Comparar número de vértices
#' dim(cubo$vb)
#' dim(cubo_clean$vb)
#' }
#'
cleanMesh3d_rgl <- function(mesh, onlyFinite = TRUE, allUsed = TRUE) {
  # Número original de vértices
  nold <- ncol(mesh$vb)

  # Vector lógico para marcar qué vértices se conservarán
  keep <- rep(TRUE, nold)

  # Eliminar vértices con coordenadas no finitas si onlyFinite = TRUE
  if (onlyFinite)
    keep <- keep & apply(mesh$vb, 2, function(col) all(is.finite(col)))

  # Eliminar vértices no referenciados por ninguna cara si allUsed = TRUE
  if (allUsed)
    keep <- keep & (seq_len(nold) %in% c(mesh$ip, mesh$is, mesh$it, mesh$ib))

  # Reindexar si se eliminan vértices
  if (!all(keep)) {
    oldnums <- which(keep)
    newnums <- rep(NA, nold)
    nnew <- sum(keep)
    newnums[oldnums] <- seq_len(nnew)

    # Actualizar matriz de vértices
    mesh$vb <- mesh$vb[, oldnums, drop = FALSE]

    # Actualizar las matrices de caras tras eliminar vértices
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
