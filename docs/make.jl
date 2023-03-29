using Documenter
using CTProblems

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
        "Problems" => "problems.md",
        "API" => "api.md",
        "Developers" => "developers.md"
    ]
)

deploydocs(
    repo = "github.com/control-toolbox/CTProblems.jl.git",
    devbranch = "main"
)
