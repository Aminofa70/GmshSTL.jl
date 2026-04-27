using GmshSTL
using FerriteGmsh
using Geogram, FileIO, Comodo, Comodo.GLMakie
using ComodoFerrite, Comodo.Statistics
GLMakie.closeall()


fileName_mesh = joinpath(GmshSTL_dir(), "assets", "stl", "cube_3holes.stl")

M = load(fileName_mesh)
F = tofaces(GeometryBasics.faces(M))
V = topoints(GeometryBasics.coordinates(M))


nb_pts = 5000
@info " the number of vertices in original mesh (STL)" length(V)

@info "original stl file volume" surfacevolume(F,V)
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

@info "mesh volume" sum(tetvolume(E,V))

Fbs, Vbs = separate_vertices(Fb, V)
Cbs_V = simplex2vertexdata(Fbs, CFb_type)
M = GeometryBasics.Mesh(Vbs, Fbs)

fig = Figure(size = (1000, 800))

ax1 = AxisGeom(fig[1, 1], title = "Mesh")
hp2 = meshplot!(ax1, Fbs, Vbs; strokewidth = 2)
# hp3 = normalplot(ax2,M_Fb; type_flag=:face, color=:black,linewidth=3)


ax2 = AxisGeom(fig[1, 2], title = "Cut view of mesh")
hp3 = meshplot!(ax2, Fbs, Vbs; strokewidth = 2, color = :white)

VE = simplexcenter(E, V)
ZE = [v[3] for v in VE]
Z = [v[3] for v in V]
zMax = maximum(Z)
zMin = minimum(Z)

numSlicerSteps = 10

stepRange = range(zMin, zMax, numSlicerSteps)
hSlider = Slider(fig[2, :], range = stepRange, startvalue = mean(stepRange), linewidth = 30)

on(hSlider.value) do z
    B = ZE .<= z
    indShow = findall(B)
    if isempty(indShow)
        hp3.visible = false
    else
        hp3.visible = true
        Fs = element2faces(E[indShow])
        Fs, Vs = separate_vertices(Fs, V)
        Ms = GeometryBasics.Mesh(Vs, Fs)
        hp3[1] = Ms
    end
end
slidercontrol(hSlider, ax2)

display(GLMakie.Screen(), fig)