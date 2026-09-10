#' Sample Points Inside a Triangle
#'
#' Internal function used by [sampleMesh()] to generate uniformly distributed points
#' inside a triangle.
#'
#' @param tri A 3 x 3 numeric matrix whose columns contain the coordinates of the triangle
#' vertices.
#' @param n Number of points to generate.
#'
#' @returns
#' A 3 x `n` numeric matrix where each column represents a sampled point.
#'
#' @noRd
sampleTriangle <- function(tri, n) {
  u <- matrix(stats::runif(2*n), nrow = 2)

  # Reflect points outside the unit triangle
  index <- colSums(u) > 1
  u[, index] <- 1 - u[, index]

  # Transform barycentric coordinates to 3D coordinates
  result <- tri[, 1] + cbind(tri[, 2] - tri[, 1], tri[, 3] - tri[, 1]) %*% u

  result
}

#' Sample Points over a Triangular Mesh
#'
#' Generates random points uniformly distributed over the surface of a triangular mesh.
#' The number of points assigned to each triangle is proportional to its area.
#'
#' @param mesh A `mesh3d` object containing a triangular mesh. It must include:
#' \itemize{
#'   \item `vb`: a 3 x N or 4 x N matrix containing the vertex coordinates.
#'   \item `it`: a 3 x M matrix containing the vertex indices of each triangle.
#' }
#' @param n A positive integer specifying the total number of points to generate.
#' @param shuffle Logical. If `TRUE`, randomly shuffles the order of the generated
#' points. Default is `FALSE`.
#'
#' @returns
#' A numeric matrix with 3 rows and `n` columns, where each column represents a sampled
#' 3D point.
#'
#' @details
#' The surface area of each triangle is obtained using [Rvcg::vcgArea()]. The number
#' of points assigned to each triangle is then generated from a multinomial distribution
#' with probabilities proportional to triangle area.
#'
#' Points within each triangle are generated uniformly using barycentric coordinates.
#'
#' If `mesh$vb` contains homogeneous coordinates, the vertices are converted to Cartesian
#' coordinates by dividing the first three coordinates by the homogeneous coordinate.
#'
#' @seealso [Rvcg::vcgArea()], [rgl::points3d()]
#'
#' @examples
#' \dontrun{
#' # Create a triangular sphere
#' mesh <- Rvcg::vcgSphere(1, subdiv = 1)
#'
#' rgl::wire3d(mesh)
#'
#' # Sample points over the mesh
#' points <- sampleMesh(mesh, 10000, shuffle = TRUE)
#'
#' # Display sampled points
#' rgl::points3d(t(points), col = "red", size = 2)
#' }
#'
#' @export
sampleMesh <- function(mesh, n, shuffle = FALSE) {

  # Extract triangle indices
  it <- mesh$it

  if(is.null(it))
    stop("Argument 'mesh' must be a triangular mesh")

  # Extract vertex coordinates
  v <- mesh$vb

  # Convert homogeneous coordinates to Cartesian coordinates
  if (nrow(v) == 4) {
    w <- v[4, ]
    v <- v[1:3,]
    if (!all(w == 1)) v <- t( t(v)/w )
  }

  # Compute triangle areas
  areas <- Rvcg::vcgArea(mesh, perface = TRUE)$pertriangle

  # Assign points to triangles proportionally to their area
  nTriSamples <- stats::rmultinom(1, size = n, prob = areas/sum(areas))

  triangleIndex <- which(nTriSamples > 0)

  # Sample points inside each selected triangle
  result <- lapply(triangleIndex, function(i) sampleTriangle(v[, it[, i]], nTriSamples[i]))
  result <- matrix(unlist(result), nrow = 3)

  # Optionally shuffle sampled points
  if (shuffle)
    result <- result[, sample(ncol(result)), drop = FALSE]

  result
}
