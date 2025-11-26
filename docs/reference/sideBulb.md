# Determine the Orientation of a Reinforcement Bulb

Identifies whether the bulb (the upper extension of the reinforcement)
is oriented to the left or right of the flat face. The criterion is
based on the vertex coordinates of the 3D object (`mesh3d`): the
reinforcement is divided according to its mean Z coordinate, and the X
positions of both halves are compared.

## Usage

``` r
sideBulb(ref)
```

## Arguments

- ref:

  A `mesh3d` object representing the reinforcement. It must contain the
  `vb` matrix, where rows correspond to the X, Y, and Z coordinates of
  the vertices.

## Value

Logical indicating the bulb orientation:

- `TRUE` if the bulb protrudes to the left.

- `FALSE` if the bulb protrudes to the right.

## Details

The function calculates the mean Z coordinate to split the reinforcement
into two parts: the upper part (including the bulb) and the lower part
(excluding the bulb). Then, it compares the minimum X coordinates of
both parts to determine the orientation. If the bulb has a smaller X
position than the lower part, it is considered oriented to the left.
