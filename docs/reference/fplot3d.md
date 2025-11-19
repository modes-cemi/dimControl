# Leyenda categórica en 3D

Representa una leyenda de categorías en una subescena lateral de una
ventana 3D de `rgl`. Cada categoría se muestra como una esfera coloreada
acompañada de su etiqueta. Resulta útil para acompañar representaciones
creadas con
[`fshade3d()`](https://groupmodes.github.io/controlDim/reference/fshade3d.md).

## Usage

``` r
fplot3d(
  labels,
  col = seq_along(labels),
  legend.zoom = 0.6,
  legend.width = 0.1,
  legend.mar = 0.2,
  lab.dist = 2.5,
  lab.rev = FALSE,
  ...
)
```

## Arguments

- labels:

  Vector de texto con las etiquetas de las categorías.

- col:

  Vector de colores correspondiente a cada categoría.

- legend.zoom:

  Número. Controla el nivel de zoom de la leyenda.

- legend.width:

  Número. Ancho relativo de las esferas de color.

- legend.mar:

  Número. Proporción del espacio horizontal reservado para la leyenda.

- lab.dist:

  Número. Distancia entre las etiquetas y las esferas.

- lab.rev:

  Lógico. Si es `TRUE`, invierte el orden vertical de las etiquetas.

- ...:

  Argumentos adicionales que se pasan a
  [`axis3()`](https://groupmodes.github.io/controlDim/reference/axis3.md).

## Value

Devuelve invisiblemente el identificador de la subescena creada, que
puede utilizarse para modificar o actualizar la leyenda.

## Details

La función crea una disposición de subescenas mediante
[`rgl::layout3d()`](https://dmurdoch.github.io/rgl/dev/reference/mfrow3d.html),
reservando una franja lateral para la leyenda. Los símbolos se dibujan
con
[`rgl::spheres3d()`](https://dmurdoch.github.io/rgl/dev/reference/spheres.html)
y las etiquetas con
[`axis3()`](https://groupmodes.github.io/controlDim/reference/axis3.md),
una versión modificada que permite ajustar la distancia y el formato de
las etiquetas.

La leyenda se orienta verticalmente a lo largo del eje Z y se representa
en una subescena independiente, lo que permite modificarla sin afectar
la vista principal.

## See also

[`fshade3d()`](https://groupmodes.github.io/controlDim/reference/fshade3d.md),
[`splot3d()`](https://groupmodes.github.io/controlDim/reference/splot3d.md),
[`rgl::layout3d()`](https://dmurdoch.github.io/rgl/dev/reference/mfrow3d.html),
[`rgl::spheres3d()`](https://dmurdoch.github.io/rgl/dev/reference/spheres.html),
[`axis3()`](https://groupmodes.github.io/controlDim/reference/axis3.md)
