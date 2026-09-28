# Reorder connected edge segments

Reorders edge segments so that the end vertex of each segment matches
the start vertex of the next segment.

## Usage

``` r
sortSegments(edges)
```

## Arguments

- edges:

  Integer 2 x n matrix containing the edge segments, where each column
  defines a segment by the indices of its two endpoint vertices.

## Value

Integer 2 x n matrix containing the reordered segments. Segment
orientation is reversed when necessary to preserve connectivity. If no
connected segment can be found, only the connected sequence preceding
the first gap is returned.

## Details

The first segment in `edges` is used as the starting segment. At each
step, the function searches among the unused segments for one sharing
the endpoint of the current segment.

If the matching vertex corresponds to the second endpoint of the
selected segment, its orientation is reversed. The process continues
until all connected segments have been ordered or no additional
connected segment can be found.

## Examples

``` r
edges <- matrix(
  c(
    1, 2,
    4, 3,
    2, 3,
    4, 5
  ),
  nrow = 2
)

# Reorder connected segments
sortSegments(edges)
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    2    3    4
#> [2,]    2    3    4    5
```
