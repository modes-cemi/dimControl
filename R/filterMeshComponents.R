#' Filter connected triangle components by minimum size
#'
#' Selects connected components according to their number of triangles, returning
#' only the indices of the retained triangles.
#'
#' @param comps List of integer vectors containing triangle indices, typically
#' returned by [splitTrianglesInd()].
#' @param minSize Minimum number of triangles required to retain a component. If
#' `NULL`, all components are retained. Default is `1000`.
#'
#' @returns
#' Integer vector containing the indices of the retained triangles.
#'
#' @examples
#' # Three connected components containing 5, 2 and 4 triangles
#' components <- list(1:5, 6:7, 8:11)
#'
#' # Retain components with at least 4 triangles
#' filtered <- filterMeshComponents(comps = components, minSize = 4)
#'
#' # Show retained triangle indices
#' filtered
#'
#' @export
filterMeshComponents <- function(comps, minSize = 1000) {

  # Validate the component list
  if (!is.list(comps))
    stop("Argument 'comps' must be a list")

  if (length(comps) == 0)
    return(integer(0))

  # Validate minimum component size
  if (!is.null(minSize)) {
    if (!is.numeric(minSize) || length(minSize) != 1 ||
        is.na(minSize) || !is.finite(minSize) || minSize < 1) {
      stop("Argument 'minSize' must be NULL or a positive number")
    }
  }

  # Identify components meeting the minimum size
  keep <- if (is.null(minSize)) {
    seq_along(comps)
  } else {
    which(lengths(comps) >= minSize)
  }

  # Return only the retained triangle indices
  unlist(comps[keep], use.names = FALSE)
}
