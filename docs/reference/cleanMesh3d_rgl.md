# Limpieza de una malla 3D

Elimina vértices no usados o no finitos y actualiza los índices de las
caras en un objeto de clase `mesh3d`.

## Usage

``` r
cleanMesh3d_rgl(mesh, onlyFinite = TRUE, allUsed = TRUE)
```

## Arguments

- mesh:

  Objeto `mesh3d` que representa la malla a limpiar.

- onlyFinite:

  Lógico. Si es `TRUE` (por defecto), elimina vértices con coordenadas
  no finitas.

- allUsed:

  Lógico. Si es `TRUE` (por defecto), elimina vértices que no están
  referenciados por ninguna cara.

## Value

Objeto `mesh3d` limpio, con los vértices e índices de las caras
actualizados.

## Details

Esta función es una versión simplificada de `rgl::cleanMesh3d()`,
adaptada para tareas básicas de depuración de mallas.

Esta función está basada en `rgl::cleanMesh3d()` (D. Murdoch, 2024),
pero se han eliminado elementos no necesarios para las operaciones de
limpieza estructural, como la gestión de etiquetas (`tags`), texturas,
normales o colores de vértices, así como el parámetro `rejoin`.

El objetivo es conservar únicamente la funcionalidad esencial:

- Eliminación de vértices con valores no finitos (`NA`, `NaN`, `Inf`)
  cuando `onlyFinite = TRUE`.

- Eliminación de vértices no usados en ninguna cara cuando
  `allUsed = TRUE`.

- Reindexación automática de las matrices de caras (`ip`, `is`, `it`,
  `ib`) tras la limpieza.

## References

Murdoch, D. (2024). *rgl: 3D Visualization Using OpenGL*. R package
version correspondiente. URL: <https://CRAN.R-project.org/package=rgl>

## Author

Duncan Murdoch

## Examples

``` r
# Crear un cubo
cubo <- rgl::cube3d()

# Añadir vértice no referenciado
cubo$vb <- cbind(cubo$vb, c(10,10,10,1))

# Limpiar el cubo
cubo_clean <- cleanMesh3d_rgl(cubo)

# Comparar número de vértices
dim(cubo$vb)
#> [1] 4 9
dim(cubo_clean$vb)
#> [1] 4 8
```
