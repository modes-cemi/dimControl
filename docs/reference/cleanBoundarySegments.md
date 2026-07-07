# Clean and Reconnect Boundary Segments of a 3D Mesh

Cleans a set of boundary segments previously extracted from a `mesh3d`
object. The function removes redundant connections at vertices with
degree greater than two, filters abnormally long segments, removes small
connected groups of segments, reconnects disconnected endpoints using
the nearest neighbor and retains only the main connected boundary.

## Usage

``` r
cleanBoundarySegments(
  iborde,
  base_mesh,
  length_prob = 0.98,
  min_group_size = 20
)
```

## Arguments

- iborde:

  A two-row matrix containing the boundary segment indices, where each
  column represents a segment defined by the indices of its two
  vertices.

- base_mesh:

  A `mesh3d` object containing the mesh geometry to which the boundary
  segments belong.

- length_prob:

  A numeric value between 0 and 1 defining the percentile used to
  identify and remove abnormally long boundary segments. Default is
  `0.98`.

- min_group_size:

  Minimum number of segments required for a connected component to be
  retained. Smaller groups are removed. Default is `20`.

## Value

A two-row matrix containing the indices of the cleaned and reconnected
boundary segments.

## See also

[`getBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/getBoundarySegments.md)
