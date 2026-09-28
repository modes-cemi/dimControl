#' Reorder connected edge segments
#'
#' Reorders edge segments so that the end vertex of each segment matches the start
#' vertex of the next segment.
#'
#' @param edges Integer 2 x n matrix containing the edge segments, where each column
#' defines a segment by the indices of its two endpoint vertices.
#'
#' @returns
#' Integer 2 x n matrix containing the reordered segments. Segment orientation is
#' reversed when necessary to preserve connectivity. If no connected segment can be
#' found, only the connected sequence preceding the first gap is returned.
#'
#' @details
#' The first segment in `edges` is used as the starting segment. At each step, the
#' function searches among the unused segments for one sharing the endpoint of the
#' current segment.
#'
#' If the matching vertex corresponds to the second endpoint of the selected segment,
#' its orientation is reversed. The process continues until all connected segments
#' have been ordered or no additional connected segment can be found.
#'
#' @examples
#' edges <- matrix(
#'   c(
#'     1, 2,
#'     4, 3,
#'     2, 3,
#'     4, 5
#'   ),
#'   nrow = 2
#' )
#'
#' # Reorder connected segments
#' sortSegments(edges)
#'
#' @export
sortSegments <- function(edges) {

  # Validate the edge matrix
  if (!is.matrix(edges) || nrow(edges) != 2)
    stop("Argument 'edges' must be a matrix with two rows")

  # Total number of segments
  nEdges <- ncol(edges)

  # Return an empty matrix if there are no segments
  if (nEdges == 0)
    return(edges)

  # Store the segment sequence
  segmentOrder <- integer(nEdges)
  segmentOrder[1] <- 1

  for (i in seq_len(nEdges - 1)) {

    # Endpoint of the current segment
    endVertex <- edges[2, segmentOrder[i]]

    # Find unused segments connected to the current endpoint
    candidates <- setdiff(which(edges[1, ] == endVertex | edges[2, ] == endVertex), segmentOrder[seq_len(i)])

    # Stop if no connected segment is found
    if (length(candidates) == 0) break

    # Select the first connected segment
    nextSeg <- candidates[1]

    # Reverse segment orientation if necessary
    if (edges[1, nextSeg] != endVertex)
      edges[, nextSeg] <- edges[2:1, nextSeg]

    segmentOrder[i + 1] <- nextSeg
  }

  # Remove unused positions after a discontinuity
  segmentOrder <- segmentOrder[segmentOrder > 0]

  edges[, segmentOrder, drop = FALSE]
}
