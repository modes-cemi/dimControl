# Reorder Connected Edge Segments

Reorders boundary segments so that the end vertex of each segment
matches the start vertex of the next one.

## Usage

``` r
sortSegments(edges)
```

## Arguments

- edges:

  A matrix with 2 rows and N columns, where each column represents a
  segment defined by the indices of its two endpoint vertices.

## Value

A matrix containing the reordered segments. Segment orientation is
reversed when necessary to preserve connectivity. If no connected
segment can be found, the sequence stops at the first gap.

## Details

The first segment in `edges` is used as the starting segment. At each
step, the function searches for an unused segment sharing the current
endpoint. If the matching vertex is the second endpoint of the candidate
segment, its orientation is reversed.

## Examples

``` r
if (FALSE) { # \dontrun{
edges <- matrix(
  c(
    1, 2,
    4, 3,
    2, 3,
    4, 5
  ),
  nrow = 2
)

sortSegments(edges)
} # }
```
