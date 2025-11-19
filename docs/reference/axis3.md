# Ejes 3D con control de la distancia de etiquetas y longitud de marcas

Dibuja ejes 3D con opciones adicionales para ajustar la distancia de las
etiquetas respecto al eje y la longitud de las marcas (*ticks*). Esta
función extiende la funcionalidad de
[`rgl::axis3d()`](https://dmurdoch.github.io/rgl/dev/reference/axes3d.html),
ofreciendo un control más preciso sobre la apariencia de los ejes en
gráficos tridimensionales.

## Usage

``` r
axis3(
  edge,
  at = NULL,
  labels = TRUE,
  tick = TRUE,
  line = TRUE,
  pos = NULL,
  nticks = 5,
  ticksize = 0.05,
  labeldist = 3,
  ...
)
```

## Arguments

- edge:

  Carácter de longitud 3. Indica la orientación y signo del eje a
  dibujar.

- at:

  Vector numérico. Posiciones donde colocar las marcas del eje. Si es
  `NULL`, se calculan automáticamente.

- labels:

  Etiquetas de texto de las marcas. Si es `TRUE`, se generan a partir de
  `at`.

- tick:

  Lógico. Si es `TRUE` (por defecto), se dibujan las marcas del eje.

- line:

  Lógico. Si es `TRUE`, dibuja la línea del eje.

- pos:

  Posición donde se dibuja el eje o las etiquetas.

- nticks:

  Número sugerido de marcas si `at` es `NULL`.

- ticksize:

  Longitud de las marcas (*ticks*). Parámetro adicional respecto a
  [`rgl::axis3d()`](https://dmurdoch.github.io/rgl/dev/reference/axes3d.html).

- labeldist:

  Distancia entre las etiquetas y el eje. Parámetro adicional respecto a
  [`rgl::axis3d()`](https://dmurdoch.github.io/rgl/dev/reference/axes3d.html).

- ...:

  Argumentos adicionales pasados a
  [`rgl::text3d()`](https://dmurdoch.github.io/rgl/dev/reference/texts.html)
  o
  [`rgl::segments3d()`](https://dmurdoch.github.io/rgl/dev/reference/primitives.html).

## Value

Devuelve los identificadores de los objetos añadidos a la escena
(`object IDs`), de forma coherente con las funciones gráficas de `rgl`.

## Details

Modificación de
[`rgl::axis3d()`](https://dmurdoch.github.io/rgl/dev/reference/axes3d.html)
que permite controlar la posición de las etiquetas y la longitud de las
marcas mediante los nuevos parámetros `ticksize` y `labeldist`.

- `ticksize`: ajusta la longitud de las marcas del eje.

- `labeldist`: controla la distancia entre las etiquetas y el eje.

Estos parámetros son útiles cuando las etiquetas se solapan con la
geometría del modelo o se desea mejorar la legibilidad de la
representación.

## Note

La función se basa parcialmente en la implementación original de
[`rgl::axis3d()`](https://dmurdoch.github.io/rgl/dev/reference/axes3d.html)
desarrollada por Duncan Murdoch y el equipo de **rgl**. Esta versión ha
sido modificada en el paquete `controlDim` para proporcionar un mayor
control sobre el diseño gráfico.
