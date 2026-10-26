# Filter connected triangle components by minimum size

Selects connected components according to their number of triangles,
returning only the indices of the retained triangles.

## Usage

``` r
filterMeshComponents(comps, minSize = 1000)
```

## Arguments

- comps:

  List of integer vectors containing triangle indices, typically
  returned by
  [`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md).

- minSize:

  Minimum number of triangles required to retain a component. If `NULL`,
  all components are retained. Default is `1000`.

## Value

Integer vector containing the indices of the retained triangles.

## Examples

``` r
# Three connected components containing 5, 2 and 4 triangles
components <- list(1:5, 6:7, 8:11)

# Retain components with at least 4 triangles
filtered <- filterMeshComponents(comps = components, minSize = 4)

# Show retained triangle indices
filtered
#> [1]  1  2  3  4  5  8  9 10 11
```
