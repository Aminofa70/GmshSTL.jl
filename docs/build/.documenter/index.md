


# GmshSTL (Package), I have {#GmshSTL-Package,-I-have}

Documentation for [GmshSTL](https://github.com/Aminofa70/GmshSTL.jl).
- [`GmshSTL.gmsh_mesh_stl`](#GmshSTL.gmsh_mesh_stl-NTuple{11,%20Any})

<details class='jldocstring custom-block' open>
<summary><a id='GmshSTL.gmsh_mesh_stl-NTuple{11, Any}' href='#GmshSTL.gmsh_mesh_stl-NTuple{11, Any}'><span class="jlbinding">GmshSTL.gmsh_mesh_stl</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



Create a 3D volumetric mesh from a surface mesh `(F, V)` using Gmsh and save it to `output_path`.

Parameters:
- `F`: face connectivity (triangles), indexing into `V`
  
- `V`: vertex coordinates (points in 3D)
  
- `algorithm3d`: Gmsh 3D meshing algorithm   Options:       `1` → Delaunay (robust, general-purpose)       `4` → Frontal (good quality, default)       `7` → MMG3D (adaptive/remeshing)
  
- `min_length`: minimum characteristic mesh size (smallest elements)
  
- `max_length`: maximum characteristic mesh size (largest elements)
  
- `optimize_netgen`: enable Netgen optimization       `0` → off       `1` → on (improves mesh quality)
  
- `quality`: Gmsh mesh quality metric type       `2` → radius ratio (recommended)
  
- `msh_version`: output `.msh` file version       `2.2` → widely compatible       `4.1` → newer format
  
- `angle_tol`: tolerance for detecting overlapping facets (e.g. `0.05`)
  
- `verbosity`: Gmsh verbosity level       `0` → silent       `1` → errors only       `2` → info (default)       `3+` → debug output
  
- `output_path`: path to save the generated mesh file
  

Notes:
- `(F, V)` must define a closed (watertight) surface.
  
- The surface is internally written to a temporary STL file before being passed to Gmsh.
  
- A tetrahedral (3D) mesh is generated inside the enclosed volume.
  


<Badge type="info" class="source-link" text="source"><a href="https://github.com/Aminofa70/GmshSTL.jl/blob/590f8ebea91621619649dd198a87941e83330353/src/GmshSTL.jl#L7-L49" target="_blank" rel="noreferrer">source</a></Badge>

</details>

