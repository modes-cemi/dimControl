#' Reconstruct a triangular mesh from a 3D point cloud
#'
#' Reconstructs a triangular surface from a 3D point cloud using linear binning
#' and Marching Cubes, and returns the result as a `mesh3d` object.
#'
#' @param cloud Numeric matrix or data frame with three columns containing the X,
#' Y, and Z coordinates of the point cloud.
#' @param resBin Numeric vector of length three defining the approximate binning
#' resolution in the X, Y, and Z directions. Default is `c(4, 4, 2)`.
#' @param refDim Optional numeric vector of length three specifying the reference
#' dimensions in the X, Y, and Z directions. If `NULL`, the dimensions are estimated
#' from the point cloud. Default is `NULL`.
#' @param addBorder Logical. If `TRUE`, adds a zero-valued layer around the X and
#' Z limits before surface extraction. Default is `FALSE`.
#' @param lowTol Numeric value used to determine the tolerance for removing
#' low-density nodes. If `NULL`, it is selected automatically according to `resBin`.
#' Default is `NULL`.
#' @param trunc Numeric value used to truncate high-density node weights. Default
#' is `3.5`.
#' @param level Numeric value used to define the isosurface extraction level.
#' Default is `0.99`.
#' @param coverageTol Numeric value between 0 and 1 defining the minimum spatial
#' coverage required relative to the reference dimensions. Default is `0.99`.
#'
#' @returns
#' A `mesh3d` object containing the reconstructed triangular surface.
#'
#' @details
#' Linear binning is performed using [npsp::binning()], and the corresponding grid
#' coordinates are obtained with [npsp::coordvalues()]. Low-density nodes are removed
#' and high-density weights are truncated before extracting the isosurface with
#' [misc3d::contour3d()].
#'
#' When `addBorder = TRUE`, one zero-valued layer is added on both sides of the X
#' and Z directions to facilitate surface closure.
#'
#' If several disconnected surfaces are generated, they are ordered by number of
#' triangles and progressively merged. Components are added until the bounding box
#' of the reconstructed surface reaches at least `coverageTol` times the reference
#' dimensions in all three directions.
#'
#' The reference dimensions can be provided directly through `refDim`. If `refDim = NULL`,
#' they are estimated from the coordinate ranges of the point cloud. Spatial coverage
#' refers to the bounding-box dimensions, not to the percentage of reconstructed
#' surface area.
#'
#' The resulting surface is converted to a triangular `mesh3d` object using [rgl::tmesh3d()].
#'
#' @seealso [npsp::binning()], [npsp::coordvalues()], [misc3d::contour3d()], [rgl::tmesh3d()]
#'
#' @examples
#' # Load the theoretical CAD model
#' data("cad", package = "dimControl")
#'
#' # Simulate object points without surrounding environment points
#' object <- simulateCloud(mesh = cad, n = 1e5, rgen = rtnorm, mean = 0, sd = 0.2,
#'                         a = -0.5, b = 0.5)
#'
#' # Reconstruct the mesh using dimensions estimated from the point cloud
#' mesh <- createMesh(cloud = object, resBin = c(12, 12, 6), addBorder = TRUE,
#'                    lowTol = 0.01, trunc = 1.5, level = 0.99)
#'
#' # Alternatively, provide the reference dimensions directly
#' # mesh <- createMesh(cloud = object, resBin = c(12, 12, 6), refDim = c(900, 500, 100),
#' #                    addBorder = TRUE, lowTol = 0.01, trunc = 1.5, level = 0.99)
#'
#' # Represent point cloud and reconstructed mesh side by side
#' # open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#'  mfrow3d(1, 2)
#'
#'  points3d(object, col = "blue", alpha = 0.1)
#'  title3d("Object point cloud", line = 8, level = 2)
#'
#'  next3d()
#'  shade3d(mesh, col = "lightgray")
#'  title3d("Reconstructed mesh", line = 8, level = 2)
#'
#' @export
createMesh <- function(cloud,
                       resBin = c(4, 4, 2),
                       refDim = NULL,
                       addBorder = FALSE,
                       lowTol = NULL,
                       trunc = 3.5,
                       level = 0.99,
                       coverageTol = 0.99) {

  # Convert point cloud to a numeric matrix
  cloud <- as.matrix(cloud)

  if (!is.numeric(cloud))
    stop("Argument 'cloud' must be numeric")

  if (ncol(cloud) != 3)
    stop("Argument 'cloud' must have three columns: x, y and z")

  if (anyNA(cloud))
    stop("Argument 'cloud' contains NA values")

  if (length(resBin) != 3 || any(resBin <= 0))
    stop("Argument 'resBin' must be a positive numeric vector of length 3")

  if (!is.logical(addBorder) || length(addBorder) != 1)
    stop("Argument 'addBorder' must be TRUE or FALSE")

  if (coverageTol <= 0 || coverageTol > 1)
    stop("Argument 'coverageTol' must be greater than 0 and less than or equal to 1")

  # Point cloud dimensions
  dimLen <- apply(cloud, 2, function(x) diff(range(x)))

  # Number of bins in each spatial direction
  nBin <- trunc(dimLen / resBin)
  nBin <- pmax(nBin, 2)

  if (!requireNamespace("npsp", quietly = TRUE)) stop("package 'npsp' is required")

  # Linear binning
  bin <- npsp::binning(x = cloud, nbin = nBin, type = "linear")
  bin$data <- NULL

  # Add one external zero-valued layer on the four sides:
  # left/right (X) and bottom/top (Z)
  if (addBorder) {
    dims <- bin$grid$n
    newDims <- dims + c(2, 0, 2)

    binwExt <- array(0, dim = newDims)

    binwExt[2:(dims[1] + 1), , 2:(dims[3] + 1)] <- bin$binw

    bin$binw <- binwExt
    bin$grid$n <- newDims

    # Extend X limits
    bin$grid$min[1] <- bin$grid$min[1] - bin$grid$lag[1]
    bin$grid$max[1] <- bin$grid$max[1] + bin$grid$lag[1]

    # Extend Z limits
    bin$grid$min[3] <- bin$grid$min[3] - bin$grid$lag[3]
    bin$grid$max[3] <- bin$grid$max[3] + bin$grid$lag[3]
  }

  bin$grid$dimnames <- c("X", "Y", "Z")

  # Automatic tolerance factor
  if (is.null(lowTol)) {

    if (all(resBin == c(4, 4, 4))) {
      lowTol <- 0.1
    } else if (
      all(resBin == c(2, 2, 2)) ||
      all(resBin == c(4, 4, 2))
    ) {
      lowTol <- 0.05
    } else {
      lowTol <- 0.05
      warning(
        "No specific rule for 'resBin'. Using lowTol = 0.05"
      )
    }
  }

  # Non-empty binning nodes
  w <- bin$binw[bin$binw > 0]

  if (length(w) == 0)
    stop("The binning cloud has no positive weights")

  # Remove low weights
  tol <- (nrow(cloud) / length(w)) * lowTol
  bin$binw[bin$binw <= tol] <- 0

  # Truncate high weights
  truncValue <- trunc * tol
  bin$binw[bin$binw > truncValue] <- truncValue

  # Marching Cubes density level
  levelBin <- level * truncValue

  # Binning coordinates
  coorVal <- npsp::coordvalues(bin)

  if (!requireNamespace("misc3d", quietly = TRUE)) stop("package 'misc3d' is required")

  # Extract isosurfaces using Marching Cubes
  utils::capture.output({
    contours <- with(coorVal, misc3d::contour3d(
        bin$binw, level = levelBin, X, Y, Z, draw = FALSE, separate = TRUE))
  })

  if (length(contours) == 0)
    stop("Marching Cubes did not generate any mesh")

  # Compute the bounding box of a Triangles3D object
  triangleBbox <- function(x) {
    vertices <- rbind(x$v1, x$v2, x$v3)
    apply(vertices, 2, range)
  }

  # Order disconnected components from largest to smallest
  contours <- contours[
    order(sapply(contours, function(x) nrow(x$v1)), decreasing = TRUE)]

  # Dimensions used as reference for mesh coverage
  if (is.null(refDim)) {
    refDim <- dimLen
  } else {
    if (!is.numeric(refDim) || length(refDim) != 3 ||
        anyNA(refDim) || any(!is.finite(refDim)) || any(refDim <= 0))
      stop("Argument 'refDim' must contain three positive dimensions: X, Y and Z")
  }

  # Merge disconnected components until the required coverage is reached
  surface <- NULL

  for (currentSurface in contours) {
    if (is.null(surface)) {
      surface <- currentSurface
    } else {
      surface$v1 <- rbind(surface$v1, currentSurface$v1)
      surface$v2 <- rbind(surface$v2, currentSurface$v2)
      surface$v3 <- rbind(surface$v3, currentSurface$v3)
    }

    currentBbox <- triangleBbox(surface)
    currentDim <- currentBbox[2, ] - currentBbox[1, ]

    if (all(currentDim >= refDim * coverageTol))
      break
  }

  # Convert Triangles3D to mesh3d
  t2ve <- utils::getFromNamespace("t2ve", "misc3d")

  mesh0 <- t2ve(surface)

  if (!requireNamespace("rgl", quietly = TRUE)) stop("package 'rgl' is required")

  mesh <- rgl::tmesh3d(
    vertices = mesh0[["vb"]],
    indices = mesh0[["ib"]]
  )

  # Return the reconstructed triangular mesh
  return(mesh)
}
