# Calcular los límites espaciales (bounding box) de una malla 3D

Determina las coordenadas mínimas y máximas de los vértices de una malla
3D, devolviendo una matriz con los valores extremos en los ejes `X`, `Y`
y `Z`.

## Usage

``` r
bbox(x)
```

## Arguments

- x:

  Objeto de clase `mesh3d` que contiene los vértices de la malla en el
  componente `vb`.

## Value

Una matriz de 3 filas y 2 columnas con los valores mínimos y máximos de
las coordenadas de los vértices:

- Cada fila corresponde a un eje (`x`, `y`, `z`).

- La primera columna (`min`) contiene los valores mínimos.

- La segunda columna (`max`) contiene los valores máximos.

## Details

Internamente, la función convierte las coordenadas homogéneas de `x$vb`
en coordenadas euclidianas mediante
[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)
y calcula los rangos por eje con `apply(..., range)`.

## See also

[`rgl::asEuclidean2()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)

## Examples

``` r
# Crear una malla cúbica
cube <- rgl::cube3d()

# Calcular su bounding box
bbox(cube)
#>   min max
#> x  -1   1
#> y  -1   1
#> z  -1   1
```
