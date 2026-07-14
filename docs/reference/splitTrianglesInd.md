# Split a Mesh into Connected Triangle Groups

Groups the triangles of a 3D mesh into independent subsets according to
connectivity. Two triangles are considered connected when they share an
edge, that is, two vertex indices. Each connected component is returned
as a group of triangle indices belonging to the same mesh fragment.

## Usage

``` r
splitTrianglesInd(mesh)
```

## Arguments

- mesh:

  A `mesh3d` object containing the mesh to analyze. It must include the
  `it` matrix, where each column represents a triangle defined by three
  vertex indices.

## Value

A list where each element contains the indices of the triangles forming
one connected component. Components are sorted from largest to smallest
according to their number of triangles. If no triangles share an edge,
each list element contains the index of a single triangle.

## Details

The implementation generates the three edges of every triangle, encodes
each undirected edge using a numeric key and identifies shared edges
through a vectorized sorting operation. This avoids repeated pairwise
intersection calculations and improves performance on large meshes.

The algorithm follows these steps:

1.  Checks that the mesh contains the `it` matrix.

2.  Generates the three edges of every triangle.

3.  Represents each edge as an ordered pair of vertex indices.

4.  Encodes each edge using a numeric key so that the same undirected
    edge receives the same value regardless of vertex order.

5.  Sorts the edge keys to identify triangles that share an edge.

6.  Builds an undirected graph in which triangles are vertices and
    shared edges define graph connections.

7.  Identifies the connected components using
    [`igraph::components()`](https://r.igraph.org/reference/components.html).

8.  Sorts the resulting components from largest to smallest.

Triangles that share only one vertex are not considered connected. The
connectivity criterion therefore corresponds specifically to edge
connectivity.

## See also

[`igraph::graph()`](https://r.igraph.org/reference/graph.html),
[`igraph::components()`](https://r.igraph.org/reference/components.html)

## Examples

``` r
require(igraph)
#> Loading required package: igraph
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union

# Create a mesh3d object with two disconnected triangles
vb <- t(rbind(
  c(0, 0, 0),
  c(1, 0, 0),
  c(0, 1, 0),
  c(2, 0, 0),
  c(3, 0, 0),
  c(2, 1, 0)
))

it <- t(rbind(
  c(1, 2, 3),
  c(4, 5, 6)
))

mesh <- rgl::tmesh3d(
  vertices = vb,
  indices = it
)

# Split the mesh into connected triangle groups
groups <- splitTrianglesInd(mesh)
str(groups)
#> List of 2
#>  $ : int 1
#>  $ : int 2
```
