# Truncated normal distribution

Density, quantile function, and random generation for the truncated
normal distribution.

## Usage

``` r
dtnorm(x, mean = 0, sd = 1, a = -Inf, b = Inf)

qtnorm(p, mean = 0, sd = 1, a = -Inf, b = Inf)

rtnorm(n, mean = 0, sd = 1, a = -Inf, b = Inf)
```

## Arguments

- x:

  Numeric vector of values at which the density is evaluated.

- mean:

  Mean of the normal distribution. Default is 0.

- sd:

  Standard deviation of the normal distribution. Default is 1.

- a:

  Lower truncation point. Default is `-Inf`.

- b:

  Upper truncation point. Default is `Inf`.

- p:

  Numeric vector of probabilities.

- n:

  Number of observations to generate.

## Value

`dtnorm()` returns the density evaluated at `x`.

`qtnorm()` returns the quantiles corresponding to `p`.

`rtnorm()` returns a numeric vector of `n` random values.

## Details

The truncated normal distribution corresponds to a normal distribution
with mean `mean` and standard deviation `sd`, restricted to the interval
from `a` to `b`.

The functions `dtnorm()`, `qtnorm()`, and `rtnorm()` provide the
density, quantile function, and random generation, respectively.

## Examples

``` r
# Density of a truncated normal distribution
x <- seq(-2, 2, length.out = 200)
plot(
  x,
  dtnorm(x, mean = 0, sd = 1, a = -2, b = 2),
  type = "l",
  xlab = "x",
  ylab = "Density"
)


# Generate random values
set.seed(1)
values <- rtnorm(1000, mean = 0, sd = 1, a = -2, b = 2)
hist(values, probability = TRUE)

```
