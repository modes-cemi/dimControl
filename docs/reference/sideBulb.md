# Determinar la orientación del bulbo de un refuerzo

Identifica si el bulbo (la prolongación superior del refuerzo) se
encuentra orientado hacia la izquierda o hacia la derecha de la cara
plana. El criterio se basa en las coordenadas de los vértices del objeto
3D (`mesh3d`): se divide el refuerzo según su coordenada Z media y se
compara la posición en X de ambas mitades.

## Usage

``` r
sideBulb(ref)
```

## Arguments

- ref:

  Objeto de tipo `mesh3d` que representa el refuerzo. Debe contener la
  matriz `vb`, donde las filas corresponden a las coordenadas X, Y y Z
  de los vértices.

## Value

Lógico que indica la orientación del bulbo:

- `TRUE` si el bulbo sobresale hacia la izquierda.

- `FALSE` si el bulbo sobresale hacia la derecha.

## Details

La función calcula el valor medio de la coordenada Z para dividir el
refuerzo en dos partes: la superior (que incluye el bulbo) y la inferior
(que no lo contiene). Posteriormente, compara las coordenadas X mínimas
de ambas partes para determinar la orientación. Si el bulbo tiene una
posición X menor que la de la parte inferior, se considera que está
orientado hacia la izquierda.
