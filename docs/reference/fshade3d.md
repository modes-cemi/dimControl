# Representación 3D con colores categóricos

Aplica una escala de color categórica a una malla tridimensional según
un factor y, opcionalmente, muestra una leyenda asociada a las
categorías. Es una extensión de
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html)
que permite representar grupos o clases discretas sobre una superficie
3D.

## Usage

``` r
fshade3d(
  x,
  f,
  meshColor = c("faces", "vertices"),
  legend.lab = levels(f),
  col = col.pal(length(legend.lab)),
  col.pal = cat.colors,
  legend.zoom = 1,
  legend.width = 0.1,
  legend.mar = 0.15,
  lab.dist = 3,
  lab.rev = FALSE,
  add = FALSE,
  ...
)
```

## Arguments

- x:

  Objeto de tipo `mesh3d`. Malla tridimensional que se desea colorear.

- f:

  Factor o vector que indica la categoría asignada a cada cara o vértice
  de la malla, dependiendo del modo definido en `meshColor`.

- meshColor:

  Cadena de texto. Especifica cómo se aplica el color:

  - `"faces"`: el color se asigna por cara (valor por defecto).

  - `"vertices"`: el color se asigna por vértice.

- legend.lab:

  Vector de caracteres. Etiquetas mostradas en la leyenda. Por defecto,
  `levels(f)`.

- col:

  Vector de colores. Paleta utilizada para colorear las categorías. Si
  se omite, se genera automáticamente mediante `col.pal`.

- col.pal:

  Función generadora de paletas de colores categóricos. Por defecto,
  `cat.colors`.

- legend.zoom:

  Número. Nivel de zoom aplicado a la leyenda.

- legend.width:

  Número. Anchura relativa de la leyenda respecto a la malla.

- legend.mar:

  Número. Margen horizontal entre la malla y la leyenda.

- lab.dist:

  Número. Distancia de las etiquetas respecto a la barra de la leyenda.

- lab.rev:

  Lógico. Si es `TRUE`, invierte el orden de las etiquetas en la
  leyenda.

- add:

  Lógico. Si es `TRUE`, añade la malla a una escena 3D ya existente sin
  generar una nueva leyenda.

- ...:

  rgumentos adicionales pasados a
  [`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html).

## Value

Devuelve (invisiblemente) el identificador del objeto dibujado en la
escena de `rgl`.

## Details

Esta función facilita la representación de categorías o regiones
diferenciadas sobre mallas 3D, coloreando cada zona según la categoría
correspondiente. Cuando `add = FALSE`, se genera además una leyenda
lateral mediante
[`fplot3d()`](https://groupmodes.github.io/controlDim/reference/fplot3d.md)
que asocia cada color con su categoría.

## See also

[`fplot3d()`](https://groupmodes.github.io/controlDim/reference/fplot3d.md)
para la generación de leyendas categóricas.

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

# Valor por triangulo (media de los vértices)
vb2tri <- function(x, s) {
if (!length(x$it)) stop("Argument 'x' must be a triangular mesh")
return(apply(x$it, 2, function(tri) mean(s[tri])))
}
z_tri <- vb2tri(mesh, mesh$vb[3, ])

# Factor con 5 niveles de altura
fz_tri <- cut(z_tri, 5)

# Representar la superficie coloreada por niveles con leyenda
rgl::open3d()
fshade3d(mesh, fz_tri, legend.lab = seq_along(levels(fz_tri)))
} # }
```
