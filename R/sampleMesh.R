#' @importFrom stats rmultinom runif

# Internal function: generates points inside a triangle
sampleTriangle <- function(tri, n) {
  u <- matrix(runif(2*n), nrow = 2)
  index <- colSums(u) > 1
  u[, index] <- 1 - u[, index]
  result <- tri[, 1] +
    cbind(tri[, 2] - tri[, 1], tri[, 3] - tri[, 1]) %*% u
  return(result) # Each column is a point
}

#' Sampling points over a triangular mesh
#'
#' Generates random points uniformly distributed over a triangular mesh.
#' Each triangle receives a number of points proportional to its area, and the points
#' are generated using barycentric coordinates.
#'
#' Internally, this function uses `sampleTriangle()` to sample points
#' within each triangle.
#'
#' @param mesh A list representing a triangular mesh, containing:
#'   \itemize{
#'     \item `vb`: a 3xN (or 4xN homogeneous) matrix with the mesh vertex coordinates.
#'     \item `it`: a 3xM matrix with the vertex indices for each triangle (each column is a triangle).
#'   }
#' @param n Integer greater than 0. Total number of points to generate.
#' @param shuffle Logical. Whether to shuffle the generated points randomly.
#'
#' @details
#' If the mesh uses homogeneous coordinates (4th row in `vb`), points are converted
#' to 3D by dividing by the w component. The points are returned as columns
#' of a 3xN matrix. If `shuffle = TRUE`, the point order is shuffled randomly.
#'
#' @returns A numeric matrix of dimension 3 x n, where each column represents
#'   a point sampled in 3D space.
#'
#' @examples
#' \dontrun{
#' # Create a triangular sphere
#' mesh <- Rvcg::vcgSphere(1, subdiv = 1)
#' rgl::wire3d(mesh) # visualize the mesh
#' # Sample 10000 points over the mesh
#' pts <- sampleMesh(mesh, 10000, shuffle = TRUE)
#' # Plot the sampled points
#' rgl::points3d(t(pts), col = "red", size = 5)
#' }
#'
#' @export
sampleMesh <- function(mesh, n, shuffle = FALSE) {
  it <- mesh$it # Each column defines a triangle (vertex indices)
  if(is.null(it))
    stop("Argument 'mesh' must be a triangular mesh")
  v <- mesh$vb # Each column is a point
  # Make sure v is homogeneous with unit w
  if (nrow(v) == 4) {
    w <- v[4, ]
    v <- v[1:3,]
    if (!all(w == 1)) v <- t( t(v)/w )
  }
  areas <- Rvcg::vcgArea(mesh, perface = TRUE)$pertriangle
  # Use multinomial distribution to assign number of points per triangle
  # proportional to its area
  nstri <- rmultinom(1, size = n, prob = areas/sum(areas))
  index <- which(nstri > 0)
  # Internal call to sampleTriangle() for each triangle
  result <- lapply(index, function(i) sampleTriangle(v[, it[, i]], nstri[i]))
  result <- matrix(unlist(result), nrow = 3)
  if (shuffle)
    result <- result[, sample(ncol(result))]
  return(result) # Each column is a point
}
