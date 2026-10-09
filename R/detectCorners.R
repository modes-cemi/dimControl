#' Detect the corners of a rectangular boundary
#'
#' Identifies the four corner vertices of an approximately rectangular
#' boundary using its convex hull and Euclidean distances.
#'
#' @param boundaryXY Numeric matrix with two columns containing the X and Y
#' coordinates of the boundary vertices.
#'
#' @returns
#' Named integer vector containing the row indices of the four detected
#' corners in `boundaryXY`: A (bottom-left), B (bottom-right),
#' C (top-right), and D (top-left).
#'
#' @details
#' The convex hull of the boundary is computed using [grDevices::chull()].
#' Four reference corners are defined from the minimum and maximum X and Y
#' coordinates. For each reference corner, the closest convex hull vertex
#' is selected using Euclidean distance.
#'
#' The method assumes that the rectangular boundary is approximately aligned
#' with the X and Y axes. Results may be affected by noise, outliers, or
#' rotation of the geometry.
#'
#' @examples
#' # Define the boundary coordinates of a rectangle
#' boundaryXY <- rbind(
#'   c(0, 0), c(5, 0), c(10, 0),
#'   c(10, 3), c(10, 6),
#'   c(5, 6), c(0, 6), c(0, 3)
#' )
#'
#' # Identify the four corner vertices
#' iCorner <- detectCorners(boundaryXY)
#'
#' # Extract the corner coordinates
#' corners <- boundaryXY[iCorner, ]
#'
#' # Plot the boundary and the detected corners
#' plot(boundaryXY, pch = 16, col = "grey", xlab = "X", ylab = "Y")
#' polygon(boundaryXY, border = "black")
#' points(corners, pch = 19, col = "red", cex = 1.5)
#'
#' @export
detectCorners <- function(boundaryXY) {

  # Identify convex hull vertices
  iHull <- grDevices::chull(boundaryXY)
  hullXY <- boundaryXY[iHull, ]

  # Define the four reference corners
  corners <- rbind(
    A = c(min(hullXY[, 1]), min(hullXY[, 2])),
    B = c(max(hullXY[, 1]), min(hullXY[, 2])),
    C = c(max(hullXY[, 1]), max(hullXY[, 2])),
    D = c(min(hullXY[, 1]), max(hullXY[, 2]))
  )

  # Find the closest convex hull vertex to each corner
  iCorner <- apply(corners, 1, function(p) {
    distances <- apply(hullXY, 1, function(v) {
      euclideanDistance(v - p)
    })
    iHull[which.min(distances)]
  })

  # Check that four distinct corners were identified
  if (length(unique(iCorner)) != 4) {
    stop("Four distinct corners could not be identified.")
  }

  return(iCorner)
}
