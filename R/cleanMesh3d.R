#' Clean a 3D Mesh
#'
#' Removes unused or non-finite vertices and updates the face indices in a `mesh3d` object.
#'
#' This function is a simplified version of `rgl::cleanMesh3d()`, adapted for basic
#' mesh debugging and cleaning tasks.
#'
#' @param mesh A `mesh3d` object representing the mesh to be cleaned.
#' @param onlyFinite Logical. If `TRUE` (default), removes vertices with non-finite coordinates.
#' @param allUsed Logical. If `TRUE` (default), removes vertices that are not referenced by any face.
#'
#' @returns A cleaned `mesh3d` object, with updated vertices and face indices.
#'
#' @details
#' This function is based on `rgl::cleanMesh3d()` (D. Murdoch, 2024), but removes
#' elements unnecessary for structural cleaning, such as tags, textures, normals,
#' vertex colors, and the `rejoin` parameter.
#'
#' The goal is to retain only essential functionality:
#' \itemize{
#'   \item Remove vertices with non-finite values (`NA`, `NaN`, `Inf`) when `onlyFinite = TRUE`.
#'   \item Remove vertices not used in any face when `allUsed = TRUE`.
#'   \item Automatically reindex face matrices (`ip`, `is`, `it`, `ib`) after cleaning.
#' }
#'
#' @references
#' Murdoch, D. (2024). *rgl: 3D Visualization Using OpenGL*.
#' R package version as appropriate.
#' URL: <https://CRAN.R-project.org/package=rgl>
#'
#' @author Duncan Murdoch
#'
#' @examples
#' \dontrun{
#' # Create a cube mesh
#' cube <- rgl::cube3d()
#'
#' # Add an unreferenced vertex
#' cube$vb <- cbind(cube$vb, c(10,10,10,1))
#'
#' # Clean the cube
#' cube_clean <- cleanMesh3d(cube)
#'
#' # Compare number of vertices
#' dim(cube$vb)
#' dim(cube_clean$vb)
#' }
#'
#' @keywords internal
#' @noRd
#'
cleanMesh3d <- function(mesh, onlyFinite = TRUE, allUsed = TRUE) {
  # Original number of vertices
  nold <- ncol(mesh$vb)

  # Logical vector to mark vertices to keep
  keep <- rep(TRUE, nold)

  # Remove non-finite vertices if onlyFinite = TRUE
  if (onlyFinite)
    keep <- keep & apply(mesh$vb, 2, function(col) all(is.finite(col)))

  # Remove unused vertices if allUsed = TRUE
  if (allUsed)
    keep <- keep & (seq_len(nold) %in% c(mesh$ip, mesh$is, mesh$it, mesh$ib))

  # Reindex if vertices are removed
  if (!all(keep)) {
    oldnums <- which(keep)
    newnums <- rep(NA, nold)
    nnew <- sum(keep)
    newnums[oldnums] <- seq_len(nnew)

    # Update vertex matrix
    mesh$vb <- mesh$vb[, oldnums, drop = FALSE]

    # Reindex face matrices after vertex removal
    reindex <- function(m) {
      if (!is.null(m)) {
        newcols <- newnums[m]
        dim(newcols) <- dim(m)
        keep <- apply(newcols, 2, function(col) all(!is.na(col)))
        list(m = newcols[, keep, drop = FALSE])
      } else list(m = NULL)
    }

    # Reindex all faces
    mesh$ip <- reindex(mesh$ip)$m
    mesh$is <- reindex(mesh$is)$m
    mesh$it <- reindex(mesh$it)$m
    mesh$ib <- reindex(mesh$ib)$m
  }

  # Return cleaned mesh
  mesh
}
