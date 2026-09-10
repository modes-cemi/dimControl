#' Determine the Orientation of a Reinforcement Bulb
#'
#' Determines whether the bulb of a reinforcement is oriented to the left or right
#' based on the vertex coordinates of a `mesh3d` object.
#'
#' @param ref A `mesh3d` object representing the reinforcement. It must contain the
#' `vb` matrix with the vertex coordinates.
#'
#' @returns
#' A logical value:
#' \itemize{
#'   \item `TRUE` if the bulb protrudes to the left.
#'   \item `FALSE` if the bulb protrudes to the right.
#' }
#'
#' @details
#' The reinforcement is divided into two regions using the midpoint of the observed
#' Z range:
#'
#' \deqn{z_{mid} = \frac{z_{min} + z_{max}}{2}}
#'
#' Vertices above this value are considered part of the upper region containing the
#' bulb, while the remaining vertices define the lower region.
#'
#' The minimum X coordinate of both regions is then compared. If the upper region extends
#' farther toward smaller X values than the lower region, the bulb is classified as
#' left-oriented.
#'
#' @examples
#' \dontrun{
#' # Load and prepare the theoretical CAD model
#' data("cad", package = "dimControl")
#' meshTeor <- preparePanelMesh(cad)
#'
#' # Compute face normals and barycentres
#' normals <- Rvcg::vcgFaceNormals(meshTeor)
#' bary <- Rvcg::vcgBary(meshTeor)
#'
#' # Compute triangle orientation angles
#' angleZ <- angleFromAxis(normals, 3)
#' angleX <- angleFromAxis(normals, 1, negDir = TRUE)
#'
#' # Classify mesh triangles according to their orientation
#' isHorizontal <- angleZ < 40
#' isVertical <- angleX < 60 | angleX > 120
#'
#' # Use orientation and height to identify the panel base
#' isBase <- isHorizontal & bary[, 3] < 20
#'
#' # Use orientation and height to identify the reinforcements
#' isReinforcement <- !isBase & (isVertical | isHorizontal) & bary[, 3] > 20
#'
#' # Extract the reinforcement mesh
#' meshRef <- meshTeor
#' meshRef$it <- meshTeor$it[, isReinforcement, drop = FALSE]
#' meshRef$tags <- NULL
#' meshRef <- cleanMesh3d(meshRef)
#'
#' # Identify connected reinforcement components
#' compRef <- splitTrianglesInd(meshRef)
#' components <- filterMeshComponents(mesh = meshRef, comps = compRef, minSize = 50)
#'
#' # Create an independent mesh for each reinforcement
#' componentIds <- unique(components$compId)
#' nRef <- length(componentIds)
#' ref <- vector("list", nRef)
#'
#' for (i in seq_len(nRef)) {
#'   triIdx <- components$triIdx[components$compId == componentIds[i]]
#'
#'   ref[[i]] <- meshRef
#'   ref[[i]]$it <- meshRef$it[, triIdx, drop = FALSE]
#'   ref[[i]]$tags <- NULL
#'   ref[[i]] <- cleanMesh3d(ref[[i]])
#' }
#'
#' # Determine bulb orientation
#' # TRUE = left, FALSE = right
#' bulbSide <- sapply(ref, sideBulb)
#' bulbSide
#'
#' # Visualise the reinforcement components
#' rgl::clear3d()
#' for (i in seq_along(ref)) {
#'   rgl::shade3d(ref[[i]], col = "lightgray")
#' }
#' }
#'
#' @export
sideBulb <- function(ref) {

  # Midpoint of the Z range
  zMid <- (min(ref$vb[3, ]) + max(ref$vb[3, ])) / 2

  # Split the reinforcement into upper and lower regions
  bulbPart <- ref$vb[, ref$vb[3, ] > zMid]

  reinforcementPart <- ref$vb[, ref$vb[3, ] <= zMid]

  # Determine bulb orientation
  min(bulbPart[1, ]) < min(reinforcementPart[1, ])
}


