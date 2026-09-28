# Package index

## Segmentation and Classification

Functions for segmentation, classification and identification of
geometric components in 3D data.

- [`findModes()`](https://modes-cemi.github.io/dimControl/reference/findModes.md)
  : Detect modes in a dataset
- [`sideBulb()`](https://modes-cemi.github.io/dimControl/reference/sideBulb.md)
  : Determine the orientation of a reinforcement bulb
- [`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md)
  : Split a mesh into connected triangle groups
- [`filterMeshComponents()`](https://modes-cemi.github.io/dimControl/reference/filterMeshComponents.md)
  : Filter mesh components by minimum size

## Mesh Reconstruction and Processing

Functions for reconstructing and processing triangular meshes.

- [`createMesh()`](https://modes-cemi.github.io/dimControl/reference/createMesh.md)
  : Reconstruct a triangular mesh from a 3D point cloud
- [`getBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/getBoundarySegments.md)
  : Extract the boundary of a 3D mesh
- [`cleanBoundarySegments()`](https://modes-cemi.github.io/dimControl/reference/cleanBoundarySegments.md)
  : Clean and reconnect boundary segments of a 3D mesh
- [`sortSegments()`](https://modes-cemi.github.io/dimControl/reference/sortSegments.md)
  : Reorder connected edge segments
- [`boundingBox()`](https://modes-cemi.github.io/dimControl/reference/boundingBox.md)
  : Compute the bounding box of a 3D mesh
- [`addNormals2()`](https://modes-cemi.github.io/dimControl/reference/addNormals2.md)
  : Compute vertex normals by averaging triangle normals
- [`cleanMesh3d()`](https://modes-cemi.github.io/dimControl/reference/cleanMesh3d.md)
  : Clean a 3D mesh

## Measurement and Comparison

Functions for geometric measurements, distances and angular comparisons.

- [`euclideanDistance()`](https://modes-cemi.github.io/dimControl/reference/euclideanDistance.md)
  : Compute the Euclidean distance between two points
- [`surfaceDistance()`](https://modes-cemi.github.io/dimControl/reference/surfaceDistance.md)
  : Calculate distance over a 3D surface
- [`angleAxis()`](https://modes-cemi.github.io/dimControl/reference/angleAxis.md)
  : Directional angle relative to an axis
- [`angle()`](https://modes-cemi.github.io/dimControl/reference/angle.md)
  : Angles between vectors

## Simulation and Data

Functions and data used to prepare theoretical geometries and generate
simulated 3D point clouds.

- [`cad`](https://modes-cemi.github.io/dimControl/reference/cad.md) :
  CAD model of a steel panel
- [`simulateCloud()`](https://modes-cemi.github.io/dimControl/reference/simulateCloud.md)
  : Simulate 3D point cloud
- [`simulateFloor()`](https://modes-cemi.github.io/dimControl/reference/simulateFloor.md)
  : Simulate floor point cloud
- [`sampleMesh()`](https://modes-cemi.github.io/dimControl/reference/sampleMesh.md)
  : Sample points over a triangular mesh
