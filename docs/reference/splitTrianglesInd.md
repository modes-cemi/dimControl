# Split a Mesh into Connected Triangle Groups

Groups the triangles of a 3D mesh into independent subsets according to
connectivity, i.e., if they share an edge (two vertices). Each connected
component is returned as a group of indices corresponding to triangles
belonging to the same piece or mesh fragment.

## Usage

``` r
splitTrianglesInd(mesh)
```

## Arguments

- mesh:

  A `mesh3d` object containing the mesh to analyze. It must include the
  `it` matrix, where each column represents a triangle defined by the
  indices of its vertices.

## Value

A list where each element contains the indices of triangles forming a
connected component of the mesh. If there are no connections between
triangles, each list element corresponds to a single triangle.

## Details

This procedure is useful when the mesh contains multiple disconnected
parts (e.g., reinforcements, panels, or separate fragments) and they
need to be handled separately for geometric analysis, visualization, or
data cleaning.

The algorithm follows these steps:

1.  Checks that the mesh contains the `it` matrix with triangles.

2.  For each vertex, records the triangles in which it appears.

3.  Determines pairs of triangles that share an edge (two common
    vertices).

4.  Builds an undirected graph with triangles as nodes and shared-edge
    connections as edges.

5.  Identifies the connected components of the graph using
    [`igraph::components()`](https://r.igraph.org/reference/components.html).

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
mesh <- rgl::tmesh3d(vertices = vb, indices = it)

# Split the mesh into connected triangle groups
groups <- splitTrianglesInd(mesh)
str(groups)
#> List of 2
#>  $ : int 1
#>  $ : int 2
```
