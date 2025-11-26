# Reorder Connected Edge Segments

Reorders the segments of a boundary (edges) so that each segment is
connected to the next one. This function is based on the idea of
`getBoundary3d` from the `rgl` package but has been modified to ensure
the segment sequence is correct even when the original boundary is not
properly ordered.

## Usage

``` r
sortSegments2(edges)
```

## Arguments

- edges:

  Numeric matrix with 2 rows and N columns, where each column represents
  a boundary segment with its two endpoints. The first row contains the
  first vertex of each segment, and the second row the second vertex.

## Value

A numeric matrix with 2 rows and N columns containing the segments
reordered so that each segment is connected to the next. If there are
disconnected segments, the sequence stops at the first gap.
