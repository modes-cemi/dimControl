#' Reorder Connected Edge Segments
#'
#' Reorders the segments of a boundary (edges) so that each segment is connected to
#' the next one. This function is based on the idea of `getBoundary3d` from the `rgl`
#' package but has been modified to ensure the segment sequence is correct even when
#' the original boundary is not properly ordered.
#'
#' @param edges Numeric matrix with 2 rows and N columns, where each column represents
#' a boundary segment with its two endpoints. The first row contains the first vertex
#' of each segment, and the second row the second vertex.
#'
#' @returns A numeric matrix with 2 rows and N columns containing the segments reordered
#' so that each segment is connected to the next. If there are disconnected segments,
#' the sequence stops at the first gap.
#'
#' @export
sortSegments2 <- function(edges) {
  nedges <- ncol(edges)              # Total number of segments
  order <- integer(nedges)           # Vector to store the segment order
  order[1] <- 1                      # Start with the first segment

  for (i in seq_len(nedges - 1)) {
    vfin <- edges[2, order[i]]       # Endpoint of the current segment

    # Find candidates that have this point as start or end, excluding already ordered segments
    candidates <- setdiff(which(edges[1, ] == vfin | edges[2, ] == vfin), order[1:i])

    # If no candidates, stop the sequence
    if (length(candidates) == 0) break

    # Choose the first candidate
    next_seg <- candidates[1]

    # If the candidate has the point at its end, reverse it to connect properly
    if (edges[1, next_seg] != vfin)
      edges[, next_seg] <- edges[2:1, next_seg]

    # Store its position
    order[i + 1] <- next_seg
  }

  # Return reordered segments
  edges[, order, drop = FALSE]
}
