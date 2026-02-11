#' 3D Cross Product
#'
#' Computes the cross product between two three-dimensional vectors `v` and `w`
#' in \eqn{\mathbb{R}^3}.
#'
#' @param v Numeric vector of length 3.
#' @param w Numeric vector of length 3.
#'
#' @returns
#' Numeric vector of length 3 perpendicular to `v` and `w`, whose magnitude
#' equals the area of the parallelogram defined by `v` and `w`. The direction
#' of the vector follows the right-hand rule.
#'
#' @details
#' The cross product is defined as:
#' \deqn{
#' v \times w =
#' \begin{pmatrix}
#' v_2 w_3 - v_3 w_2 \\
#' v_3 w_1 - v_1 w_3 \\
#' v_1 w_2 - v_2 w_1
#' \end{pmatrix}
#' }
#'
#' @examples
#' xprod(c(1, 0, 0), c(0, 1, 0))  # Returns c(0, 0, 1)
#'
#' @export
xprod <- function(v, w) {
  c(
    v[2]*w[3] - v[3]*w[2],
    v[3]*w[1] - v[1]*w[3],
    v[1]*w[2] - v[2]*w[1]
  )
}
