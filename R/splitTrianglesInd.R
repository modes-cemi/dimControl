#' Divide una malla en grupos de triángulos conectados
#'
#' Agrupa los triángulos de una malla 3D en subconjuntos independientes según su conectividad,
#' es decir, si comparten una arista (dos vértices). Cada componente conectada se
#' devuelve como un grupo de índices que corresponden a los triángulos pertenecientes
#' a una misma pieza o fragmento de la malla.
#'
#' Este procedimiento resulta útil cuando la malla contiene varias partes desconectadas
#' (por ejemplo, refuerzos, paneles o fragmentos separados) y se requiere tratarlas
#' por separado para análisis geométrico, representación o limpieza de datos.
#'
#' @param mesh Objeto de clase `mesh3d` que contiene la malla a analizar. Debe incluir
#' la matriz `it`, donde cada columna representa un triángulo definido por los índices
#' de sus vértices.
#'
#' @returns
#' Una lista donde cada elemento contiene los índices de los triángulos que forman
#' una componente conectada de la malla. Si no existen conexiones entre triángulos,
#' cada elemento de la lista corresponde a un único triángulo.
#'
#' @details
#' El algoritmo sigue los siguientes pasos:
#' \enumerate{
#'   \item Se valida que la malla contenga la matriz `it` con los triángulos.
#'   \item Para cada vértice, se registran los triángulos en los que aparece.
#'   \item Se determinan los pares de triángulos que comparten una arista (dos vértices comunes).
#'   \item Se construye un grafo no dirigido con los triángulos como nodos y las conexiones
#'         por aristas compartidas como enlaces.
#'   \item Se identifican las componentes conectadas del grafo mediante `igraph::components()`.
#' }
#'
#' @seealso `igraph::graph()`, `igraph::components()`
#'
#' @examples
#' \dontrun{
#' require(igraph)
#'
#' # Crear una malla mesh3d con dos triángulos desconectados
#' vb <- t(rbind(
#'   c(0, 0, 0),
#'   c(1, 0, 0),
#'   c(0, 1, 0),
#'   c(2, 0, 0),
#'   c(3, 0, 0),
#'   c(2, 1, 0)
#' ))
#' it <- t(rbind(
#'   c(1, 2, 3),
#'   c(4, 5, 6)
#' ))
#' mesh <- rgl::tmesh3d(vertices = vb, indices = it)
#'
#' # Dividir la malla en grupos de triángulos conectados
#' grupos <- splitTrianglesInd(mesh)
#' str(grupos)
#' }
#'
#' @importFrom igraph graph components
#'
#' @export
splitTrianglesInd <- function(mesh) {
  if (!"it" %in% names(mesh))
    stop("El objeto mesh no es una malla triangular.")

  tris  <- t(mesh$it)                 # cada fila = triángulo
  n_tri <- nrow(tris)

  # Lista de triángulos vecinos por vértice
  vert2tris <- vector("list", max(tris))
  for (i in seq_len(n_tri))
    for (v in tris[i, ])
      vert2tris[[v]] <- c(vert2tris[[v]], i)

  # Recopilar aristas (comparten 2 o más vértices)
  edge_list <- vector("list", 0)
  for (i in seq_len(n_tri)) {
    vecinos <- unique(unlist(vert2tris[tris[i, ]]))
    vecinos <- vecinos[vecinos > i]
    for (j in vecinos)
      if (length(intersect(tris[i, ], tris[j, ])) >= 2)
        edge_list[[length(edge_list) + 1]] <- c(i, j)
  }

  # Grafo con TODOS los triángulos como vértices
  if (length(edge_list) == 0)                 # todos aislados
    return(as.list(seq_len(n_tri)))

  edge_mat <- do.call(rbind, edge_list)       # matriz 2-columnas
  g <- igraph::graph(
    edges = as.vector(t(edge_mat)),           # vector c(v1,v2,v3,v4,.)
    n     = n_tri,
    directed = FALSE)

  comps <- igraph::components(g)

  # Lista de índices por componente conectada
  split(seq_len(n_tri), comps$membership)
}
