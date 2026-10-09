#' Compute vertex normals by averaging triangle normals
#'
#' Computes vertex normals of a triangular mesh by combining the normals of the triangles
#' incident to each vertex.
#'
#' @param x `mesh3d` object representing a triangular mesh.
#' @param normalsTri Numeric 3 x n or 4 x n matrix containing the face normals, where
#' n is the number of triangles. If not provided, face normals are computed internally
#' using `Rvcg::vcgFaceNormals()`.
#' @param normalized Logical. If `TRUE`, the columns of `normalsTri` are assumed to
#' be unit vectors. If `FALSE`, they are internally normalized. This argument is used
#' only when `normalsTri` is provided.
#'
#' @returns
#' `mesh3d` object with the `normals` field updated, containing the unit normal vectors
#' for each vertex in homogeneous coordinates.
#'
#' @details
#' When `normalsTri` is provided, the face normals are converted to Euclidean coordinates
#' using `rgl::asEuclidean2()`. If `normalized = FALSE`, each face normal is subsequently
#' normalized to unit length.
#'
#' When `normalsTri` is not provided, normalized face normals are computed internally
#' using `Rvcg::vcgFaceNormals()`.
#'
#' For each vertex, the normals of all incident triangles are summed and the resulting
#' vector is normalized to unit length. Therefore, when unit face normals are used,
#' each incident triangle contributes equally, with no weighting by triangle area or
#' vertex angle.
#'
#' @examples
#' # Create a triangular mesh
#' mesh <- subdivision3d(icosahedron3d(), depth = 1)
#'
#' # Compute face normals
#' normTri <- vcgFaceNormals(mesh)
#'
#' # Compute vertex normals from the supplied face normals
#' mesh <- addNormals2(mesh, normTri)
#'
#' # Show the first five vertex normals
#' mesh$normals[, 1:5]
#'
#' @export
addNormals2 <- function(x, normalsTri, normalized = TRUE) {

  # Number of triangles
  nTri <- ncol(x$it)

  if (!nTri)
    stop("Argument 'x' must be a triangular mesh")

  # Compute face normals if they are not provided
  if (missing(normalsTri)) {

    if (!requireNamespace("Rvcg", quietly = TRUE)) stop("package 'Rvcg' is required")

    # vcgFaceNormals() returns normalized Euclidean face normals
    normalsTri <- Rvcg::vcgFaceNormals(x)

  } else {

    if (!requireNamespace("rgl", quietly = TRUE)) stop("package 'rgl' is required")

    # Converts to Euclidean coordinates
    normalsTri <- rgl::asEuclidean2(normalsTri)

    # Normalize only when necessary
    if (!normalized) normalsTri <- .normalize(normalsTri)
  }

  # Initialise vertex normals
  normals <- matrix(0, nrow = 3, ncol = ncol(x$vb))

  # Sum the normals of the triangles incident to each vertex
  for (j in seq_len(nTri)) {
    ivb <- x$it[, j]
    normals[, ivb] <- normals[, ivb] + normalsTri[, j]
  }

  # Normalize the resulting vertex normals and store vertex normals in homogeneous coordinates
  normals <- rbind(.normalize(normals), 1)
  x$normals <- normals
  x
}






