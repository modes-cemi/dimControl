# dimControl

The dimControl package provides a set of tools for dimensional control
and geometric analysis of steel panels.

It is designed to be used together with packages such as rgl, misc3d,
and Rvcg, offering complementary functions that support the processing
and analysis of 3D data.

These tools assist in different stages of the dimensional inspection
workflow, such as:

- Comparing the estimated mesh with the CAD reference to evaluate
  dimensional deviations.
- Calculating linear and developed dimensions to verify the panel’s
  conformity with expected measurements.
- Separating components of the estimated mesh for individual evaluation.
- Computing angles to analyze the alignment between different components
  of the panel.

🔗 [For more information see the package
vignette](https://modes-cemi.github.io/dimControl/articles/dimControl.html)

## Installation

You can install the development version of dimControl from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("modes-cemi/dimControl")
```

## Acknowledgments

This work was funded by the Galician Innovation Agency (GAIN) of the
Xunta de Galicia and the company Navantia (SEPI), within the framework
of the UDC-NAVANTIA Joint Research Center, through the project *“O
estaleiro do futuro”* (IN853C).

## References

- Chacón J.E., Duong T. (2018). *Multivariate kernel smoothing and its
  applications*. Chapman and Hall/CRC.

- Feng D., Tierney L. (2008). Computing and Displaying Isosurfaces in R.
  *Journal of Statistical Software*, 28, 1-24.

- Fernández-Casal R. (2024). *npsp: Nonparametric Spatial Statistics*. R
  package version 0.7-14. <https://rubenfcasal.github.io/npsp/>.

- Lorensen W.E., Cline H.E. (1987). Marching Cubes: A High Resolution 3D
  Surface Reconstruction Algorithm. *Computer Graphics*, 21(4), 163-169.

- Murdoch D., Adler D. (2023). *rgl: 3D Visualization Using OpenGL*. R
  package version 1.1.3, <https://CRAN.R-project.org/package=rgl>.

- Schlager S. (2017). Morpho and Rvcg - Shape Analysis in R. En Zheng
  G., Li S., Szekely G. (Eds.), *Statistical Shape and Deformation
  Analysis*, pp. 217-256. Academic Press.
