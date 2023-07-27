using Documenter
using CTProblems
using CTBase

DocMeta.setdocmeta!(CTBase, :DocTestSetup, :(using CTBase); recursive = true)
DocMeta.setdocmeta!(CTProblems, :DocTestSetup, :(using CTProblems); recursive = true)

makedocs(
    doctest = true,
    modules = [CTProblems],
    sitename = "CTProblems.jl",
    format = Documenter.HTML(prettyurls = false),
    strict = [
        :doctest,
        :linkcheck,
        :parse_error,
        :example_block,
        # Other available options are
        # :autodocs_block, :cross_references, :docs_block, :eval_block, :example_block, :footnote, :meta_block, :missing_docs, :setup_block
    ],
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
