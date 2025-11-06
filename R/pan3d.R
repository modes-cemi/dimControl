#' Desplazamiento lateral interactivo de la vista 3D
#'
#' Activa el desplazamiento lateral (paneo) de la vista en una escena 3D de RGL. Permite
#' mover la proyección de la cámara al arrastrar el ratón con un botón determinado,
#' facilitando el ajuste de la posición de la vista sin modificar la orientación del modelo.
#'
#' Internamente, esta función utiliza los *callbacks* del ratón mediante [`rgl.setMouseCallbacks()`],
#' lo que permite actualizar la proyección de la escena en tiempo real a medida que se
#' mueve el ratón.
#'
#' Esta funcionalidad no está disponible de forma predeterminada en las representaciones
#' 3D de **rgl**, pero puede activarse con esta función para lograr un desplazamiento
#' fluido (por ejemplo, con `pan3d(2)` para el botón derecho).
#'
#' @param button Entero que indica el botón del ratón usado para el desplazamiento:
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
#' cursor (*evento* `begin`). A medida que el ratón se mueve (*evento* `update`),
#' calcula el desplazamiento relativo y actualiza el parámetro `userProjection` para
#' simular una traslación de la cámara dentro de la escena.
#'
#' @note El código original fue desarrollado por **Duncan Murdoch** y forma parte del
#' paquete **rgl**, donde no se encuentra exportado públicamente. Se incluye aquí sin
#' modificaciones para facilitar su uso dentro de este paquete.
#'
#' @author Duncan Murdoch.
#'
#' @seealso [rgl::rgl.setMouseCallbacks()], [rgl::par3d()], [rgl::translationMatrix()]
#'
#' @examples
#' require(rgl)
#'
#' open3d()
#' shade3d(icosahedron3d(), col = "lightblue")
#' pan3d(2) # Activa el desplazamiento con el botón derecho del ratón
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
