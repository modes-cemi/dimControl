# Calcular la distancia euclidiana entre dos puntos

Calcula la distancia lineal (euclidiana) a partir de un vector de
diferencias entre las coordenadas de dos puntos.

## Usage

``` r
deuclid(h)
```

## Arguments

- h:

  Vector numérico que contiene las diferencias entre las coordenadas de
  dos puntos (por ejemplo, `c(x2 - x1, y2 - y1, z2 - z1)`).

## Value

Un valor numérico que representa la distancia euclidiana entre los dos
puntos.

## Details

Esta función aplica la fórmula clásica de la distancia euclidiana: \$\$d
= \sqrt{\sum_i (h_i)^2}\$\$, donde \\h_i\\ representa la diferencia en
cada coordenada.

## Examples

``` r
# Diferencia entre dos puntos en 3D
h <- c(3 - 0, 4 - 0, 0 - 0)

# Calcular la distancia euclidiana
deuclid(h)
#> [1] 5
```
