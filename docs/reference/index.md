# Package index

## Segmentation and Classification

Functions for segmentation, classification and identification of
geometric components in 3D data.

- [`findModes()`](https://modes-cemi.github.io/dimControl/reference/findModes.md)
  : Detect Modes in a Dataset
- [`sideBulb()`](https://modes-cemi.github.io/dimControl/reference/sideBulb.md)
  : Determine the Orientation of a Reinforcement Bulb
- [`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md)
  : Split a Mesh into Connected Triangle Groups
- [`filterMeshComponents()`](https://modes-cemi.github.io/dimControl/reference/filterMeshComponents.md)
  : Filter Mesh Components by Minimum Size

## Mesh Reconstruction and Processing

Functions for reconstructing and processing triangular meshes.

- [`createMesh()`](https://modes-cemi.github.io/dimControl/reference/createMesh.md)
  : Reconstruct a Triangular Mesh from a 3D Point Cloud
- [`getBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/getBoundarySegments.md)
  : Extract the Boundary of a 3D Mesh
- [`cleanBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/cleanBoundarySegments.md)
  : Clean and Reconnect Boundary Segments of a 3D Mesh
- [`sortSegments()`](https://modes-cemi.github.io/dimControl/reference/sortSegments.md)
  : Reorder Connected Edge Segments
- [`boundingBox()`](https://modes-cemi.github.io/dimControl/reference/boundingBox.md)
  : Compute the Bounding Box of a 3D Mesh
- [`meshNormals()`](https://modes-cemi.github.io/dimControl/reference/meshNormals.md)
  : Compute Face Normals of a Triangular Mesh
- [`addNormals()`](https://modes-cemi.github.io/dimControl/reference/addNormals.md)
  : Compute Vertex Normals by Averaging Triangle Normals

## Measurement and Comparison

Functions for geometric measurements, distances and angular comparisons.

- [`euclideanDistance()`](https://modes-cemi.github.io/dimControl/reference/euclideanDistance.md)
  : Compute the Euclidean Distance Between Two Points
- [`surfaceDistance()`](https://modes-cemi.github.io/dimControl/reference/surfaceDistance.md)
  : Calculate Distance over a 3D Surface
- [`angleBetween()`](https://modes-cemi.github.io/dimControl/reference/angleBetween.md)
  : Angle Between Two Vectors
- [`angleFromAxis()`](https://modes-cemi.github.io/dimControl/reference/angleFromAxis.md)
  : Directional Angle from an Axis
- [`angleFromVectors()`](https://modes-cemi.github.io/dimControl/reference/angleFromVectors.md)
  : Angles Between Vectors and Reference Vectors

## Simulation and Data

Functions and data used to prepare theoretical geometries and generate
simulated 3D point clouds.

- [`cad`](https://modes-cemi.github.io/dimControl/reference/cad.md) :
  CAD Object of a Steel Panel
- [`preparePanelMesh()`](https://modes-cemi.github.io/dimControl/reference/preparePanelMesh.md)
  : Prepare a Theoretical Panel Mesh for Point Cloud Simulation
- [`simulatePanelFloorCloud()`](https://modes-cemi.github.io/dimControl/reference/simulatePanelFloorCloud.md)
  : Simulate a Steel Panel and Floor Point Cloud
- [`sampleMesh()`](https://modes-cemi.github.io/dimControl/reference/sampleMesh.md)
  : Sample Points over a Triangular Mesh

## Utilities

Auxiliary functions used throughout the geometric processing workflow.

- [`radDeg()`](https://modes-cemi.github.io/dimControl/reference/radDeg.md)
  : Conversion from Radians to Degrees
- [`xProd()`](https://modes-cemi.github.io/dimControl/reference/xProd.md)
  : 3D Cross Product
- [`getView3d()`](https://modes-cemi.github.io/dimControl/reference/getView3d.md)
  : Get the Current 3D View
- [`setView3d()`](https://modes-cemi.github.io/dimControl/reference/setView3d.md)
  : Set a 3D View
- [`pan3d()`](https://modes-cemi.github.io/dimControl/reference/pan3d.md)
  : Interactive 3D View Panning
