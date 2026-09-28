#' Sample points over a triangular mesh
#'
#' Generates random points uniformly distributed over the surface of a triangular mesh.
#' The number of points assigned to each triangle is proportional to its area.
#'
#' @param mesh `mesh3d` object containing a triangular mesh with the following components:
#' \itemize{
#'   \item `vb`: 3 x N or 4 x N matrix containing vertex coordinates.
#'   \item `it`: 3 x M matrix containing triangle indices.
#' }
#' @param n Positive integer specifying the total number of points to generate.
#' @param shuffle Logical. If `TRUE`, randomly shuffles the order of the generated
#' points. Default is `FALSE`.
#'
#' @returns
#' A numeric matrix with 3 rows and `n` columns, where each column represents a sampled
#' 3D point.
#'
#' @details
#' The surface area of each triangle is obtained using [Rvcg::vcgArea()]. The number
#' of points assigned to each triangle is generated from a multinomial distribution
#' with probabilities proportional to triangle area.
#'
#' Points within each triangle are generated uniformly using barycentric coordinates.
#'
#' Vertex coordinates are converted to Euclidean coordinates using [rgl::asEuclidean2()].
#'
#' @seealso [Rvcg::vcgArea()], [rgl::asEuclidean2()], [rgl::points3d()]
#'
#' @examples
#' library(rgl)
#' library(Rvcg)
#'
#' # Create a triangular sphere
#' mesh <- vcgSphere(1, subdiv = 1)
#'
#' # Represent the triangular mesh
#' open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#' wire3d(mesh)
#'
#' # Sample points over the mesh
#' points <- sampleMesh(mesh, 10000, shuffle = TRUE)
#'
#' # Represent the sampled points
#' points3d(t(points), col = "red", size = 2)
#'
#' @export
sampleMesh <- function(mesh, n, shuffle = FALSE) {

  # Extract triangle indices
  it <- mesh$it

  if(is.null(it))
    stop("Argument 'mesh' must be a triangular mesh")

  # Extract vertex coordinates
  v <- mesh$vb

  if (!requireNamespace("rgl", quietly = TRUE)) stop("Package 'rgl' is required")

  # Convert vertex coordinates to Euclidean coordinates
  v <- rgl::asEuclidean2(mesh$vb)

  if (!requireNamespace("Rvcg", quietly = TRUE)) stop("Package 'Rvcg' is required")

  # Compute triangle areas
  areas <- Rvcg::vcgArea(mesh, perface = TRUE)$pertriangle

  # Assign points to triangles proportionally to their area
  nTriSamples <- stats::rmultinom(1, size = n, prob = areas/sum(areas))

  triangleIndex <- which(nTriSamples > 0)

  # Sample points inside each selected triangle
  result <- lapply(triangleIndex, function(i) .sampleTriangle(v[, it[, i]], nTriSamples[i]))

  result <- matrix(unlist(result), nrow = 3)

  # Optionally shuffle sampled points
  if (shuffle)
    result <- result[, sample(ncol(result)), drop = FALSE]

  result
}
