# Desplazamiento interactivo de la vista 3D

Activa el desplazamiento de la cámara en una escena 3D de **rgl**,
permitiendo mover la vista libremente dentro de la ventana gráfica al
arrastrar el ratón con el botón indicado.

## Usage

``` r
pan3d(button, dev = rgl::cur3d(), subscene = rgl::currentSubscene3d(dev))
```

## Arguments

- button:

  Entero que indica el botón del ratón usado para el desplazamiento:

  - `1`: botón izquierdo

  - `2`: botón derecho

  - `3`: botón central (rueda)

- dev:

  Identificador del dispositivo RGL (por defecto
  [`rgl::cur3d()`](https://dmurdoch.github.io/rgl/dev/reference/open3d.html)).

- subscene:

  Subescena a la que se aplicará el movimiento (por defecto la subescena
  activa obtenida con
  [`rgl::currentSubscene3d()`](https://dmurdoch.github.io/rgl/dev/reference/subscene3d.html)).

## Value

No devuelve ningún valor; su efecto es establecer los *callbacks* del
ratón para desplazar la vista en la escena 3D.

## Details

De forma predeterminada, **rgl** solo permite rotar y hacer zoom sobre
los objetos 3D, pero no desplazar la cámara. Esta función amplía dicha
interacción al permitir trasladar toda la escena en cualquier dirección
sin modificar la orientación del modelo.

Internamente, la función utiliza *callbacks* del ratón mediante
[`rgl::rgl.setMouseCallbacks()`](https://dmurdoch.github.io/rgl/dev/reference/callbacks.html),
de modo que, al presionar y arrastrar el ratón, se actualiza
dinámicamente la matriz de proyección (`userProjection`) para simular un
desplazamiento fluido dentro de la escena.

Al presionar el botón indicado, la función registra la posición inicial
del cursor (*evento* `begin`). Durante el movimiento del ratón (*evento*
`update`), calcula el desplazamiento relativo y aplica una
transformación de traslación sobre `userProjection` mediante
[`rgl::translationMatrix()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html),
consiguiendo que la cámara se desplace en la dirección del arrastre y
permitiendo mover la escena libremente dentro de la ventana.

## Note

El código original fue desarrollado por **Duncan Murdoch** y forma parte
del paquete **rgl**, donde no se exporta públicamente. Se incluye aquí
sin modificaciones para facilitar su uso dentro de este paquete.

## See also

[`rgl::rgl.setMouseCallbacks()`](https://dmurdoch.github.io/rgl/dev/reference/callbacks.html),
[`rgl::par3d()`](https://dmurdoch.github.io/rgl/dev/reference/par3d.html),
[`rgl::translationMatrix()`](https://dmurdoch.github.io/rgl/dev/reference/matrices.html)

## Author

Duncan Murdoch

## Examples

``` r
if (FALSE) { # \dontrun{
rgl::open3d()
mesh <- rgl::icosahedron3d()
rgl::shade3d(mesh, col = "lightblue")
pan3d(2) # Activa el desplazamiento con el botón derecho del ratón
} # }
```
