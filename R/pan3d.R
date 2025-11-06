#' Desplazamiento interactivo de la vista 3D
#'
#' Activa el desplazamiento de la cámara en una escena 3D de **rgl**, permitiendo mover
#' la vista libremente dentro de la ventana gráfica al arrastrar el ratón con el botón
#' indicado.
#'
#' De forma predeterminada, **rgl** solo permite rotar y hacer zoom sobre los objetos
#' 3D, pero no desplazar la cámara. Esta función amplía dicha interacción al permitir
#' trasladar toda la escena en cualquier dirección sin modificar la orientación del modelo.
#'
#' Internamente, la función utiliza *callbacks* del ratón mediante [`rgl.setMouseCallbacks()`],
#' de modo que, al presionar y arrastrar el ratón, se actualiza dinámicamente la matriz
#' de proyección (`userProjection`) para simular un desplazamiento fluido dentro de la escena.
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
#' @returns No devuelve ningún valor; su efecto es establecer los *callbacks* del ratón
#'          para desplazar la vista en la escena 3D.
#'
#' @details
#' Al presionar el botón indicado, la función registra la posición inicial del cursor
#' (*evento* `begin`). Durante el movimiento del ratón (*evento* `update`), calcula el
#' desplazamiento relativo y aplica una transformación de traslación sobre `userProjection`,
#' consiguiendo que la cámara se desplace en la dirección del arrastre, permitiendo mover
#' la escena libremente dentro de la ventana.
#'
#' @note El código original fue desarrollado por **Duncan Murdoch** y forma parte del
#' paquete **rgl**, donde no se exporta públicamente. Se incluye aquí sin modificaciones
#' para facilitar su uso dentro de este paquete.
#'
#' @author Duncan Murdoch
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
