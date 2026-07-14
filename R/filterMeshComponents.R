#' Filter Mesh Components by Minimum Size
#'
#' Filters the connected components of a triangular mesh according to their
#' number of triangles and rebuilds the mesh using only the retained
#' components. Optionally, the surviving components can be assigned distinct
#' colors and plotted directly.
#'
#' The component list is normally obtained with `splitTrianglesInd()`. Each
#' element of the list must contain triangle-column indices referring to the
#' same `mesh$it` matrix supplied to this function.
#'
#' @param mesh A `mesh3d` object containing a triangular mesh. It must include
#' the `it` matrix, where each column represents a triangle.
#' @param comps A list of integer vectors containing triangle indices for each
#' connected component, typically returned by `splitTrianglesInd(mesh)`.
#' The components must have been calculated from the same version and triangle
#' order of `mesh`.
#' @param min_size Minimum number of triangles required for a component to be
#' retained. Default is `1000`. If `NULL`, all components are retained.
#' @param color Logical. If `TRUE`, creates an additional rendering mesh with a
#' distinct color assigned to each retained component. Default is `FALSE`.
#' This argument is automatically set to `TRUE` when `plot = TRUE`.
#' @param plot Logical. If `TRUE`, plots the retained components using
#' `rgl::shade3d()`. The current `rgl` scene is not cleared. Default is
#' `FALSE`.
#' @param palette A function that receives the number of retained components
#' and returns the corresponding colors. Default is `grDevices::rainbow`.
#'
#' @returns A list containing:
#' \itemize{
#'   \item `mesh`: a `mesh3d` object containing only the retained triangles.
#'   \item `tri_idx`: triangle-column indices retained from the input
#'   `mesh$it`.
#'   \item `comp_id`: original component index associated with each retained
#'   triangle.
#'   \item `render`: `NULL` unless `color = TRUE` or `plot = TRUE`; otherwise,
#'   a list containing an exploded rendering mesh and its per-vertex color
#'   vector.
#' }
#'
#' @details
#' Filtering changes the column positions of the triangles in the returned
#' `mesh$it`, but it does not modify the vertex indices stored inside the
#' triangles or the layout of `mesh$vb`. The element `tri_idx` preserves the
#' correspondence with the triangle columns of the input mesh.
#'
#' When coloring is requested, vertices are duplicated so that every triangle
#' has its own three vertices. This guarantees an unambiguous solid color for
#' each triangle using ordinary per-vertex coloring. The exploded mesh stored
#' in `render$mesh` is intended only for visualization and should not replace
#' the filtered mesh in subsequent geometric analyses.
#'
#' Creating the rendering mesh increases memory usage because adjacent
#' triangles no longer share vertices. For large meshes, use `color = TRUE` or
#' `plot = TRUE` only when visualization is required.
#'
#' @seealso `splitTrianglesInd()`, `rgl::shade3d()`
#'
#' @examples
#' \dontrun{
#' # Alternative 1: filter and rebuild without coloring
#' components <- splitTrianglesInd(base_mesh)
#'
#' result <- filterMeshComponents(
#'   mesh = base_mesh,
#'   comps = components,
#'   min_size = 1000
#' )
#'
#' base_mesh_clean <- result$mesh
#'
#' # Alternative 2: filter, color and plot
#' rgl::clear3d()
#'
#' result_plot <- filterMeshComponents(
#'   mesh = base_mesh,
#'   comps = components,
#'   min_size = 1000,
#'   plot = TRUE
#' )
#'
#' base_mesh_clean_plot <- result_plot$mesh
#' }
#'
#' @export
filterMeshComponents <- function(mesh,
                                 comps,
                                 min_size = 1000,
                                 color = FALSE,
                                 plot = FALSE,
                                 palette = grDevices::rainbow) {

  # Validate the triangular mesh
  if (!inherits(mesh, "mesh3d"))
    stop("Argument 'mesh' must be an object of class 'mesh3d'.")

  if (is.null(mesh$it) || !is.matrix(mesh$it) || nrow(mesh$it) != 3)
    stop("Argument 'mesh' must contain a triangular 'it' matrix with three rows.")

  # Validate the component list
  if (!is.list(comps))
    stop("Argument 'comps' must be a list of triangle-index vectors.")

  if (length(comps) == 0)
    stop("Argument 'comps' contains no mesh components.")

  if (!is.null(min_size)) {
    if (length(min_size) != 1 ||
        !is.numeric(min_size) ||
        is.na(min_size) ||
        min_size < 1) {
      stop("Argument 'min_size' must be NULL or a positive numeric value.")
    }
  }

  if (!is.function(palette))
    stop("Argument 'palette' must be a function.")

  # Validate triangle indices
  component_indices <- unlist(comps, use.names = FALSE)

  if (length(component_indices) == 0)
    stop("Argument 'comps' contains no triangle indices.")

  if (anyNA(component_indices) ||
      any(component_indices < 1) ||
      any(component_indices > ncol(mesh$it)) ||
      any(component_indices != as.integer(component_indices))) {
    stop("All component indices must be valid triangle-column indices of 'mesh$it'.")
  }

  color <- isTRUE(color) || isTRUE(plot)

  # Select components according to their number of triangles
  sizes <- lengths(comps)

  keep <- if (is.null(min_size)) {
    seq_along(comps)
  } else {
    which(sizes >= min_size)
  }

  if (length(keep) == 0) {
    stop(
      "No component reaches 'min_size' = ",
      min_size,
      "."
    )
  }

  retained_components <- comps[keep]
  retained_sizes <- sizes[keep]

  tri_idx <- unlist(
    retained_components,
    use.names = FALSE
  )

  # Rebuild the processing mesh with retained triangles
  filtered_mesh <- mesh
  filtered_mesh$it <- mesh$it[, tri_idx, drop = FALSE]

  render <- NULL

  if (color) {
    component_colors <- palette(length(keep))

    triangle_colors <- rep(
      component_colors,
      times = retained_sizes
    )

    # Duplicate the three vertices of each triangle for unambiguous coloring
    vb_flat <- filtered_mesh$vb[
      ,
      as.vector(filtered_mesh$it),
      drop = FALSE
    ]

    it_render <- matrix(
      seq_len(ncol(vb_flat)),
      nrow = 3
    )

    vertex_colors <- rep(
      triangle_colors,
      each = 3
    )

    render_mesh <- filtered_mesh
    render_mesh$vb <- vb_flat
    render_mesh$it <- it_render

    # Existing normals no longer correspond to the duplicated vertices
    render_mesh$normals <- NULL

    render <- list(
      mesh = render_mesh,
      col = vertex_colors
    )
  }

  if (isTRUE(plot)) {
    rgl::shade3d(
      render$mesh,
      col = render$col,
      lit = FALSE
    )
  }

  list(
    mesh = filtered_mesh,
    tri_idx = tri_idx,
    comp_id = rep(keep, times = retained_sizes),
    render = render
  )
}
