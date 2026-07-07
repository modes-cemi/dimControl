# 3D Cross Product

Computes the cross product between two three-dimensional vectors `v` and
`w` in \\\mathbb{R}^3\\.

## Usage

``` r
xprod(v, w)
```

## Arguments

- v:

  Numeric vector of length 3.

- w:

  Numeric vector of length 3.

## Value

Numeric vector of length 3 perpendicular to `v` and `w`, whose magnitude
equals the area of the parallelogram defined by `v` and `w`. The
direction of the vector follows the right-hand rule.

## Details

The cross product is defined as: \$\$ v \times w = \begin{pmatrix} v_2
w_3 - v_3 w_2 \\ v_3 w_1 - v_1 w_3 \\ v_1 w_2 - v_2 w_1 \end{pmatrix}
\$\$

## Examples

``` r
xprod(c(1, 0, 0), c(0, 1, 0))  # Returns c(0, 0, 1)
#> [1] 0 0 1
```
