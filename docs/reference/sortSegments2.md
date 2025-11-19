# Reordenar segmentos conectados de un borde

Esta función reordena los segmentos de un borde (aristas) de manera que
cada segmento esté conectado al siguiente. Se basa en la idea de la
función `getBoundary3d` del paquete `rgl`, pero ha sido modificada para
asegurar que la secuencia de segmentos sea correcta en casos donde el
borde original no estaba ordenado adecuadamente.

## Usage

``` r
sortSegments2(edges)
```

## Arguments

- edges:

  Matriz numérica de 2 filas y N columnas, donde cada columna representa
  un segmento del borde con sus dos extremos. La primera fila contiene
  el primer vértice de cada segmento y la segunda fila el segundo
  vértice.

## Value

Matriz de 2 filas y N columnas con los segmentos reordenados de forma
que cada segmento esté conectado al siguiente. Si hay segmentos
desconectados, la secuencia se interrumpe en el primer hueco.
