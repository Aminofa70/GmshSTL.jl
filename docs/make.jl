using GmshSTL
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(GmshSTL, :DocTestSetup, :(using GmshSTL); recursive=true)

makedocs(;
    modules=[GmshSTL],
    authors="Aminofa70 <amin.alibakhshi@upm.es> and contributors",
    sitename="GmshSTL.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo="github.com/Aminofa70/GmshSTL.jl",
        devbranch="main",
        devurl="dev",
    ),
    pages = [
    "Home" => "index.md",

    "Tutorials" => [
        "Getting started" => "tutorials/getting-started.md",

        "Demos" => [
            "Mesh Cube 3 Holes" => "tutorials/demo_0001.md",
           # "Demo 0002" => "tutorials/demo_0002.md",
        ],
    ],

    "API Reference" => "api.md",
]
)

DocumenterVitepress.deploydocs(;
    repo="github.com/Aminofa70/GmshSTL.jl.git",
    target=joinpath(@__DIR__, "build"),
    branch="gh-pages",
    devbranch="main",
    push_preview=true
)