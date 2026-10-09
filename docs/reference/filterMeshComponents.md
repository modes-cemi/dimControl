# Filter mesh components by minimum size

Filters the connected components of a triangular mesh according to their
number of triangles and rebuilds the mesh using only the retained
components.

## Usage

``` r
filterMeshComponents(
  mesh,
  comps,
  minSize = 1000,
  color = FALSE,
  plot = FALSE,
  palette = grDevices::rainbow
)
```

## Arguments

- mesh:

  `mesh3d` object containing a triangular mesh. It must include an `it`
  matrix with three rows, where each column represents a triangle.

- comps:

  List of integer vectors containing the triangle indices of each
  connected component, typically returned by
  [`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md).

- minSize:

  Numeric value specifying the minimum number of triangles required for
  a component to be retained. Default is `1000`. If `NULL`, all
  components are retained.

- color:

  Logical. If `TRUE`, an additional rendering mesh is created with a
  distinct color assigned to each retained component. Default is
  `FALSE`. It is automatically set to `TRUE` when `plot = TRUE`.

- plot:

  Logical. If `TRUE`, the retained components are displayed using
  [`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html).
  Default is `FALSE`.

- palette:

  Function receiving the number of retained components and returning the
  corresponding colors. Default is
  [`grDevices::rainbow()`](https://rdrr.io/r/grDevices/palettes.html).

## Value

List containing:

- `mesh`: `mesh3d` object containing the retained triangles.

- `triIdx`: integer vector containing the triangle-column indices
  retained from the input `mesh$it`.

- `compId`: integer vector containing the original component index
  associated with each retained triangle.

- `render`: `NULL` unless `color = TRUE` or `plot = TRUE`; otherwise, a
  list containing the rendering mesh and its per-vertex color vector.

## Details

Components are retained when their number of triangles is greater than
or equal to `minSize`. If `minSize = NULL`, all components are retained.
The original vertex indices and the `mesh$vb` matrix are preserved in
the filtered mesh.

When coloring is requested, the vertices of each retained triangle are
duplicated so that each component can be displayed with an independent
color. The resulting mesh stored in `render$mesh` is intended only for
visualization and does not preserve the original vertex indexing.

If `plot = TRUE`, component coloring is enabled automatically and the
rendering mesh is displayed using
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html).

## See also

[`splitTrianglesInd()`](https://modes-cemi.github.io/dimControl/reference/splitTrianglesInd.md),
[`rgl::shade3d()`](https://dmurdoch.github.io/rgl/dev/reference/shade3d.html)

## Examples

``` r
# Create a mesh with two disconnected components
vertices <- t(rbind(
  c(0, 0, 0),
  c(1, 0, 0),
  c(0, 1, 0),
  c(1, 1, 0),
  c(3, 0, 0),
  c(4, 0, 0),
  c(3, 1, 0)
))

triangles <- t(rbind(
  c(1, 2, 3),
  c(2, 4, 3),
  c(5, 6, 7)
))

mesh <- tmesh3d(
  vertices = vertices,
  indices = triangles
)

# Identify connected components
components <- splitTrianglesInd(mesh)

# Retain components with at least two triangles
result <- filterMeshComponents(mesh = mesh, comps = components, minSize = 2, color = TRUE)

# Represent original and filtered meshes side by side
open3d() # Alternatively, use `legendplot::new3d()` to clear the current device or open a new one
mfrow3d(1, 2)

shade3d(mesh, color = "lightgray")
title3d("Original mesh", level = 10)

next3d()
shade3d(result$render$mesh, color = result$render$col)
title3d("Filtered mesh", level = 10)
3D plot

{"x":{"material":{"color":"#000000","alpha":1,"lit":true,"ambient":"#000000","specular":"#FFFFFF","emission":"#000000","shininess":50,"smooth":true,"front":"filled","back":"filled","size":3,"lwd":1,"fog":true,"point_antialias":false,"line_antialias":false,"texture":null,"textype":"rgb","texmode":"modulate","texmipmap":false,"texminfilter":"linear","texmagfilter":"linear","texenvmap":false,"depth_mask":true,"depth_test":"less","isTransparent":false,"polygon_offset":[0,0],"margin":"","floating":false,"tag":"","blend":["src_alpha","one_minus_src_alpha"]},"rootSubscene":66,"objects":{"75":{"id":75,"type":"triangles","material":{},"vertices":"0","colors":"2","centers":"3","normals":"1","ignoreExtent":false,"flags":32771},"77":{"id":77,"type":"text","material":{"lit":false,"margin":0,"edge":[0,1,1]},"vertices":"4","colors":"5","texts":[["Original mesh"]],"cex":[[1]],"adj":[[0.5,0.5,0.5]],"centers":"6","family":[["sans"]],"font":[[1]],"ignoreExtent":true,"flags":33808},"78":{"id":78,"type":"triangles","material":{},"vertices":"7","colors":"9","centers":"10","normals":"8","ignoreExtent":false,"flags":32771},"80":{"id":80,"type":"text","material":{"lit":false,"margin":0,"edge":[0,1,1]},"vertices":"11","colors":"12","texts":[["Filtered mesh"]],"cex":[[1]],"adj":[[0.5,0.5,0.5]],"centers":"13","family":[["sans"]],"font":[[1]],"ignoreExtent":true,"flags":33808},"70":{"id":70,"type":"light","vertices":[[0,0,1]],"colors":[[1,1,1,1],[1,1,1,1],[1,1,1,1]],"viewpoint":true,"finite":false},"72":{"id":72,"type":"background","material":{"lit":false,"back":"lines"},"colors":"14","centers":"15","sphere":false,"fogtype":"none","fogscale":1,"flags":32768},"76":{"id":76,"type":"bboxdeco","material":{"front":"culled","back":"culled"},"colors":"16","axes":{"mode":["none","none","none"],"step":[-1,-1,-1],"nticks":[0,0,0],"marklen":[15,15,15],"expand":[1.029999971389771,1.029999971389771,1.029999971389771]},"draw_front":false,"flags":32769},"79":{"id":79,"type":"bboxdeco","material":{"front":"culled","back":"culled"},"colors":"17","axes":{"mode":["none","none","none"],"step":[-1,-1,-1],"nticks":[0,0,0],"marklen":[15,15,15],"expand":[1.029999971389771,1.029999971389771,1.029999971389771]},"draw_front":false,"flags":32769},"73":{"id":73,"type":"subscene","par3d":{"antialias":8,"FOV":30,"ignoreExtent":false,"listeners":73,"mouseMode":{"none":"none","left":"trackball","right":"zoom","middle":"fov","wheel":"pull"},"observer":[0,0,10.08928966522217],"modelMatrix":[[1,0,0,-2],[0,0.3420201539993286,0.9396926164627075,-0.1710100769996643],[0,-0.9396926164627075,0.3420201539993286,-9.619442939758301],[0,0,0,1]],"projMatrix":[[3.732050657272339,0,0,0],[0,1.866025328636169,0,0],[0,0,-3.863703012466431,-36.37071990966797],[0,0,-1,0]],"skipRedraw":false,"userMatrix":[[1,0,0,0],[0,0.3420201433256682,0.9396926207859085,0],[0,-0.9396926207859085,0.3420201433256682,0],[0,0,0,1]],"userProjection":[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],"scale":[1,1,1],"viewport":{"x":0,"y":0,"width":0.5,"height":1},"zoom":1,"bbox":[0,4,0,1,0,0],"windowRect":[112,135,368,391],"family":"sans","font":1,"cex":1,"useFreeType":false,"fontname":"TT Arial","maxClipPlanes":8,"glVersion":4.6,"activeSubscene":0},"embeddings":{"viewport":"replace","projection":"replace","model":"replace","mouse":"inherit"},"objects":[76,75,77,70],"parent":66,"subscenes":[],"flags":34067},"74":{"id":74,"type":"subscene","par3d":{"antialias":8,"FOV":30,"ignoreExtent":false,"listeners":74,"mouseMode":{"none":"none","left":"trackball","right":"zoom","middle":"fov","wheel":"pull"},"observer":[0,0,3.460597515106201],"modelMatrix":[[1,0,0,-0.5],[0,0.3420201539993286,0.9396926164627075,-0.1710100769996643],[0,-0.9396926164627075,0.3420201539993286,-2.990751266479492],[0,0,0,1]],"projMatrix":[[3.732050895690918,0,0,0],[0,1.866025447845459,0,0],[0,0,-3.863703489303589,-12.47505474090576],[0,0,-1,0]],"skipRedraw":false,"userMatrix":[[1,0,0,0],[0,0.3420201433256682,0.9396926207859085,0],[0,-0.9396926207859085,0.3420201433256682,0],[0,0,0,1]],"userProjection":[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],"scale":[1,1,1],"viewport":{"x":0.5,"y":0,"width":0.5,"height":1},"zoom":1,"bbox":[0,1,0,1,0,0],"windowRect":[112,135,368,391],"family":"sans","font":1,"cex":1,"useFreeType":false,"fontname":"TT Arial","maxClipPlanes":8,"glVersion":4.6,"activeSubscene":0},"embeddings":{"viewport":"replace","projection":"replace","model":"replace","mouse":"inherit"},"objects":[79,78,80,70],"parent":66,"subscenes":[],"flags":34067},"66":{"id":66,"type":"subscene","par3d":{"antialias":8,"FOV":30,"ignoreExtent":false,"listeners":66,"mouseMode":{"none":"none","left":"trackball","right":"zoom","middle":"fov","wheel":"pull"},"observer":[0,0,823.132080078125],"modelMatrix":[[1,0,0,0],[0,0.3420201539993286,0.9396926164627075,0],[0,-0.9396926164627075,0.3420201539993286,-823.132080078125],[0,0,0,1]],"projMatrix":[[3.732050657272339,0,0,0],[0,3.732050657272339,0,0],[0,0,-3.863703727722168,-2967.29638671875],[0,0,-1,0]],"skipRedraw":false,"userMatrix":[[1,0,0,0],[0,0.3420201433256682,0.9396926207859085,0],[0,-0.9396926207859085,0.3420201433256682,0],[0,0,0,1]],"userProjection":[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],"scale":[1,1,1],"viewport":{"x":0,"y":0,"width":1,"height":1},"zoom":1,"bbox":[123,-123,123,-123,123,-123],"windowRect":[112,135,368,391],"family":"sans","font":1,"cex":1,"useFreeType":false,"fontname":"TT Arial","maxClipPlanes":8,"glVersion":4.6,"activeSubscene":0},"embeddings":{"viewport":"replace","projection":"replace","model":"replace","mouse":"replace"},"objects":[72,70,73,74],"subscenes":[73,74],"flags":34067}},"crosstalk":{"key":[],"group":[],"id":[],"options":[]},"width":576,"height":384,"buffer":{"accessors":[{"bufferView":0,"componentType":5121,"count":9,"type":"VEC3"},{"bufferView":1,"componentType":5121,"count":9,"type":"VEC3"},{"bufferView":2,"componentType":5126,"count":1,"type":"VEC4"},{"bufferView":3,"componentType":5126,"count":3,"type":"VEC3"},{"bufferView":4,"componentType":5126,"count":1,"type":"VEC3"},{"bufferView":5,"componentType":5121,"count":1,"type":"VEC4"},{"bufferView":6,"componentType":5126,"count":1,"type":"VEC3"},{"bufferView":7,"componentType":5121,"count":6,"type":"VEC3"},{"bufferView":8,"componentType":5121,"count":6,"type":"VEC3"},{"bufferView":9,"componentType":5121,"count":6,"type":"VEC4","normalized":true},{"bufferView":10,"componentType":5126,"count":2,"type":"VEC3"},{"bufferView":11,"componentType":5126,"count":1,"type":"VEC3"},{"bufferView":12,"componentType":5121,"count":1,"type":"VEC4"},{"bufferView":13,"componentType":5126,"count":1,"type":"VEC3"},{"bufferView":14,"componentType":5121,"count":1,"type":"VEC4"},{"bufferView":15,"componentType":5121,"count":1,"type":"VEC3"},{"bufferView":16,"componentType":5121,"count":1,"type":"VEC4"},{"bufferView":17,"componentType":5121,"count":1,"type":"VEC4"}],"bufferViews":[{"buffer":0,"byteLength":27,"byteOffset":0},{"buffer":0,"byteLength":27,"byteOffset":27},{"buffer":0,"byteLength":16,"byteOffset":56},{"buffer":0,"byteLength":36,"byteOffset":72},{"buffer":0,"byteLength":12,"byteOffset":108},{"buffer":0,"byteLength":4,"byteOffset":120},{"buffer":0,"byteLength":12,"byteOffset":124},{"buffer":0,"byteLength":18,"byteOffset":136},{"buffer":0,"byteLength":18,"byteOffset":154},{"buffer":0,"byteLength":24,"byteOffset":172},{"buffer":0,"byteLength":24,"byteOffset":196},{"buffer":0,"byteLength":12,"byteOffset":220},{"buffer":0,"byteLength":4,"byteOffset":232},{"buffer":0,"byteLength":12,"byteOffset":236},{"buffer":0,"byteLength":4,"byteOffset":248},{"buffer":0,"byteLength":3,"byteOffset":252},{"buffer":0,"byteLength":4,"byteOffset":255},{"buffer":0,"byteLength":4,"byteOffset":259}],"buffers":[{"byteLength":263,"bytes":"AAAAAQAAAAEAAQAAAQEAAAEAAwAABAAAAwEAAAABAAABAAABAAABAAABAAABAAABAAABAAAB\nAADU01M/1NNTP9TTUz8AAIA/q6qqPquqqj4AAAAAq6oqP6uqKj8AAAAAVlVVQKuqqj4AAAAA\nAADAfwAAAEAAACBBAAAAAQAAwH8AAABAAAAgQQAAAAEAAAABAAEAAAEBAAABAAAAAQAAAQAA\nAQAAAQAAAQAAAf8AAP//AAD//wAA//8AAP//AAD//wAA/6uqqj6rqqo+AAAAAKuqKj+rqio/\nAAAAAAAAwH8AAABAAAAgQQAAAAEAAMB/AAAAQAAAIEEBAQEBAAAAAAAAAQAAAAE="}]},"context":{"shiny":false,"rmarkdown":null},"vertexShader":"#line 2 1\n// File 1 is the vertex shader\n#ifdef GL_ES\n#ifdef GL_FRAGMENT_PRECISION_HIGH\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n#endif\n\nattribute vec3 aPos;\nattribute vec4 aCol;\nuniform mat4 mvMatrix;\nuniform mat4 prMatrix;\nvarying vec4 vCol;\nvarying vec4 vPosition;\n\n#ifdef NEEDS_VNORMAL\nattribute vec3 aNorm;\nuniform mat4 normMatrix;\nvarying vec4 vNormal;\n#endif\n\n#if defined(HAS_TEXTURE) || defined (IS_TEXT)\nattribute vec2 aTexcoord;\nvarying vec2 vTexcoord;\n#endif\n\n#ifdef FIXED_SIZE\nuniform vec3 textScale;\n#endif\n\n#ifdef FIXED_QUADS\nattribute vec3 aOfs;\n#endif\n\n#ifdef IS_TWOSIDED\n#ifdef HAS_NORMALS\nvarying float normz;\nuniform mat4 invPrMatrix;\n#else\nattribute vec3 aPos1;\nattribute vec3 aPos2;\nvarying float normz;\n#endif\n#endif // IS_TWOSIDED\n\n#ifdef FAT_LINES\nattribute vec3 aNext;\nattribute vec2 aPoint;\nvarying vec2 vPoint;\nvarying float vLength;\nuniform float uAspect;\nuniform float uLwd;\n#endif\n\n#ifdef USE_ENVMAP\nvarying vec3 vReflection;\n#endif\n\nvoid main(void) {\n  \n#ifndef IS_BRUSH\n#if defined(NCLIPPLANES) || !defined(FIXED_QUADS) || defined(HAS_FOG) || defined(USE_ENVMAP)\n  vPosition = mvMatrix * vec4(aPos, 1.);\n#endif\n  \n#ifndef FIXED_QUADS\n  gl_Position = prMatrix * vPosition;\n#endif\n#endif // !IS_BRUSH\n  \n#ifdef IS_POINTS\n  gl_PointSize = POINTSIZE;\n#endif\n  \n  vCol = aCol;\n  \n// USE_ENVMAP implies NEEDS_VNORMAL\n\n#ifdef NEEDS_VNORMAL\n  vNormal = normMatrix * vec4(-aNorm, dot(aNorm, aPos));\n#endif\n\n#ifdef USE_ENVMAP\n  vReflection = normalize(reflect(vPosition.xyz/vPosition.w, \n                        normalize(vNormal.xyz/vNormal.w)));\n#endif\n  \n#ifdef IS_TWOSIDED\n#ifdef HAS_NORMALS\n  /* normz should be calculated *after* projection */\n  normz = (invPrMatrix*vNormal).z;\n#else\n  vec4 pos1 = prMatrix*(mvMatrix*vec4(aPos1, 1.));\n  pos1 = pos1/pos1.w - gl_Position/gl_Position.w;\n  vec4 pos2 = prMatrix*(mvMatrix*vec4(aPos2, 1.));\n  pos2 = pos2/pos2.w - gl_Position/gl_Position.w;\n  normz = pos1.x*pos2.y - pos1.y*pos2.x;\n#endif\n#endif // IS_TWOSIDED\n  \n#ifdef NEEDS_VNORMAL\n  vNormal = vec4(normalize(vNormal.xyz), 1);\n#endif\n  \n#if defined(HAS_TEXTURE) || defined(IS_TEXT)\n  vTexcoord = aTexcoord;\n#endif\n  \n#if defined(FIXED_SIZE) && !defined(ROTATING)\n  vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);\n  pos = pos/pos.w;\n  gl_Position = pos + vec4(aOfs*textScale, 0.);\n#endif\n  \n#if defined(IS_SPRITES) && !defined(FIXED_SIZE)\n  vec4 pos = mvMatrix * vec4(aPos, 1.);\n  pos = pos/pos.w + vec4(aOfs,  0.);\n  gl_Position = prMatrix*pos;\n#endif\n  \n#ifdef FAT_LINES\n  /* This code was inspired by Matt Deslauriers' code in \n   https://mattdesl.svbtle.com/drawing-lines-is-hard */\n  vec2 aspectVec = vec2(uAspect, 1.0);\n  mat4 projViewModel = prMatrix * mvMatrix;\n  vec4 currentProjected = projViewModel * vec4(aPos, 1.0);\n  currentProjected = currentProjected/currentProjected.w;\n  vec4 nextProjected = projViewModel * vec4(aNext, 1.0);\n  vec2 currentScreen = currentProjected.xy * aspectVec;\n  vec2 nextScreen = (nextProjected.xy / nextProjected.w) * aspectVec;\n  float len = uLwd;\n  vec2 dir = vec2(1.0, 0.0);\n  vPoint = aPoint;\n  vLength = length(nextScreen - currentScreen)/2.0;\n  vLength = vLength/(vLength + len);\n  if (vLength > 0.0) {\n    dir = normalize(nextScreen - currentScreen);\n  }\n  vec2 normal = vec2(-dir.y, dir.x);\n  dir.x /= uAspect;\n  normal.x /= uAspect;\n  vec4 offset = vec4(len*(normal*aPoint.x*aPoint.y - dir), 0.0, 0.0);\n  gl_Position = currentProjected + offset;\n#endif\n  \n#ifdef IS_BRUSH\n  gl_Position = vec4(aPos, 1.);\n#endif\n}","fragmentShader":"#line 2 2\n// File 2 is the fragment shader\n#ifdef GL_ES\n#ifdef GL_FRAGMENT_PRECISION_HIGH\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n#endif\nvarying vec4 vCol; // carries alpha\nvarying vec4 vPosition;\n#if defined(HAS_TEXTURE) || defined (IS_TEXT)\nvarying vec2 vTexcoord;\nuniform sampler2D uSampler;\n#endif\n\n#ifdef HAS_FOG\nuniform int uFogMode;\nuniform vec3 uFogColor;\nuniform vec4 uFogParms;\n#endif\n\n#if defined(IS_LIT) && !defined(FIXED_QUADS)\nvarying vec4 vNormal;\n#endif\n\n#if NCLIPPLANES > 0\nuniform vec4 vClipplane[NCLIPPLANES];\n#endif\n\n#if NLIGHTS > 0\nuniform mat4 mvMatrix;\n#endif\n\n#ifdef IS_LIT\nuniform vec3 emission;\nuniform float shininess;\n#if NLIGHTS > 0\nuniform vec3 ambient[NLIGHTS];\nuniform vec3 specular[NLIGHTS]; // light*material\nuniform vec3 diffuse[NLIGHTS];\nuniform vec3 lightDir[NLIGHTS];\nuniform bool viewpoint[NLIGHTS];\nuniform bool finite[NLIGHTS];\n#endif\n#endif // IS_LIT\n\n#ifdef IS_TWOSIDED\nuniform bool front;\nvarying float normz;\n#endif\n\n#ifdef FAT_LINES\nvarying vec2 vPoint;\nvarying float vLength;\n#endif\n\n#ifdef USE_ENVMAP\nvarying vec3 vReflection;\n#endif\n\nvoid main(void) {\n  vec4 fragColor;\n#ifdef FAT_LINES\n  vec2 point = vPoint;\n  bool neg = point.y < 0.0;\n  point.y = neg ? (point.y + vLength)/(1.0 - vLength) :\n                 -(point.y - vLength)/(1.0 - vLength);\n#if defined(IS_TRANSPARENT) && defined(IS_LINESTRIP)\n  if (neg && length(point) <= 1.0) discard;\n#endif\n  point.y = min(point.y, 0.0);\n  if (length(point) > 1.0) discard;\n#endif // FAT_LINES\n  \n#ifdef ROUND_POINTS\n  vec2 coord = gl_PointCoord - vec2(0.5);\n  if (length(coord) > 0.5) discard;\n#endif\n  \n#if NCLIPPLANES > 0\n  for (int i = 0; i < NCLIPPLANES; i++)\n    if (dot(vPosition, vClipplane[i]) < 0.0) discard;\n#endif\n    \n#ifdef FIXED_QUADS\n    vec3 n = vec3(0., 0., 1.);\n#elif defined(IS_LIT)\n    vec3 n = normalize(vNormal.xyz);\n#endif\n    \n#ifdef IS_TWOSIDED\n    if ((normz <= 0.) != front) discard;\n#endif\n\n#ifdef IS_LIT\n    vec3 eye = normalize(-vPosition.xyz/vPosition.w);\n    vec3 lightdir;\n    vec4 colDiff;\n    vec3 halfVec;\n    vec4 lighteffect = vec4(emission, 0.);\n    vec3 col;\n    float nDotL;\n#ifdef FIXED_QUADS\n    n = -faceforward(n, n, eye);\n#endif\n    \n#if NLIGHTS > 0\n    // Simulate two-sided lighting\n    if (n.z < 0.0)\n      n = -n;\n    for (int i=0;i<NLIGHTS;i++) {\n      colDiff = vec4(vCol.rgb * diffuse[i], vCol.a);\n      lightdir = lightDir[i];\n      if (!viewpoint[i]) {\n        if (finite[i]) {\n          lightdir = (mvMatrix * vec4(lightdir, 1.)).xyz;\n        } else {\n          lightdir = (mvMatrix * vec4(lightdir, 0.)).xyz;\n        }\n      }\n      if (!finite[i]) {\n        halfVec = normalize(lightdir + eye);\n      } else {\n        lightdir = normalize(lightdir - vPosition.xyz/vPosition.w);\n        halfVec = normalize(lightdir + eye);\n      }\n      col = ambient[i];\n      nDotL = dot(n, lightdir);\n      col = col + max(nDotL, 0.) * colDiff.rgb;\n      col = col + pow(max(dot(halfVec, n), 0.), shininess) * specular[i];\n      lighteffect = lighteffect + vec4(col, colDiff.a);\n    }\n#endif\n    \n#else // not IS_LIT\n    vec4 colDiff = vCol;\n    vec4 lighteffect = colDiff;\n#endif\n    \n#ifdef IS_TEXT\n    vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);\n#endif\n    \n#ifdef HAS_TEXTURE\n\n// These calculations use the definitions from \n// https://docs.gl/gl3/glTexEnv\n\n#ifdef USE_ENVMAP\n    float m = 2.0 * sqrt(dot(vReflection, vReflection) + 2.0*vReflection.z + 1.0);\n    vec4 textureColor = texture2D(uSampler, vReflection.xy / m + vec2(0.5, 0.5));\n#else\n    vec4 textureColor = texture2D(uSampler, vTexcoord);\n#endif\n\n#ifdef TEXTURE_rgb\n\n#if defined(TEXMODE_replace) || defined(TEXMODE_decal)\n    textureColor = vec4(textureColor.rgb, lighteffect.a);\n#endif \n\n#ifdef TEXMODE_modulate\n    textureColor = lighteffect*vec4(textureColor.rgb, 1.);\n#endif\n\n#ifdef TEXMODE_blend\n    textureColor = vec4((1. - textureColor.rgb) * lighteffect.rgb, lighteffect.a);\n#endif\n\n#ifdef TEXMODE_add\n    textureColor = vec4(lighteffect.rgb + textureColor.rgb, lighteffect.a);\n#endif\n\n#endif //TEXTURE_rgb\n        \n#ifdef TEXTURE_rgba\n\n#ifdef TEXMODE_replace\n// already done\n#endif \n\n#ifdef TEXMODE_modulate\n    textureColor = lighteffect*textureColor;\n#endif\n\n#ifdef TEXMODE_decal\n    textureColor = vec4((1. - textureColor.a)*lighteffect.rgb) +\n                     textureColor.a*textureColor.rgb, \n                     lighteffect.a);\n#endif\n\n#ifdef TEXMODE_blend\n    textureColor = vec4((1. - textureColor.rgb) * lighteffect.rgb,\n                    lighteffect.a*textureColor.a);\n#endif\n\n#ifdef TEXMODE_add\n    textureColor = vec4(lighteffect.rgb + textureColor.rgb,\n                    lighteffect.a*textureColor.a);\n#endif\n    \n#endif //TEXTURE_rgba\n    \n#ifdef TEXTURE_alpha\n    float luminance = dot(vec3(1.,1.,1.),textureColor.rgb)/3.;\n\n#if defined(TEXMODE_replace) || defined(TEXMODE_decal)\n    textureColor = vec4(lighteffect.rgb, luminance);\n#endif \n\n#if defined(TEXMODE_modulate) || defined(TEXMODE_blend) || defined(TEXMODE_add)\n    textureColor = vec4(lighteffect.rgb, lighteffect.a*luminance);\n#endif\n \n#endif // TEXTURE_alpha\n    \n// The TEXTURE_luminance values are not from that reference    \n#ifdef TEXTURE_luminance\n    float luminance = dot(vec3(1.,1.,1.),textureColor.rgb)/3.;\n\n#if defined(TEXMODE_replace) || defined(TEXMODE_decal)\n    textureColor = vec4(luminance, luminance, luminance, lighteffect.a);\n#endif \n\n#ifdef TEXMODE_modulate\n    textureColor = vec4(luminance*lighteffect.rgb, lighteffect.a);\n#endif\n\n#ifdef TEXMODE_blend\n    textureColor = vec4((1. - luminance)*lighteffect.rgb,\n                        lighteffect.a);\n#endif\n\n#ifdef TEXMODE_add\n    textureColor = vec4(luminance + lighteffect.rgb, lighteffect.a);\n#endif\n\n#endif // TEXTURE_luminance\n \n    \n#ifdef TEXTURE_luminance_alpha\n    float luminance = dot(vec3(1.,1.,1.),textureColor.rgb)/3.;\n\n#if defined(TEXMODE_replace) || defined(TEXMODE_decal)\n    textureColor = vec4(luminance, luminance, luminance, textureColor.a);\n#endif \n\n#ifdef TEXMODE_modulate\n    textureColor = vec4(luminance*lighteffect.rgb, \n                        textureColor.a*lighteffect.a);\n#endif\n\n#ifdef TEXMODE_blend\n    textureColor = vec4((1. - luminance)*lighteffect.rgb,\n                        textureColor.a*lighteffect.a);\n#endif\n\n#ifdef TEXMODE_add\n    textureColor = vec4(luminance + lighteffect.rgb, \n                        textureColor.a*lighteffect.a);\n\n#endif\n\n#endif // TEXTURE_luminance_alpha\n    \n    fragColor = textureColor;\n\n#elif defined(IS_TEXT)\n    if (textureColor.a < 0.1)\n      discard;\n    else\n      fragColor = textureColor;\n#else\n    fragColor = lighteffect;\n#endif // HAS_TEXTURE\n    \n#ifdef HAS_FOG\n    // uFogParms elements: x = near, y = far, z = fogscale, w = (1-sin(FOV/2))/(1+sin(FOV/2))\n    // In Exp and Exp2: use density = density/far\n    // fogF will be the proportion of fog\n    // Initialize it to the linear value\n    float fogF;\n    if (uFogMode > 0) {\n      fogF = (uFogParms.y - vPosition.z/vPosition.w)/(uFogParms.y - uFogParms.x);\n      if (uFogMode > 1)\n        fogF = mix(uFogParms.w, 1.0, fogF);\n      fogF = fogF*uFogParms.z;\n      if (uFogMode == 2)\n        fogF = 1.0 - exp(-fogF);\n      // Docs are wrong: use (density*c)^2, not density*c^2\n      // https://gitlab.freedesktop.org/mesa/mesa/-/blob/master/src/mesa/swrast/s_fog.c#L58\n      else if (uFogMode == 3)\n        fogF = 1.0 - exp(-fogF*fogF);\n      fogF = clamp(fogF, 0.0, 1.0);\n      gl_FragColor = vec4(mix(fragColor.rgb, uFogColor, fogF), fragColor.a);\n    } else gl_FragColor = fragColor;\n#else\n    gl_FragColor = fragColor;\n#endif // HAS_FOG\n    \n}","players":[],"webGLoptions":{"preserveDrawingBuffer":true},"fastTransparency":true},"evals":[],"jsHooks":[]}
```
