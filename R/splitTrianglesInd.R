#' Split a Mesh into Connected Triangle Groups
#'
#' Groups the triangles of a 3D mesh into independent subsets according to
#' connectivity. Two triangles are considered connected when they share an edge,
#' that is, two vertex indices. Each connected component is returned as a group
#' of triangle indices belonging to the same mesh fragment.
#'
#' The implementation generates the three edges of every triangle, encodes each
#' undirected edge using a numeric key and identifies shared edges through a
#' vectorized sorting operation. This avoids repeated pairwise intersection
#' calculations and improves performance on large meshes.
#'
#' @param mesh A `mesh3d` object containing the mesh to analyze. It must include
#' the `it` matrix, where each column represents a triangle defined by three
#' vertex indices.
#'
#' @returns A list where each element contains the indices of the triangles
#' forming one connected component. Components are sorted from largest to
#' smallest according to their number of triangles. If no triangles share an
#' edge, each list element contains the index of a single triangle.
#'
#' @details
#' The algorithm follows these steps:
#' \enumerate{
#'   \item Checks that the mesh contains the `it` matrix.
#'   \item Generates the three edges of every triangle.
#'   \item Represents each edge as an ordered pair of vertex indices.
#'   \item Encodes each edge using a numeric key so that the same undirected edge
#'   receives the same value regardless of vertex order.
#'   \item Sorts the edge keys to identify triangles that share an edge.
#'   \item Builds an undirected graph in which triangles are vertices and shared
#'   edges define graph connections.
#'   \item Identifies the connected components using `igraph::components()`.
#'   \item Sorts the resulting components from largest to smallest.
#' }
#'
#' Triangles that share only one vertex are not considered connected. The
#' connectivity criterion therefore corresponds specifically to edge
#' connectivity.
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
#'
#' it <- t(rbind(
#'   c(1, 2, 3),
#'   c(4, 5, 6)
#' ))
#'
#' mesh <- rgl::tmesh3d(
#'   vertices = vb,
#'   indices = it
#' )
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

  tris <- t(mesh$it)
  n_tri <- nrow(tris)

  if (n_tri == 0)
    return(list())

  # Generate the three edges of each triangle
  edge_1 <- tris[, c(1, 2), drop = FALSE]
  edge_2 <- tris[, c(2, 3), drop = FALSE]
  edge_3 <- tris[, c(1, 3), drop = FALSE]

  edges <- rbind(edge_1, edge_2, edge_3)

  # Triangle associated with each edge
  tri_id <- rep.int(seq_len(n_tri), 3L)

  # Store each undirected edge as an ordered vertex pair
  lower_vertex <- pmin(edges[, 1], edges[, 2])
  upper_vertex <- pmax(edges[, 1], edges[, 2])

  # Encode each edge using a numeric key
  max_vertex <- max(tris)

  edge_key <- as.double(lower_vertex) * (max_vertex + 1) +
    upper_vertex

  # Sort edges so equal keys are adjacent
  edge_order <- order(edge_key)

  sorted_key <- edge_key[edge_order]
  sorted_tri <- tri_id[edge_order]

  same_as_next <- sorted_key[-length(sorted_key)] ==
    sorted_key[-1]

  # No shared edges: every triangle is isolated
  if (!any(same_as_next))
    return(as.list(seq_len(n_tri)))

  shared_positions <- which(same_as_next)

  edge_matrix <- cbind(
    sorted_tri[shared_positions],
    sorted_tri[shared_positions + 1L]
  )

  # Remove self-connections that may arise from degenerate triangles
  edge_matrix <- edge_matrix[
    edge_matrix[, 1] != edge_matrix[, 2],
    ,
    drop = FALSE
  ]

  if (nrow(edge_matrix) == 0)
    return(as.list(seq_len(n_tri)))

  # Build graph with triangles as vertices
  graph <- igraph::graph(
    edges = as.vector(t(edge_matrix)),
    n = n_tri,
    directed = FALSE
  )

  components <- igraph::components(graph)

  # Triangle indices for each connected component
  groups <- split(
    seq_len(n_tri),
    components$membership
  )

  # Sort components from largest to smallest
  groups[order(lengths(groups), decreasing = TRUE)]
}
