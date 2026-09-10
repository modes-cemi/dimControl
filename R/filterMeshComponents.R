#' Filter Mesh Components by Minimum Size
#'
#' Filters the connected components of a triangular mesh according to their number
#' of triangles and rebuilds the mesh using only the retained components.
#'
#' @param mesh A `mesh3d` object containing a triangular mesh. It must include the `it`
#' matrix, where each column represents a triangle.
#' @param comps A list of integer vectors containing triangle indices for each connected
#' component, typically returned by [splitTrianglesInd()].
#' @param minSize Minimum number of triangles required for a component to be retained.
#' Default is `1000`. If `NULL`, all components are retained.
#' @param color Logical. If `TRUE`, creates an additional rendering mesh with a distinct
#' color assigned to each retained component. Default is `FALSE`. This argument is
#' automatically set to `TRUE` when `plot = TRUE`.
#' @param plot Logical. If `TRUE`, plots the retained components using [rgl::shade3d()].
#' Default is `FALSE`.
#' @param palette A function receiving the number of retained components and returning
#' the corresponding colors. Default is [grDevices::rainbow()].
#'
#' @returns
#' A list containing:
#' \itemize{
#'   \item `mesh`: a `mesh3d` object containing the retained triangles.
#'   \item `triIdx`: triangle-column indices retained from the input `mesh$it`.
#'   \item `compId`: original component index associated with each retained triangle.
#'   \item `render`: `NULL` unless `color = TRUE` or `plot = TRUE`; otherwise, a list
#'   containing the rendering mesh and its per-vertex color vector.
#' }
#'
#' @details
#' Components are retained when their number of triangles is greater than or equal
#' to `minSize`. The original vertex indices and the `mesh$vb` matrix are preserved
#' in the filtered mesh.
#'
#' When coloring is requested, the vertices of each triangle are duplicated so that
#' every retained component can be displayed with an independent color. The resulting
#' mesh stored in `render$mesh` is intended only for visualization.
#'
#' @seealso [splitTrianglesInd()], [rgl::shade3d()]
#'
#' @examples
#' \dontrun{
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
#' mesh <- rgl::tmesh3d(
#'   vertices = vertices,
#'   indices = triangles
#' )
#'
#' # Identify connected components
#' components <- splitTrianglesInd(mesh)
#'
#' # Retain components with at least two triangles
#' result <- filterMeshComponents(
#'   mesh = mesh,
#'   comps = components,
#'   minSize = 2,
#'   color = TRUE
#' )
#'
#' # Display original and filtered meshes side by side
#' rgl::clear3d()
#' rgl::mfrow3d(1, 2)
#'
#' rgl::shade3d(mesh, color = "lightgray")
#' rgl::title3d("Original mesh", level = 10)
#'
#' rgl::next3d()
#' rgl::shade3d(result$render$mesh, color = result$render$col)
#' rgl::title3d("Filtered mesh", level = 4)
#' }
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
    if (length(minSize) != 1 ||
        !is.numeric(minSize) ||
        is.na(minSize) ||
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

  if (anyNA(componentIndices) ||
      any(componentIndices < 1) ||
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
    stop(
      "No component reaches 'minSize' = ",
      minSize,
      "."
    )
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
