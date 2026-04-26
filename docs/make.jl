using GmshSTL
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(GmshSTL, :DocTestSetup, :(using GmshSTL); recursive=true)

makedocs(;
    modules=[GmshSTL],
    authors="Aminofa70 <amin.alibakhshi@upm.es> and contributors",
    sitename="GmshSTL.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo="https://github.com/Aminofa70/GmshSTL.jl",
        devbranch="main",
        devurl="dev",
    ),
    pages=[
        "Home" => "index.md",
    ],
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/Aminofa70/GmshSTL.jl.git",
    target = joinpath(@__DIR__, "build"),
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,
)

####################################################################################
####################################################################################

# using GmshSTL
# using Documenter

# DocMeta.setdocmeta!(GmshSTL, :DocTestSetup, :(using GmshSTL); recursive=true)

# makedocs(;
#     modules=[GmshSTL],
#     authors="Aminofa70 <amin.alibakhshi@upm.es> and contributors",
#     sitename="GmshSTL.jl",
#     format=Documenter.HTML(;
#         canonical="https://Aminofa70.github.io/GmshSTL.jl",
#         edit_link="main",
#         assets=String[],
#     ),
#     pages=[
#         "Home" => "index.md",
#     ],
# )

# deploydocs(;
#     repo="github.com/Aminofa70/GmshSTL.jl",
#     devbranch="main",
# )
