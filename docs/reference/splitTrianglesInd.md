# Split a Mesh into Connected Triangle Groups

Splits the triangles of a 3D mesh into connected components. Two
triangles are considered connected when they share an edge, that is, two
vertex indices.

## Usage

``` r
splitTrianglesInd(mesh)
```

## Arguments

- mesh:

  A `mesh3d` object containing a triangular mesh. The object must
  include the `it` matrix, where each column defines a triangle by three
  vertex indices.

## Value

A list where each element contains the indices of the triangles
belonging to one connected component. Components are sorted from largest
to smallest according to their number of triangles.

## Details

The three edges of each triangle are represented as ordered vertex pairs
and encoded using numeric keys. Shared edges are identified by sorting
these keys and are then used to construct a graph in which triangles are
vertices. Connected components are obtained with
[`igraph::components()`](https://r.igraph.org/reference/components.html).

Triangles sharing only one vertex are not considered connected.

## See also

[`igraph::make_graph()`](https://r.igraph.org/reference/make_graph.html),
[`igraph::components()`](https://r.igraph.org/reference/components.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a mesh with two disconnected components
vertices <- t(rbind(
  c(0, 0, 0),
  c(1, 0, 0),
  c(0, 1, 0),
  c(1, 1, 0),
  c(3, 0, 0),
  c(4, 0, 0),
  c(3, 1, 0)
))

triangles <- t(rbind(
  c(1, 2, 3),
  c(2, 4, 3),
  c(5, 6, 7)
))

mesh <- rgl::tmesh3d(
  vertices = vertices,
  indices = triangles
)

# Split the mesh into connected triangle groups
groups <- splitTrianglesInd(mesh)
groups
} # }
```
