#' Determine the orientation of a reinforcement bulb
#'
#' Determines whether the bulb of a reinforcement is oriented to the left or right
#' based on the vertex coordinates of a `mesh3d` object.
#'
#' @param ref `mesh3d` object containing one or more reinforcements. It must contain
#' the `vb` matrix with the vertex coordinates.
#'
#' @returns
#' Logical value. `TRUE` if the bulb protrudes to the left and `FALSE` if the bulb
#' protrudes to the right.
#'
#' @details
#' The mesh is divided into two regions using the midpoint of the observed Z range:
#'
#' \deqn{z_{mid} = \frac{z_{min} + z_{max}}{2}}
#'
#' Vertices above this value are considered part of the upper region containing the
#' bulb, while the remaining vertices define the lower region.
#'
#' The minimum X coordinate of both regions is then compared. If the upper region
#' extends farther toward smaller X values than the lower region, the bulb is classified
#' as left-oriented.
#'
#' When `ref` contains multiple reinforcements, the result describes their overall
#' orientation according to the vertex coordinates contained in the mesh. To obtain
#' the orientation of each reinforcement separately, the mesh should first be split
#' into its connected components and `sideBulb()` applied to each component.
#'
#' @examples
#' library(rgl)
#' library(Rvcg)
#'
#' # Load the theoretical CAD mesh containing the reinforcements
#' data("cad", package = "dimControl")
#'
#' # Compute face normals and barycentres
#' normals <- vcgFaceNormals(cad)
#' bary <- vcgBary(cad)
#'
#' # Compute triangle orientation angles
#' angleZ <- angleAxis(normals, 3)
#' angleX <- angleAxis(normals, 1, negative = TRUE)
#'
#' # Classify mesh triangles according to their orientation
#' isHorizontal <- angleZ < 40
#' isVertical <- angleX < 60 | angleX > 120
#'
#' # Identify the panel base
#' isBase <- isHorizontal & bary[, 3] < 20
#'
#' # Identify triangles belonging to the reinforcements
#' isReinforcement <- !isBase & (isVertical | isHorizontal) & bary[, 3] > 20
#'
#' # Extract the reinforcements from the panel mesh
#' meshRef <- cad
#' meshRef$it <- cad$it[, isReinforcement, drop = FALSE]
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
#' # Determine the bulb orientation of each reinforcement
#' # TRUE = left, FALSE = right
#' bulbSide <- sapply(ref, sideBulb)
#' bulbSide
#'
#' # Represent the reinforcement components
#' open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#' for (i in seq_along(ref)) {
#'   shade3d(ref[[i]], col = "lightgray")
#' }
#' rglwidget()
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


