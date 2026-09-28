#' Filter mesh components by minimum size
#'
#' Filters the connected components of a triangular mesh according to their number
#' of triangles and rebuilds the mesh using only the retained components.
#'
#' @param mesh `mesh3d` object containing a triangular mesh. It must include an `it`
#' matrix with three rows, where each column represents a triangle.
#' @param comps List of integer vectors containing the triangle indices of each connected
#' component, typically returned by [splitTrianglesInd()].
#' @param minSize Numeric value specifying the minimum number of triangles required
#' for a component to be retained. Default is `1000`. If `NULL`, all components are retained.
#' @param color Logical. If `TRUE`, an additional rendering mesh is created with a
#' distinct color assigned to each retained component. Default is `FALSE`. It is automatically
#' set to `TRUE` when `plot = TRUE`.
#' @param plot Logical. If `TRUE`, the retained components are displayed using [rgl::shade3d()].
#' Default is `FALSE`.
#' @param palette Function receiving the number of retained components and returning
#' the corresponding colors. Default is [grDevices::rainbow()].
#'
#' @returns
#' List containing:
#' \itemize{
#'   \item `mesh`: `mesh3d` object containing the retained triangles.
#'   \item `triIdx`: integer vector containing the triangle-column indices retained
#'   from the input `mesh$it`.
#'   \item `compId`: integer vector containing the original component index associated
#'   with each retained triangle.
#'   \item `render`: `NULL` unless `color = TRUE` or `plot = TRUE`; otherwise, a list
#'   containing the rendering mesh and its per-vertex color vector.
#' }
#'
#' @details
#' Components are retained when their number of triangles is greater than or equal
#' to `minSize`. If `minSize = NULL`, all components are retained. The original vertex
#' indices and the `mesh$vb` matrix are preserved in the filtered mesh.
#'
#' When coloring is requested, the vertices of each retained triangle are duplicated
#' so that each component can be displayed with an independent color. The resulting
#' mesh stored in `render$mesh` is intended only for visualization and does not preserve
#' the original vertex indexing.
#'
#' If `plot = TRUE`, component coloring is enabled automatically and the rendering
#' mesh is displayed using [rgl::shade3d()].
#'
#' @seealso [splitTrianglesInd()], [rgl::shade3d()]
#'
#' @examples
#' library(rgl)
#'
#' # Create a mesh with two disconnected components
#' vertices <- t(rbind(
#'   c(0, 0, 0),
#'   c(1, 0, 0),
#'   c(0, 1, 0),
#'   c(1, 1, 0),
#'   c(3, 0, 0),
#'   c(4, 0, 0),
#'   c(3, 1, 0)
#' ))
#'
#' triangles <- t(rbind(
#'   c(1, 2, 3),
#'   c(2, 4, 3),
#'   c(5, 6, 7)
#' ))
#'
#' mesh <- tmesh3d(
#'   vertices = vertices,
#'   indices = triangles
#' )
#'
#' # Identify connected components
#' components <- splitTrianglesInd(mesh)
#'
#' # Retain components with at least two triangles
#' result <- filterMeshComponents(mesh = mesh, comps = components, minSize = 2, color = TRUE)
#'
#' # Represent original and filtered meshes side by side
#' open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#' mfrow3d(1, 2)
#'
#' shade3d(mesh, color = "lightgray")
#' title3d("Original mesh", level = 10)
#'
#' next3d()
#' shade3d(result$render$mesh, color = result$render$col)
#' title3d("Filtered mesh", level = 10)
#'
#' @export
filterMeshComponents <- function(mesh,
                                 comps,
                                 minSize = 1000,
                                 color = FALSE,
                                 plot = FALSE,
                                 palette = grDevices::rainbow) {

  # Validate the triangular mesh
  if (!inherits(mesh, "mesh3d"))
    stop("Argument 'mesh' must be an object of class 'mesh3d'")

  if (is.null(mesh$it) || !is.matrix(mesh$it) || nrow(mesh$it) != 3)
    stop("Argument 'mesh' must contain a triangular 'it' matrix with three rows")

  # Validate the component list
  if (!is.list(comps))
    stop("Argument 'comps' must be a list of triangle-index vectors")

  if (length(comps) == 0)
    stop("Argument 'comps' contains no mesh components")

  if (!is.null(minSize)) {
    if (length(minSize) != 1 || !is.numeric(minSize) || is.na(minSize) ||
        minSize < 1) {
      stop("Argument 'minSize' must be NULL or a positive numeric value")
    }
  }

  if (!is.function(palette))
    stop("Argument 'palette' must be a function")

  # Validate triangle indices
  componentIndices <- unlist(comps, use.names = FALSE)

  if (length(componentIndices) == 0)
    stop("Argument 'comps' contains no triangle indices")

  if (anyNA(componentIndices) || any(componentIndices < 1) ||
      any(componentIndices > ncol(mesh$it)) ||
      any(componentIndices != as.integer(componentIndices))) {
    stop("All component indices must be valid triangle-column indices of 'mesh$it'")
  }

  # Plotting requires component colors
  color <- isTRUE(color) || isTRUE(plot)

  # Select components according to their number of triangles
  sizes <- lengths(comps)

  keep <- if (is.null(minSize)) {
    seq_along(comps)
  } else {
    which(sizes >= minSize)
  }

  if (length(keep) == 0) {
    stop("No component reaches 'minSize' = ", minSize, ".")
  }

  retainedComponents <- comps[keep]
  retainedSizes <- sizes[keep]

  triIdx <- unlist(retainedComponents, use.names = FALSE)

  # Rebuild the mesh with retained triangles
  filteredMesh <- mesh
  filteredMesh$it <- mesh$it[, triIdx, drop = FALSE]

  render <- NULL

  if (color) {
    componentColors <- palette(length(keep))

    triangleColors <- rep(componentColors, times = retainedSizes)

    # Duplicate vertices for unambiguous triangle coloring
    vbFlat <- filteredMesh$vb[ , as.vector(filteredMesh$it), drop = FALSE]

    itRender <- matrix(seq_len(ncol(vbFlat)), nrow = 3)

    vertexColors <- rep(triangleColors, each = 3)

    renderMesh <- filteredMesh
    renderMesh$vb <- vbFlat
    renderMesh$it <- itRender

    # Existing normals no longer correspond to the duplicated vertices
    renderMesh$normals <- NULL

    render <- list(
      mesh = renderMesh,
      col = vertexColors
    )
  }

  if (!requireNamespace("rgl", quietly = TRUE)) stop("package 'rgl' is required")

  # Plot retained components
  if (isTRUE(plot)) {
    rgl::shade3d(render$mesh, col = render$col, lit = FALSE)
  }

  list(
    mesh = filteredMesh,
    triIdx = triIdx,
    compId = rep(keep, times = retainedSizes),
    render = render
  )
}
