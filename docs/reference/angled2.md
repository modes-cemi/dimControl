# Cálculo de ángulos direccionales de vectores normalizados

Calcula el ángulo direccional entre un conjunto de vectores normalizados
y una dirección de referencia en una dimensión específica. Permite
obtener el resultado en grados o radianes, y considerar la dirección
opuesta si se desea.

## Usage

``` r
angled2(v, dim, negdir = FALSE, deg = TRUE)
```

## Arguments

- v:

  Matriz numérica de dimensión \\d \times n\\. Cada columna representa
  un vector normalizado.

- dim:

  Entero que indica la dimensión de referencia, con \\1 \leq \text{dim}
  \leq d\\.

- negdir:

  Lógico. Si es `TRUE`, considera la dirección negativa (ángulo
  complementario).

- deg:

  Lógico. Si es `TRUE`, devuelve los ángulos en grados; si es `FALSE`,
  en radianes.

## Value

Un vector numérico con los ángulos correspondientes a cada vector de
entrada.

## Examples

``` r
# Tres vectores normalizados en las direcciones X, Y y Z
v <- matrix(c(1, 0, 0,
              0, 1, 0,
              0, 0, 1), nrow = 3)

# Ángulo respecto al eje X
angled2(v, dim = 1)
#> [1]  0 90 90

# Ángulo respecto al eje Y
angled2(v, dim = 2)
#> [1] 90  0 90

# Ángulo respecto al eje Z
angled2(v, dim = 3)
#> [1] 90 90  0
```
