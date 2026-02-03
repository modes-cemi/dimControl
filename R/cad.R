#' Objeto CAD de un panel de acero
#'
#' Este objeto corresponde a un modelo CAD teórico de un panel de acero, en formato `mesh3d`.
#'
#' @docType data
#' @name cad
#' @format A `mesh3d` object (list) with 3 main components:
#' \describe{
#'   \item{vb}{matrix 4 x 215 with vertex coordinates (homogeneous)}
#'   \item{it}{matrix 3 x 262 with triangle indices}
#'   \item{normals}{matrix 4 x 215 with vertex normals}
#' }
#' @source Modelo CAD teórico de un panel de acero
NULL
