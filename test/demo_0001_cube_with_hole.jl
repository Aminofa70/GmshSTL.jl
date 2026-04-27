@testset "check a cube with the hole " begin

using GmshSTL
using FerriteGmsh
using Geogram, FileIO, Comodo
using ComodoFerrite, Comodo.Statistics


# < 1% → very accurate
# 1–5% → good / acceptable
# 5–10% → moderate
# > 10% → large

fileName_mesh = joinpath(GmshSTL_dir(), "assets", "stl", "cube_3holes.stl")

M = load(fileName_mesh)
F = tofaces(GeometryBasics.faces(M))
V = topoints(GeometryBasics.coordinates(M))


nb_pts = 5000
V_stl = surfacevolume(F,V)

F, V, _, _ = mergevertices(F, V)

F, V = ggremesh(
    F, V; nb_pts = nb_pts, remesh_anisotropy = 3.0,
    remesh_gradation = 0.1, pre_max_hole_area = 0,
    pre_max_hole_edges = 0, post_max_hole_area = 0,
    quiet = 0, suppress = true
)

algorithm3d = 1.0
min_length = 2.0
max_length = 4.0
optimize_netgen = 1.0
quality = 2.0
msh_version = 2.2
angle_tol = 0.05
verbosity = 2
output_path = joinpath(GmshSTL_dir(), "assets", "msh", "cube_3holes.msh")


result = gmsh_mesh_stl(
    F, V, algorithm3d, min_length, max_length, optimize_netgen
    , quality, msh_version, angle_tol, verbosity, output_path
)

grid = FerriteGmsh.togrid(output_path)

E, V, F, Fb, CFb_type = FerriteToComodo(grid)

V_mesh =  sum(tetvolume(E,V))

@test V_mesh ≈ V_stl rtol=0.03


end 