#' CAD object of a steel panel
#'
#' This object corresponds to a portion of the theoretical CAD model of a steel panel,
#' stored as a `mesh3d` object.
#'
#' @docType data
#' @name cad
#' @format A `mesh3d` object (list) with 3 main components:
#' \describe{
#'   \item{vb}{matrix 4 x 267 with vertex coordinates (homogeneous)}
#'   \item{it}{matrix 3 x 343 with triangle indices}
#'   \item{normals}{matrix 4 x 267 with vertex normals}
#' }
#' @source Theoretical CAD model of a steel panel
NULL
