#' Generate a Triangular Mesh Using Binning and Marching Cubes
#'
#' Reconstructs a triangular surface from a 3D point cloud and returns it as a
#' `mesh3d` object. The function performs linear binning using `npsp::binning()`,
#' adds external zero-valued layers in the Z direction, removes low-density nodes,
#' truncates high-density nodes and extracts the isosurface using
#' `misc3d::contour3d()`.
#'
#' If a CAD mesh is provided, disconnected mesh components are sorted by size and
#' merged until the reconstructed mesh reaches the specified proportion of the CAD
#' model dimensions.
#'
#' @param panel A numeric matrix or data frame with three columns containing the X, Y
#' and Z coordinates of the point cloud.
#' @param resol_nbin A numeric vector of length three defining the approximate binning
#' resolution in the X, Y and Z directions. Default is `c(4, 4, 2)`.
#' @param mesh_cad Optional. A `mesh3d` object used as a reference to select or merge
#' connected mesh components. Default is `NULL`.
#' @param zero_layers_z Integer. Number of zero-valued layers added above the binning
#' grid in the Z direction. Default is `1`.
#' @param k_factor Numeric. Factor used to compute the tolerance for removing
#' low-density nodes. If `NULL`, it is automatically assigned according to
#' `resol_nbin`. Default is `NULL`.
#' @param trunc_factor Numeric. Factor used to truncate high-density node weights.
#' Default is `3.5`.
#' @param level_factor Numeric. Factor used to define the isosurface extraction level
#' from the truncated weights. Default is `0.99`.
#' @param cad_coverage_tol Numeric. Minimum proportion of the CAD model dimensions
#' that must be covered by the reconstructed mesh when `mesh_cad` is provided.
#' Default is `0.99`.
#'
#' @returns A list containing the reconstructed `mesh3d` object, the processed binning
#' object, the triangular surfaces returned by `misc3d::contour3d()` and the parameters
#' used during the reconstruction process.
#'
#' @seealso `npsp::binning()`, `npsp::coordvalues()`, `misc3d::contour3d()`,
#' `rgl::tmesh3d()`
#'
#' @examples
#' \dontrun{
#' result <- binningMarchingCubes(
#'   panel = panel,
#'   resol_nbin = c(4, 4, 2),
#'   mesh_cad = mesh_cad,
#'   zero_layers_z = 1
#' )
#'
#' mesh <- result$mesh
#'
#' rgl::open3d()
#' rgl::shade3d(mesh, col = "lightblue")
#' rgl::axes3d()
#' }
#'
#' @importFrom matrixStats colRanges
#' @importFrom npsp binning coordvalues
#' @importFrom misc3d contour3d
#' @importFrom rgl tmesh3d
#' @importFrom utils capture.output getFromNamespace
#'
#' @export
binningMarchingCubes <- function(panel,
                                 resol_nbin = c(4, 4, 2),
                                 mesh_cad = NULL,
                                 zero_layers_z = 1,
                                 k_factor = NULL,
                                 trunc_factor = 3.5,
                                 level_factor = 0.99,
                                 cad_coverage_tol = 0.99) {
  panel <- as.matrix(panel)

  if (!is.numeric(panel))
    stop("Argument 'panel' must be numeric")

  if (ncol(panel) != 3)
    stop("Argument 'panel' must have three columns: x, y and z")

  if (anyNA(panel))
    stop("Argument 'panel' contains NA values")

  if (length(resol_nbin) != 3 || any(resol_nbin <= 0))
    stop("Argument 'resol_nbin' must be a positive numeric vector of length 3")

  if (zero_layers_z < 0 || zero_layers_z %% 1 != 0)
    stop("Argument 'zero_layers_z' must be an integer greater than or equal to 0")

  # Number of bins in each spatial direction
  dimlen <- diff(t(matrixStats::colRanges(panel)))
  nbin <- trunc(dimlen / resol_nbin)
  nbin <- pmax(nbin, 2)

  # Linear binning
  bin <- npsp::binning(x = panel, nbin = nbin, type = "linear")
  bin$data <- NULL

  # Add external zero layers in Z
  if (zero_layers_z > 0) {
    dims <- bin$grid$n
    new_dims <- c(dims[1], dims[2], dims[3] + zero_layers_z)

    binw_ext <- array(0, dim = new_dims)
    binw_ext[, , 1:dims[3]] <- bin$binw

    bin$binw <- binw_ext
    bin$grid$n[3] <- new_dims[3]
    bin$grid$max[3] <- bin$grid$max[3] + zero_layers_z * bin$grid$lag[3]
    bin$grid$dimnames <- c("X", "Y", "Z")
  }

  # Automatic tolerance factor
  if (is.null(k_factor)) {
    if (all(resol_nbin == c(4, 4, 4))) {
      k_factor <- 0.1
    } else if (all(resol_nbin == c(2, 2, 2)) ||
               all(resol_nbin == c(4, 4, 2))) {
      k_factor <- 0.05
    } else {
      k_factor <- 0.05
      warning("No specific rule for 'resol_nbin'. Using k_factor = 0.05")
    }
  }

  # Non-empty binning nodes
  ldata <- bin$binw > 0
  idata <- which(ldata)
  w <- bin$binw[idata]

  if (length(w) == 0)
    stop("The binning object has no positive weights")

  # Remove low weights
  tol <- (nrow(panel) / length(w)) * k_factor
  ldata <- bin$binw > tol
  bin$binw[!ldata] <- 0

  # Truncate high weights
  trunc_value <- trunc_factor * tol
  bin$binw <- ifelse(bin$binw > trunc_value, trunc_value, bin$binw)

  # Marching Cubes density level
  level_bin <- level_factor * trunc_value

  # Binning coordinates
  coorval <- npsp::coordvalues(bin)

  # Marching Cubes
  utils::capture.output({
    cont3d_w <- with(
      coorval,
      misc3d::contour3d(
        bin$binw,
        level = level_bin,
        X, Y, Z,
        draw = FALSE,
        separate = TRUE
      )
    )
  })

  if (length(cont3d_w) == 0)
    stop("Marching Cubes did not generate any mesh")

  # Internal function: bounding box of a mesh3d object
  bboxMesh3d <- function(mesh) {
    if (!inherits(mesh, "mesh3d"))
      stop("Argument 'mesh_cad' must be an object of class 'mesh3d'")

    vertices <- t(mesh$vb[1:3, , drop = FALSE])
    apply(vertices, 2, range)
  }

  # Internal function: bounding box of a Triangles3D object
  calcular_bbox <- function(triangles) {
    vertices <- rbind(triangles$v1, triangles$v2, triangles$v3)
    apply(vertices, 2, range)
  }

  # Order isolated meshes by number of vertices
  mallas_ordenadas <- cont3d_w[
    order(sapply(cont3d_w, function(x) -nrow(x$v1)))
  ]

  # Select main component or merge components until CAD coverage is reached
  if (is.null(mesh_cad)) {
    panel_completo <- mallas_ordenadas[[1]]
  } else {
    cad_bbox <- bboxMesh3d(mesh_cad)
    cad_dim <- cad_bbox[2, ] - cad_bbox[1, ]

    panel_completo <- NULL

    for (malla_actual in mallas_ordenadas) {
      if (is.null(panel_completo)) {
        panel_completo <- malla_actual
      } else {
        panel_completo$v1 <- rbind(panel_completo$v1, malla_actual$v1)
        panel_completo$v2 <- rbind(panel_completo$v2, malla_actual$v2)
        panel_completo$v3 <- rbind(panel_completo$v3, malla_actual$v3)
      }

      bbox_actual <- calcular_bbox(panel_completo)
      dimensiones_actuales <- bbox_actual[2, ] - bbox_actual[1, ]

      if (all(dimensiones_actuales >= cad_dim * cad_coverage_tol))
        break
    }
  }

  # Convert Triangles3D to mesh3d
  t2ve <- utils::getFromNamespace("t2ve", "misc3d")
  mesh0 <- t2ve(panel_completo)

  mesh <- rgl::tmesh3d(
    vertices = mesh0[["vb"]],
    indices = mesh0[["ib"]]
  )

  result <- list(
    mesh = mesh,
    bin = bin,
    contours = cont3d_w,
    params = list(
      resol_nbin = resol_nbin,
      nbin = nbin,
      zero_layers_z = zero_layers_z,
      k_factor = k_factor,
      tol = tol,
      trunc_factor = trunc_factor,
      trunc_value = trunc_value,
      level_factor = level_factor,
      level_bin = level_bin,
      cad_coverage_tol = cad_coverage_tol
    )
  )

  return(result)
}
