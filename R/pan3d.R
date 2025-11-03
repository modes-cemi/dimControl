#' Desplazamiento interactivo de la vista 3D con el ratón
#'
#' Permite desplazar la vista de un gráfico 3D interactivo en una ventana RGL al arrastrar
#' el ratón con un botón específico. Esta función usa callbacks del ratón (`rgl.setMouseCallbacks`)
#' para modificar la proyección de la escena mientras el usuario mueve el ratón2.
#'
#' @param button Entero que indica el botón del ratón a usar:
#'   \itemize{
#'     \item `1`: botón izquierdo
#'     \item `2`: botón derecho
#'     \item `3`: botón central (rueda)
#'   }
#' @param dev Identificador del dispositivo RGL (por defecto `cur3d()`).
#' @param subscene Subescena a la que se aplicará el movimiento (por defecto la subescena activa).
#'
#' @returns No devuelve ningún valor; el efecto es establecer los callbacks del ratón
#'          para desplazar la vista de la escena 3D.
#'
#' @details
#' Cuando se presiona el botón indicado, la función registra la posición inicial del
#' cursor (`begin`). Luego, mientras se mueve el ratón (`update`), calcula la traslación
#' necesaria y actualiza `userProjection` para simular el desplazamiento de la cámara en la escena.
#'
#' @examples
#' library(rgl)
#' open3d()
#' shade3d(icosahedron3d(), col = "lightblue")
#'
#' # Desplazar la vista con el botón izquierdo
#' pan3d(1)
#'
#' # Desplazar la vista con el botón derecho
#' pan3d(2)
#'
#' @seealso [rgl::rgl.setMouseCallbacks()], [rgl::par3d()], [rgl::translationMatrix()]
#'
#' @author Duncan Murdoch
#'
#' @importFrom rgl cur3d currentSubscene3d par3d rgl.setMouseCallbacks translationMatrix
#'
#' @export
pan3d <- function(button, dev = cur3d(), subscene = currentSubscene3d(dev)) {
  start <- list()

  begin <- function(x, y) {
    activeSubscene <- par3d("activeSubscene", dev = dev)
    start$listeners <<- par3d("listeners", dev = dev, subscene = activeSubscene)
    for (sub in start$listeners) {
      init <- par3d(c("userProjection","viewport"), dev = dev, subscene = sub)
      init$pos <- c(x/init$viewport[3], 1 - y/init$viewport[4], 0.5)
      start[[as.character(sub)]] <<- init
    }
  }

  update <- function(x, y) {
    for (sub in start$listeners) {
      init <- start[[as.character(sub)]]
      xlat <- 2*(c(x/init$viewport[3], 1 - y/init$viewport[4], 0.5) - init$pos)
      mouseMatrix <- translationMatrix(xlat[1], xlat[2], xlat[3])
      par3d(userProjection = mouseMatrix %*% init$userProjection, dev = dev, subscene = sub )
    }
  }
  rgl.setMouseCallbacks(button, begin, update, dev = dev, subscene = subscene)
  cat("Callbacks set on button", button, "of RGL device", dev, "in subscene", subscene, "\n")
}
