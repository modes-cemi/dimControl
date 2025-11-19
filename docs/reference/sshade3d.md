# Representa una superficie 3D coloreada con leyenda

Combina la representación de una malla tridimensional con el color
asociado a los valores de una variable escalar y añade una leyenda
lateral que indica el rango de valores representados. Utiliza
[`splot3d()`](https://groupmodes.github.io/controlDim/reference/splot3d.md)
para generar la leyenda y los ejes, y
[`npsp::scolor()`](http://rubenfcasal.github.io/npsp/reference/splot.md)
para asignar colores a los triángulos o vértices de la malla.

## Usage

``` r
sshade3d(
  x,
  s,
  meshColor = c("faces", "facesvertices", "vertices"),
  slim = range(s, finite = TRUE),
  col = jet.colors(128),
  legend.zoom = 0.4,
  legend.width = 0.1,
  legend.mar = 0.15,
  legend.lab = NULL,
  box = TRUE,
  lab.breaks = NULL,
  lab.ticksize = 0.5,
  lab.dist = 3,
  add = FALSE,
  ...
)
```

## Arguments

- x:

  Objeto de clase `mesh3d` que define la malla a representar.

- s:

  Vector numérico con los valores escalares asociados a los vértices o
  caras de la malla.

- meshColor:

  Tipo de coloración de la malla. Puede ser:

  - `"faces"`: colorea cada triángulo con el valor medio de sus
    vértices.

  - `"facesvertices"`: interpola colores en las caras según los
    vértices.

  - `"vertices"`: colorea directamente los vértices.

- slim:

  Rango de valores de `s` utilizado para escalar los colores. Por
  defecto, `range(s, finite = TRUE)`.

- col:

  Paleta de colores utilizada. Por defecto, `npsp::jet.colors(128)`.

- legend.zoom:

  Factor de escala del tamaño de la leyenda. Por defecto, `0.4`.

- legend.width:

  Ancho relativo de la leyenda. Por defecto, `0.1`.

- legend.mar:

  Margen entre la leyenda y la superficie. Por defecto, `0.15`.

- legend.lab:

  Texto de la etiqueta de la leyenda. Si es `NULL`, no se muestra.

- box:

  Lógico que indica si se dibuja la caja de los ejes. Por defecto,
  `TRUE`.

- lab.breaks:

  Vector con las posiciones de las marcas de graduación de la leyenda.

- lab.ticksize:

  Tamaño de las marcas de la leyenda. Por defecto, `0.5`.

- lab.dist:

  Distancia entre las etiquetas de la leyenda y las marcas. Por defecto,
  `3`.

- add:

  Si es `TRUE`, añade la superficie al gráfico 3D actual sin crear una
  nueva leyenda.

- ...:

  Argumentos adicionales pasados a
  [`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html).

## Value

No devuelve ningún valor. Su efecto es generar la representación
tridimensional coloreada de la malla junto con su leyenda.

## Details

La función colorea la malla 3D de acuerdo con los valores de `s`
utilizando la paleta especificada en `col`. El color puede asignarse por
vértices o por caras, en función de `meshColor`. Posteriormente, se
genera la representación tridimensional mediante
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html)
y se añade una leyenda lateral mediante
[`splot3d()`](https://groupmodes.github.io/controlDim/reference/splot3d.md).

## See also

[`axis3()`](https://groupmodes.github.io/controlDim/reference/axis3.md),
[`splot3d()`](https://groupmodes.github.io/controlDim/reference/splot3d.md)
para funciones internas de representación;
[`npsp::scolor()`](http://rubenfcasal.github.io/npsp/reference/splot.md),
[`npsp::jet.colors()`](http://rubenfcasal.github.io/npsp/reference/splot.md)
para el mapeo de color.

## Examples

``` r
if (FALSE) { # \dontrun{
# Generar una superficie 3D (dataset `volcano`)
z <- 2 * volcano                 # Aumentar el relieve
x <- 10 * (seq_len(nrow(z)) - 1) # Espaciado de 10 m (S a N)
y <- 10 * (seq_len(ncol(z)) - 1) # Espaciado de 10 m (E a W)
rgl::surface3d(x, y, z, back = "lines")
mesh <- rgl::as.mesh3d()
mesh$meshColor <- "faces"

# Representar la superficie coloreada por altura con leyenda
rgl::open3d()
sshade3d(mesh, mesh$vb[3, ], meshColor = "facesvertices", lit = FALSE)
} # }
```
