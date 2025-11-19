# Extrae el borde de una malla tridimensional

Identifica los bordes no compartidos de una malla 3D, es decir, aquellos
que pertenecen a una sola cara. Estos bordes pueden devolverse como
índices de los vértices frontera o como una malla `mesh3d` formada por
los segmentos correspondientes.

## Usage

``` r
getBoundarySegments3(mesh, malla = FALSE, simplify = TRUE)
```

## Arguments

- mesh:

  Objeto de clase `mesh3d` que representa la malla 3D.

- malla:

  Lógico. Si es `TRUE`, devuelve un objeto `mesh3d` que contiene los
  segmentos frontera; si es `FALSE`, devuelve únicamente los índices de
  los vértices que forman los bordes frontera. Por defecto es `FALSE`.

- simplify:

  Lógico. Si es `TRUE` y `malla = TRUE`, simplifica la malla resultante
  mediante
  [`cleanMesh3d_rgl()`](https://groupmodes.github.io/controlDim/reference/cleanMesh3d_rgl.md).
  Por defecto es `TRUE`.

## Value

Si `malla = FALSE`, devuelve una matriz con los índices de los vértices
que forman los bordes frontera. Si `malla = TRUE`, devuelve una malla de
tipo `mesh3d` formada por dichos bordes.

## Details

Esta función es una adaptación de `getBoundary3d()` del paquete `rgl`. A
diferencia de la versión original, que identifica los bordes frontera
mediante la detección de duplicados en las aristas, esta implementación
utiliza una tabla de frecuencias (`data.table`) para contabilizar
cuántas veces aparece cada borde en las caras de la malla. Los bordes
que aparecen una sola vez se consideran frontera. Además, se añade la
opción de devolver los índices de los vértices frontera o una malla
`mesh3d` con los segmentos correspondientes, con la posibilidad de
aplicar una simplificación adicional.

## See also

[`rgl::getBoundary3d()`](https://dmurdoch.github.io/rgl/dev/reference/getBoundary3d.html),
[`cleanMesh3d_rgl()`](https://groupmodes.github.io/controlDim/reference/cleanMesh3d_rgl.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Obtener el borde de un cubo y representarlo
require(data.table)

# Crear un cubo y eliminar dos caras
x <- rgl::cube3d(col = "lightblue")
x$ib <- x$ib[, -(1:2)]

# Generar el borde
b <- getBoundarySegments3(x, malla = TRUE)

# Representar la malla y su borde
rgl::open3d()
rgl::shade3d(x, alpha = 0.2)
rgl::shade3d(b, col = "red", lwd = 2)
} # }
```
