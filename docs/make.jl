using GmshSTL
using Documenter

DocMeta.setdocmeta!(GmshSTL, :DocTestSetup, :(using GmshSTL); recursive=true)

makedocs(;
    modules=[GmshSTL],
    authors="Aminofa70 <amin.alibakhshi@upm.es> and contributors",
    sitename="GmshSTL.jl",
    format=Documenter.HTML(;
        canonical="https://Aminofa70.github.io/GmshSTL.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Aminofa70/GmshSTL.jl",
    devbranch="main",
)
