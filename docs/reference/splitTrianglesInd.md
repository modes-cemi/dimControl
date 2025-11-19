# Divide una malla en grupos de triángulos conectados

Agrupa los triángulos de una malla 3D en subconjuntos independientes
según su conectividad, es decir, si comparten una arista (dos vértices).
Cada componente conectada se devuelve como un grupo de índices que
corresponden a los triángulos pertenecientes a una misma pieza o
fragmento de la malla.

## Usage

``` r
splitTrianglesInd(mesh)
```

## Arguments

- mesh:

  Objeto de clase `mesh3d` que contiene la malla a analizar. Debe
  incluir la matriz `it`, donde cada columna representa un triángulo
  definido por los índices de sus vértices.

## Value

Una lista donde cada elemento contiene los índices de los triángulos que
forman una componente conectada de la malla. Si no existen conexiones
entre triángulos, cada elemento de la lista corresponde a un único
triángulo.

## Details

Este procedimiento resulta útil cuando la malla contiene varias partes
desconectadas (por ejemplo, refuerzos, paneles o fragmentos separados) y
se requiere tratarlas por separado para análisis geométrico,
representación o limpieza de datos.

El algoritmo sigue los siguientes pasos:

1.  Se valida que la malla contenga la matriz `it` con los triángulos.

2.  Para cada vértice, se registran los triángulos en los que aparece.

3.  Se determinan los pares de triángulos que comparten una arista (dos
    vértices comunes).

4.  Se construye un grafo no dirigido con los triángulos como nodos y
    las conexiones por aristas compartidas como enlaces.

5.  Se identifican las componentes conectadas del grafo mediante
    [`igraph::components()`](https://r.igraph.org/reference/components.html).

## See also

[`igraph::graph()`](https://r.igraph.org/reference/graph.html),
[`igraph::components()`](https://r.igraph.org/reference/components.html)

## Examples

``` r
if (FALSE) { # \dontrun{
require(igraph)

# Crear una malla mesh3d con dos triángulos desconectados
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

# Dividir la malla en grupos de triángulos conectados
grupos <- splitTrianglesInd(mesh)
str(grupos)
} # }
```
