using Documenter
using DocumenterMermaid
using CTProblems
using CTBase

DocMeta.setdocmeta!(CTBase, :DocTestSetup, :(using CTBase); recursive = true)
DocMeta.setdocmeta!(CTProblems, :DocTestSetup, :(using CTProblems); recursive = true)

makedocs(
    warnonly = :cross_references,
    doctest = true,
    modules = [CTProblems],
    sitename = "CTProblems.jl",
    format = Documenter.HTML(
        prettyurls = false,
        assets=[
            asset("https://control-toolbox.org/assets/css/documentation.css"),
            asset("https://control-toolbox.org/assets/js/documentation.js"),
        ],
    ),
    pages = [
        "Introduction" => "index.md",
        "Problems" => ["descriptions-list.md", "problems-list.md"],
        "API" => "api.md",
        "Developers" => ["dev-api.md", "dev-add-pb.md"],
    ]
)

deploydocs(
    repo = "github.com/control-toolbox/CTProblems.jl.git",
    devbranch = "main"
)
