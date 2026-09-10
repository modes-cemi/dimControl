#' Prepare a Theoretical Panel Mesh for Point Cloud Simulation
#'
#' Prepares a theoretical steel panel mesh from a CAD `mesh3d` object for use in point
#' cloud simulation. The function removes the lower face, identifies the panel base,
#' translates the mesh to the origin, and removes triangles located below the Z = 0 plane.
#'
#' @param mesh A `mesh3d` object containing the CAD geometry of the panel. The mesh
#' must contain a triangular `it` matrix.
#' @param lowerAngle Numeric. Angular threshold in degrees used to identify the lower
#' face of the panel. Default is `120`.
#' @param horizontalAngle Numeric. Maximum angle in degrees used to identify approximately
#' horizontal faces. Default is `40`.
#' @param boundaryStrip Numeric. Width of the strip along the Y direction used to identify
#' the reference corner of the panel base. Default is `10`.
#'
#' @returns
#' A processed `mesh3d` object translated to the origin and ready for point cloud simulation.
#'
#' @details
#' Face normals are used to remove the lower face and identify approximately horizontal
#' components. The boundary of the base is extracted with [getBoundarySegments()], and
#' a reference corner is used to translate the mesh to the origin.
#'
#' @seealso [simulatePanelFloorCloud()], [getBoundarySegments()], [angleFromAxis()]
#'
#' @examples
#' \dontrun{
#' data("cad", package = "dimControl")
#'
#' meshTeor <- preparePanelMesh(cad)
#'
#' rgl::clear3d()
#' rgl::shade3d(meshTeor, col = "gray")
#' rgl::decorate3d()
#' }
#'
#' @export
preparePanelMesh <- function(mesh,
                             lowerAngle = 120,
                             horizontalAngle = 40,
                             boundaryStrip = 10) {

  if (!inherits(mesh, "mesh3d"))
    stop("Argument 'mesh' must be an object of class 'mesh3d'")

  if (is.null(mesh$it))
    stop("Argument 'mesh' must contain a triangular 'it' matrix")

  # Remove lower face of the panel
  normals <- Rvcg::vcgFaceNormals(mesh)

  angleZ <- angleFromAxis(normals, dim = 3, deg = TRUE)

  lowerFace <- angleZ > lowerAngle

  meshTheoretical <- mesh
  meshTheoretical$it <- mesh$it[, !lowerFace, drop = FALSE]

  # Remove attributes that are no longer consistent with the modified mesh
  meshTheoretical$normals <- NULL
  meshTheoretical$tags <- NULL

  # Clean unused vertices
  meshTheoretical <- cleanMesh3d(meshTheoretical)

  ## Recalculate normals and barycenters
  normals <- Rvcg::vcgFaceNormals(meshTheoretical)

  angleZ <- angleFromAxis(normals, dim = 3, deg = TRUE)

  bary <- Rvcg::vcgBary(meshTheoretical)

  # Identify horizontal components and panel base
  horizontal <- angleZ < horizontalAngle

  zLimit <- mean(bary[, 3])

  base <- horizontal & bary[, 3] < zLimit

  baseMesh <- meshTheoretical
  baseMesh$it <- meshTheoretical$it[, base, drop = FALSE]

  # Remove normals because they correspond to the complete mesh
  baseMesh$normals <- NULL

  # Extract base boundary
  boundaryMesh <- getBoundarySegments(
    baseMesh,
    malla = TRUE,
    simplify = TRUE
  )

  boundaryCoordinates <- as.data.frame(t(boundaryMesh$vb[1:3, , drop = FALSE]))

  names(boundaryCoordinates) <- c("X", "Y", "Z")

  # Identify reference corner
  lowerStrip <- boundaryCoordinates[
    boundaryCoordinates$Y <= min(boundaryCoordinates$Y) + boundaryStrip, , drop = FALSE]

  corner <- lowerStrip[which.min(lowerStrip$X), , drop = FALSE]

  # Translate theoretical mesh to the origin
  meshTheoretical <- rgl::translate3d(meshTheoretical, -corner$X, -corner$Y, -corner$Z)

  # Remove triangles containing vertices below Z = 0
  idx <- which(meshTheoretical$vb[3, ] >= 0)

  keep <- apply(meshTheoretical$it, 2, function(face) all(face %in% idx))

  meshTheoretical$it <- meshTheoretical$it[ , keep, drop = FALSE]

  # Remove attributes that are no longer valid
  meshTheoretical$normals <- NULL
  meshTheoretical$tags <- NULL

  # Clean unused vertices
  meshTheoretical <- cleanMesh3d(meshTheoretical)

  meshTheoretical
}


#' Simulate a Steel Panel and Floor Point Cloud
#'
#' Generates a simulated 3D point cloud representing a steel panel and its surrounding
#' floor.
#'
#' Panel points are sampled from a theoretical `mesh3d` surface using [sampleMesh()]
#' and perturbed with truncated normal noise. Floor points are generated in four regions
#' surrounding the panel in the XY plane.
#'
#' @param mesh A theoretical `mesh3d` object representing the panel, typically obtained
#' with [preparePanelMesh()].
#' @param nPanel Number of points sampled from the panel surface. Default is `1e7`.
#' @param nFloor Number of points generated for the surrounding floor. Default is `1e6`.
#' @param prec Positive numeric value defining the truncation limits of the noise applied
#' to the panel coordinates. Default is `0.5`.
#' @param sdPanel Standard deviation of the truncated normal noise applied to the panel
#' coordinates. Default is `0.2`.
#' @param sdFloorZ Standard deviation of the vertical noise applied to the floor points.
#' Default is `0.2`.
#' @param marginXY Additional distance used to extend the simulated floor beyond the
#' panel bounding box. Default is `20`.
#' @param gapZ Vertical distance between the lowest point of the panel and the mean
#' height of the simulated floor. Default is `2`.
#' @param seed Integer used to initialise the random number generator. Default is `1`.
#'
#' @returns
#' A data frame with numeric columns `X`, `Y`, and `Z`. The first `nPanel` rows correspond
#' to panel points and the remaining `nFloor` rows correspond to floor points.
#'
#' @details
#' Setting `nFloor = 0` generates only points from the panel surface.
#'
#' @seealso [preparePanelMesh()], [sampleMesh()]
#'
#' @examples
#' \dontrun{
#' data("cad", package = "dimControl")
#'
#' meshTeor <- preparePanelMesh(cad)
#'
#' data <- simulatePanelFloorCloud(
#'   mesh = meshTeor,
#'   nPanel = 1e7,
#'   nFloor = 1e6,
#'   seed = 1
#' )
#'
#' dim(data)
#' head(data)
#'
#' rgl::clear3d()
#' rgl::points3d(data, col = "gray")
#' rgl::decorate3d()
#' }
#'
#' @export
simulatePanelFloorCloud <- function(mesh,
                                    nPanel = 1e7,
                                    nFloor = 1e6,
                                    prec = 0.5,
                                    sdPanel = 0.2,
                                    sdFloorZ = 0.2,
                                    marginXY = 20,
                                    gapZ = 2,
                                    seed = 1) {

  if (!inherits(mesh, "mesh3d"))
    stop("Argument 'mesh' must be an object of class 'mesh3d'")

  if (nPanel <= 0)
    stop("Argument 'n_panel' must be greater than 0")

  if (nFloor < 0)
    stop("Argument 'n_floor' must be greater than or equal to 0")

  if (prec <= 0)
    stop("Argument 'prec' must be greater than 0")

  if (sdPanel < 0 || sdFloorZ < 0)
    stop("Standard deviations must be greater than or equal to 0")

  # Internal function: truncated normal random values
  rtnormInternal <- function(n,
                             mean = 0,
                             sd = 1,
                             lower = -Inf,
                             upper = Inf) {

    pLower <- stats::pnorm(lower, mean = mean, sd = sd)

    pUpper <- stats::pnorm(upper, mean = mean, sd = sd)

    stats::qnorm(
      stats::runif(n, min = pLower, max = pUpper),
      mean = mean,
      sd = sd
    )
  }

  set.seed(seed)

  nPanel <- as.integer(nPanel)
  nFloor <- as.integer(nFloor)

  # Simulate panel points
  panel <- sampleMesh(mesh, nPanel)
  panel <- t(panel)

  # Add truncated normal noise independently to X, Y and Z
  for (j in seq_len(3)) {

    panel[, j] <- panel[, j] +
      rtnormInternal(
        nPanel,
        mean = 0,
        sd = sdPanel,
        lower = -prec,
        upper = prec
      )
  }

  panel <- as.data.frame(panel)
  names(panel) <- c("X", "Y", "Z")

  # Panel bounding box
  xRange <- range(panel$X)
  yRange <- range(panel$Y)
  zRange <- range(panel$Z)

  xMinExt <- xRange[1] - marginXY
  xMaxExt <- xRange[2] + marginXY

  yMinExt <- yRange[1] - marginXY
  yMaxExt <- yRange[2] + marginXY

  # Number of floor points in each external region
  nLeft <- round(nFloor * 0.25)
  nRight <- round(nFloor * 0.25)
  nBottom <- round(nFloor * 0.25)

  nTop <- nFloor - nLeft - nRight - nBottom

  # Simulate floor points
  floorLeft <- data.frame(
    X = stats::runif(nLeft, xMinExt, xRange[1]),
    Y = stats::runif(nLeft, yMinExt, yMaxExt))

  floorRight <- data.frame(
    X = stats::runif(nRight, xRange[2], xMaxExt),
    Y = stats::runif(nRight, yMinExt, yMaxExt))

  floorBottom <- data.frame(
    X = stats::runif(nBottom, xRange[1], xRange[2]),
    Y = stats::runif(nBottom, yMinExt, yRange[1]))

  floorTop <- data.frame(
    X = stats::runif(nTop, xRange[1], xRange[2]),
    Y = stats::runif(nTop, yRange[2], yMaxExt))

  floor <- rbind(floorLeft, floorRight, floorBottom, floorTop)

  # Floor height
  zFloor <- zRange[1] - gapZ

  floor$Z <- stats::rnorm(
    nrow(floor),
    mean = zFloor,
    sd = sdFloorZ
  )

  # Combine panel and floor points
  data <- rbind(panel, floor)

  data
}
