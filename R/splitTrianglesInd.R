#' Split a Mesh into Connected Triangle Groups
#'
#' Splits the triangles of a 3D mesh into connected components. Two triangles are
#' considered connected when they share an edge, that is, two vertex indices.
#'
#' @param mesh A `mesh3d` object containing a triangular mesh. The object must include
#' the `it` matrix, where each column defines a triangle by three vertex indices.
#'
#' @returns
#' A list where each element contains the indices of the triangles belonging to one
#' connected component. Components are sorted from largest to smallest according to
#' their number of triangles.
#'
#' @details
#' The three edges of each triangle are represented as ordered vertex pairs and encoded
#' using numeric keys. Shared edges are identified by sorting these keys and are then
#' used to construct a graph in which triangles are vertices. Connected components are
#' obtained with [igraph::components()].
#'
#' Triangles sharing only one vertex are not considered connected.
#'
#' @seealso [igraph::make_graph()], [igraph::components()]
#'
#' @examples
#' \dontrun{
#' # Create a mesh with two disconnected components
#' vertices <- t(rbind(
#'   c(0, 0, 0),
#'   c(1, 0, 0),
#'   c(0, 1, 0),
#'   c(1, 1, 0),
#'   c(3, 0, 0),
#'   c(4, 0, 0),
#'   c(3, 1, 0)
#' ))
#'
#' triangles <- t(rbind(
#'   c(1, 2, 3),
#'   c(2, 4, 3),
#'   c(5, 6, 7)
#' ))
#'
#' mesh <- rgl::tmesh3d(
#'   vertices = vertices,
#'   indices = triangles
#' )
#'
#' # Split the mesh into connected triangle groups
#' groups <- splitTrianglesInd(mesh)
#' groups
#' }
#'
#' @importFrom igraph make_graph components
#'
#' @export
splitTrianglesInd <- function(mesh) {
  if (!"it" %in% names(mesh))
    stop("The mesh object is not a triangular mesh")

  tris <- t(mesh$it)
  nTri <- nrow(tris)

  if (nTri == 0)
    return(list())

  # Generate the three edges of each triangle
  edge1 <- tris[, c(1, 2), drop = FALSE]
  edge2 <- tris[, c(2, 3), drop = FALSE]
  edge3 <- tris[, c(1, 3), drop = FALSE]

  edges <- rbind(edge1, edge2, edge3)

  # Triangle associated with each edge
  triId <- rep.int(seq_len(nTri), 3L)

  # Store each undirected edge as an ordered vertex pair
  lowerVertex <- pmin(edges[, 1], edges[, 2])
  upperVertex <- pmax(edges[, 1], edges[, 2])

  # Encode each edge using a numeric key
  maxVertex <- max(tris)

  edgeKey <- as.double(lowerVertex) * (maxVertex + 1) + upperVertex

  # Sort edges so equal keys are adjacent
  edgeOrder <- order(edgeKey)

  sortedKey <- edgeKey[edgeOrder]
  sortedTri <- triId[edgeOrder]

  sameAsNext <- sortedKey[-length(sortedKey)] == sortedKey[-1]

  # No shared edges: every triangle is isolated
  if (!any(sameAsNext))
    return(as.list(seq_len(nTri)))

  sharedPositions <- which(sameAsNext)

  edgeMatrix <- cbind(sortedTri[sharedPositions], sortedTri[sharedPositions + 1L])

  # Remove self-connections that may arise from degenerate triangles
  edgeMatrix <- edgeMatrix[edgeMatrix[, 1] != edgeMatrix[, 2], , drop = FALSE]

  if (nrow(edgeMatrix) == 0)
    return(as.list(seq_len(nTri)))

  # Build graph with triangles as vertices
  graph <- igraph::make_graph(
    edges = as.vector(t(edgeMatrix)),
    n = nTri,
    directed = FALSE
  )

  components <- igraph::components(graph)

  # Triangle indices for each connected component
  groups <- split(seq_len(nTri), components$membership)

  # Sort components from largest to smallest
  groups[order(lengths(groups), decreasing = TRUE)]
}
