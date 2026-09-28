# Internal functions

Supporting functions used internally by `dimControl`.

## Details

`.radDeg()` converts angular values expressed in radians to degrees.

`.normalize()` normalizes the columns of a numeric matrix so that each
column has unit Euclidean length.

`.sampleTriangle()` generates uniformly distributed points inside a
triangle using barycentric coordinates.

`.rtnormDefault()` generates random values from a truncated normal
distribution using the default parameters employed by
[`simulateCloud()`](https://modes-cemi.github.io/dimControl/reference/simulateCloud.md).
