#' CAD model of a steel panel
#'
#' Portion of the theoretical CAD model of a steel panel, represented as a `mesh3d`
#' object. The model provides the reference geometry of the panel and can be used for
#' geometric comparison with estimated meshes or for point cloud simulation.
#'
#' @format
#' `mesh3d` object with the following components:
#' \describe{
#'   \item{vb}{Numeric 4 x 210 matrix containing vertex coordinates in homogeneous form.}
#'   \item{it}{Integer 3 x 256 matrix containing triangle indices.}
#' }
#'
#' @details
#' The mesh contains 210 vertices and 256 triangular faces.
#'
#' @examples
#' data("cad", package = "dimControl")
#'
#' # Show the structure
#' str(cad)
#'
#' # Represent the CAD model
#' open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
#' shade3d(cad, col = "gray")
#' decorate3d()
#'
#' @source
#' Theoretical CAD model of a steel panel.
#'
"cad"
