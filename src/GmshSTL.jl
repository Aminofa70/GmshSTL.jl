module GmshSTL

using Gmsh
using LinearAlgebra
export gmsh_mesh_stl

"""
Create a 3D volumetric mesh from a surface mesh `(F, V)` using Gmsh and save it to `output_path`.

Parameters:
- `F`: face connectivity (triangles), indexing into `V`
- `V`: vertex coordinates (points in 3D)

- `algorithm3d`: Gmsh 3D meshing algorithm
    Options:
        `1` → Delaunay (robust, general-purpose)
        `4` → Frontal (good quality, default)
        `7` → MMG3D (adaptive/remeshing)

- `min_length`: minimum characteristic mesh size (smallest elements)

- `max_length`: maximum characteristic mesh size (largest elements)

- `optimize_netgen`: enable Netgen optimization
        `0` → off
        `1` → on (improves mesh quality)

- `quality`: Gmsh mesh quality metric type
        `2` → radius ratio (recommended)

- `msh_version`: output `.msh` file version
        `2.2` → widely compatible
        `4.1` → newer format

- `angle_tol`: tolerance for detecting overlapping facets (e.g. `0.05`)

- `verbosity`: Gmsh verbosity level
        `0` → silent
        `1` → errors only
        `2` → info (default)
        `3+` → debug output

- `output_path`: path to save the generated mesh file

Notes:
- `(F, V)` must define a closed (watertight) surface.
- The surface is internally written to a temporary STL file before being passed to Gmsh.
- A tetrahedral (3D) mesh is generated inside the enclosed volume.
"""
function gmsh_mesh_stl(
        F, V, algorithm3d, min_length, max_length, optimize_netgen
        , quality, msh_version, angle_tol, verbosity, output_path
    )

    # Step 2: Write temp STL for Gmsh
    tmp_stl = tempname() * ".stl"
    open(tmp_stl, "w") do io
        println(io, "solid remeshed")
        for f in F
            v1 = V[f[1]]; v2 = V[f[2]]; v3 = V[f[3]]
            e1 = v2 - v1; e2 = v3 - v1
            n = cross(e1, e2)
            nm = norm(n)
            n = nm > 0 ? n / nm : n
            println(io, "  facet normal $(n[1]) $(n[2]) $(n[3])")
            println(io, "    outer loop")
            println(io, "      vertex $(v1[1]) $(v1[2]) $(v1[3])")
            println(io, "      vertex $(v2[1]) $(v2[2]) $(v2[3])")
            println(io, "      vertex $(v3[1]) $(v3[2]) $(v3[3])")
            println(io, "    endloop")
            println(io, "  endfacet")
        end
        println(io, "endsolid remeshed")
    end

    # Step 3: Gmsh volumetric meshing

    gmsh.initialize()
    gmsh.clear()
    gmsh.option.setNumber("Mesh.Algorithm3D", algorithm3d)
    gmsh.option.setNumber("Mesh.CharacteristicLengthMin", min_length)
    gmsh.option.setNumber("Mesh.CharacteristicLengthMax", max_length)
    gmsh.option.setNumber("Mesh.OptimizeNetgen", optimize_netgen)
    gmsh.option.setNumber("Mesh.QualityType", quality)
    gmsh.option.setNumber("Mesh.MshFileVersion", msh_version)
    gmsh.option.setNumber("Mesh.AngleToleranceFacetOverlap", angle_tol)
    gmsh.option.setNumber("General.Verbosity", verbosity)

    return try
        gmsh.merge(tmp_stl)
        n = gmsh.model.getDimension()
        s = gmsh.model.getEntities(n)
        surf = gmsh.model.geo.addSurfaceLoop([s[i][2] for i in 1:length(s)])
        gmsh.model.geo.addVolume([surf])
        gmsh.model.geo.synchronize()

        println("Generating 3D mesh...")
        gmsh.model.mesh.generate(3)

        println("Saving to: $output_path")
        gmsh.write(output_path)
    catch e
        rethrow(e)
    finally
        gmsh.finalize()
        rm(tmp_stl, force = true)
    end
end # end of the function


export GmshSTL_dir
function GmshSTL_dir()
    return joinpath(@__DIR__, "..")
end


end # end of module
