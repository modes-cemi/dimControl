#' Split a Mesh into Connected Triangle Groups
#'
#' Groups the triangles of a 3D mesh into independent subsets according to connectivity,
#' i.e., if they share an edge (two vertices). Each connected component is returned
#' as a group of indices corresponding to triangles belonging to the same piece or mesh fragment.
#'
#' This procedure is useful when the mesh contains multiple disconnected parts (e.g.,
#' reinforcements, panels, or separate fragments) and they need to be handled separately
#' for geometric analysis, visualization, or data cleaning.
#'
#' @param mesh A `mesh3d` object containing the mesh to analyze. It must include the
#' `it` matrix, where each column represents a triangle defined by the indices of its vertices.
#'
#' @returns
#' A list where each element contains the indices of triangles forming a connected
#' component of the mesh. If there are no connections between triangles, each list
#' element corresponds to a single triangle.
#'
#' @details
#' The algorithm follows these steps:
#' \enumerate{
#'   \item Checks that the mesh contains the `it` matrix with triangles.
#'   \item For each vertex, records the triangles in which it appears.
#'   \item Determines pairs of triangles that share an edge (two common vertices).
#'   \item Builds an undirected graph with triangles as nodes and shared-edge connections as edges.
#'   \item Identifies the connected components of the graph using `igraph::components()`.
#' }
#'
#' @seealso `igraph::graph()`, `igraph::components()`
#'
#' @examples
#' require(igraph)
#'
#' # Create a mesh3d object with two disconnected triangles
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
#' # Split the mesh into connected triangle groups
#' groups <- splitTrianglesInd(mesh)
#' str(groups)
#'
#' @importFrom igraph graph components
#'
#' @export
splitTrianglesInd <- function(mesh) {
  if (!"it" %in% names(mesh))
    stop("The mesh object is not a triangular mesh.")

  tris  <- t(mesh$it)                 # each row = triangle
  n_tri <- nrow(tris)

  # List of neighboring triangles per vertex
  vert2tris <- vector("list", max(tris))
  for (i in seq_len(n_tri))
    for (v in tris[i, ])
      vert2tris[[v]] <- c(vert2tris[[v]], i)

  # Collect edges (share 2 or more vertices)
  edge_list <- vector("list", 0)
  for (i in seq_len(n_tri)) {
    neighbors <- unique(unlist(vert2tris[tris[i, ]]))
    neighbors <- neighbors[neighbors > i]
    for (j in neighbors)
      if (length(intersect(tris[i, ], tris[j, ])) >= 2)
        edge_list[[length(edge_list) + 1]] <- c(i, j)
  }

  # Graph with all triangles as vertices
  if (length(edge_list) == 0)                 # all isolated
    return(as.list(seq_len(n_tri)))

  edge_mat <- do.call(rbind, edge_list)       # 2-column matrix
  g <- igraph::graph(
    edges = as.vector(t(edge_mat)),           # vector c(v1,v2,v3,v4,...)
    n     = n_tri,
    directed = FALSE)

  comps <- igraph::components(g)

  # List of indices per connected component
  split(seq_len(n_tri), comps$membership)
}
