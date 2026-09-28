#' Clean a 3D mesh
#'
#' Removes non-finite or unused vertices from a `mesh3d` object and updates the corresponding
#' mesh indices.
#'
#' @param mesh `mesh3d` object representing the mesh to be cleaned.
#' @param onlyFinite Logical. If `TRUE`, vertices with non-finite coordinates are
#' removed. Default is `TRUE`.
#' @param allUsed Logical. If `TRUE`, vertices that are not referenced by any mesh
#' element are removed. Default is `TRUE`.
#'
#' @returns
#' `mesh3d` object with the retained vertices and updated mesh indices.
#'
#' @details
#' This function is a simplified adaptation of the internal `cleanMesh3d()` function
#' from the `rgl` package. It retains only the functionality required in `dimControl`
#' to remove non-finite or unused vertices and reindex the `ip`, `is`, `it`, and `ib`
#' components.
#'
#' If `onlyFinite = TRUE`, vertices containing non-finite coordinates are removed.
#' If `allUsed = TRUE`, vertices that are not referenced by any of the `ip`, `is`,
#' `it`, or `ib` components are removed.
#'
#' Mesh elements that reference removed vertices are discarded, and the remaining vertex
#' indices are updated to match the new vertex matrix.
#'
#' Unlike the original implementation, this version does not handle additional mesh
#' attributes such as tags, texture coordinates, vertex attributes, or triangle rejoining.
#'
#' @references
#' Murdoch, D., et al. \emph{rgl: 3D Visualization Using OpenGL}. R package.
#' \url{https://CRAN.R-project.org/package=rgl}
#'
#' @examples
#' library(rgl)
#'
#' # Create a cube mesh
#' cube <- cube3d()
#'
#' # Add an unreferenced vertex
#' cube$vb <- cbind(cube$vb, c(10,10,10,1))
#'
#' # Clean the mesh
#' cubeClean <- cleanMesh3d(cube)
#'
#' # Compare the number of vertices
#' ncol(cube$vb)
#' ncol(cubeClean$vb)
#'
#' @export
cleanMesh3d <- function(mesh, onlyFinite = TRUE, allUsed = TRUE) {

  # Original number of vertices
  nOld <- ncol(mesh$vb)

  # Logical vector indicating vertices to retain
  keep <- rep(TRUE, nOld)

  # Remove vertices with non-finite coordinates
  if (onlyFinite)
    keep <- keep & apply(mesh$vb, 2, function(col) all(is.finite(col)))

  # Remove vertices not referenced by any mesh element
  if (allUsed)
    keep <- keep & (seq_len(nOld) %in% c(mesh$ip, mesh$is, mesh$it, mesh$ib))

  # Reindex mesh elements if vertices are removed
  if (!all(keep)) {
    oldNums <- which(keep)
    newNums <- rep(NA, nOld)
    nNew <- sum(keep)
    newNums[oldNums] <- seq_len(nNew)

    # Update vertex matrix
    mesh$vb <- mesh$vb[, oldNums, drop = FALSE]

    # Reindex mesh component
    reindex <- function(x) {

      if (is.null(x)) {
        return(NULL)
      }

      newX <- newNums[x]
      dim(newX) <- dim(x)

      keepCols <- apply(
        newX,
        2,
        function(col) all(!is.na(col))
      )

      newX[, keepCols, drop = FALSE]
    }

    # Update mesh indices
    mesh$ip <- reindex(mesh$ip)
    mesh$is <- reindex(mesh$is)
    mesh$it <- reindex(mesh$it)
    mesh$ib <- reindex(mesh$ib)
  }

  mesh
}
