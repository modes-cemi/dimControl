#' Reorder Connected Edge Segments
#'
#' Reorders boundary segments so that the end vertex of each segment matches the start
#' vertex of the next one.
#'
#' @param edges A matrix with 2 rows and N columns, where each column represents a
#' segment defined by the indices of its two endpoint vertices.
#'
#' @returns
#' A matrix containing the reordered segments. Segment orientation is reversed when
#' necessary to preserve connectivity. If no connected segment can be found, the sequence
#' stops at the first gap.
#'
#' @details
#' The first segment in `edges` is used as the starting segment. At each step, the
#' function searches for an unused segment sharing the current endpoint. If the matching
#' vertex is the second endpoint of the candidate segment, its orientation is reversed.
#'
#' @examples
#' \dontrun{
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
#' sortSegments(edges)
#' }
#'
#' @export
sortSegments <- function(edges) {

  # Total number of segments
  nEdges <- ncol(edges)

  # Store the segment sequence
  segmentOrder <- integer(nEdges)
  segmentOrder[1] <- 1

  for (i in seq_len(nEdges - 1)) {

    # Endpoint of the current segment
    endVertex <- edges[2, segmentOrder[i]]

    # Find unused segments connected to the current endpoint
    candidates <- setdiff(which(edges[1, ] == endVertex | edges[2, ] == endVertex), segmentOrder[1:i])

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
