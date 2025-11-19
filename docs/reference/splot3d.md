# Barra de colores continua en 3D

Dibuja una barra de colores continua en una subescena 3D que acompaña a
una malla coloreada según valores numéricos, como las generadas con
`sshade3d()I`. Cada cubo de la barra representa un intervalo del rango
definido por `slim` y se colorea según la paleta `col`.

## Usage

``` r
splot3d(
  slim = c(0, 1),
  col = jet.colors(128),
  legend.zoom = 0.6,
  legend.width = 0.1,
  legend.mar = 0.2,
  legend.lab = NULL,
  box = TRUE,
  lab.breaks = NULL,
  lab.ticksize = 0.5,
  lab.dist = 2.5,
  ...
)
```

## Arguments

- slim:

  Vector numérico de longitud 2 que indica los valores mínimo y máximo
  de la escala de colores.

- col:

  Vector de colores que define la paleta utilizada en la leyenda.

- legend.zoom:

  Número que controla el nivel de zoom aplicado a la leyenda.

- legend.width:

  Número que define la anchura relativa de la barra de la leyenda.

- legend.mar:

  Número que establece la separación entre la malla principal y la
  leyenda.

- legend.lab:

  Vector de caracteres con las etiquetas de los ticks. Si es `NULL`, se
  generan automáticamente.

- box:

  Lógico. Si es `TRUE`, se dibuja un marco que delimita la barra de la
  leyenda.

- lab.breaks:

  Lógico o vector. Si es `TRUE`, las etiquetas de la escala se generan
  automáticamente. Si es un vector, se utiliza como etiquetas
  personalizadas para los ticks de la leyenda.

- lab.ticksize:

  Número que especifica la longitud de las marcas de los ticks.

- lab.dist:

  Número que determina la distancia de las etiquetas respecto a la
  barra.

- ...:

  Argumentos adicionales pasados a funciones de `rgl`.

## Value

Devuelve de forma invisible el identificador de la subescena creada para
la leyenda, permitiendo manipularla o eliminarla independientemente de
la escena principal.

## Details

Esta función utiliza una subescena de `rgl` para representar una leyenda
continua sin interferir con la malla principal. Para optimizar el
renderizado, se suspende temporalmente la actualización gráfica mientras
se genera la barra y luego se reactiva.

La barra se compone de una secuencia de cubos
([`rgl::cube3d()`](https://dmurdoch.github.io/rgl/dev/reference/cube3d.html))
coloreados con la paleta especificada y dispuestos a lo largo del eje Z.

Se emplea una versión modificada de
[`rgl::axis3d()`](https://dmurdoch.github.io/rgl/dev/reference/axes3d.html)
([`axis3()`](https://groupmodes.github.io/controlDim/reference/axis3.md))
que permite controlar la distancia de las etiquetas y la longitud de las
marcas mediante los parámetros `lab.dist` y `lab.ticksize`.

Algunas partes del comportamiento original de `rgl` relacionadas con la
actualización automática de la vista y la disposición de etiquetas se
han eliminado, con el fin de simplificar la representación y mantener
una apariencia limpia y controlada dentro del paquete `controlDim`.

## See also

[`sshade3d()`](https://groupmodes.github.io/controlDim/reference/sshade3d.md),
[`axis3()`](https://groupmodes.github.io/controlDim/reference/axis3.md)
