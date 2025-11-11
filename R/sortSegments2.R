#' Reordenar segmentos conectados de un borde
#'
#' Esta función reordena los segmentos de un borde (aristas) de manera que cada segmento
#' esté conectado al siguiente. Se basa en la idea de la función `getBoundary3d` del paquete
#' `rgl`, pero ha sido modificada para asegurar que la secuencia de segmentos sea correcta
#' en casos donde el borde original no estaba ordenado adecuadamente.
#'
#' @param edges Matriz numérica de 2 filas y N columnas, donde cada columna representa
#'   un segmento del borde con sus dos extremos. La primera fila contiene el primer vértice
#'   de cada segmento y la segunda fila el segundo vértice.
#'
#' @returns Matriz de 2 filas y N columnas con los segmentos reordenados de forma que cada
#'   segmento esté conectado al siguiente. Si hay segmentos desconectados, la secuencia
#'   se interrumpe en el primer hueco.
#'
#' @export
sortSegments2 <- function(edges) {
  nedges <- ncol(edges)              # Número total de segmentos
  order <- integer(nedges)           # Vector para almacenar el orden de los segmentos
  order[1] <- 1                      # Empieza por el primer segmento

  for (i in seq_len(nedges - 1)) {
    vfin <- edges[2, order[i]]       # Punto final del segmento actual

    # Buscar candidatos que tengan ese punto como inicio o final, excluyendo los ya ordenados
    candidatos <- setdiff(which(edges[1, ] == vfin | edges[2, ] == vfin), order[1:i])

    # Si no hay candidatos, se interrumpe la secuencia
    if (length(candidatos) == 0) break

    # Elegimos el primer candidato
    siguiente <- candidatos[1]

    # Si el candidato tiene ese punto en su posición final, se invierte para conectar correctamente
    if (edges[1, siguiente] != vfin)
      edges[, siguiente] <- edges[2:1, siguiente]

    # Guardar su posición
    order[i + 1] <- siguiente
  }

  # Segmentos reordenados
  edges[, order, drop = FALSE]
}
