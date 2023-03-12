using Documenter
using CTProblems
using Plots

makedocs(
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
        "Examples" => Any["double_integrator_energy.md"],
        "API" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/control-toolbox/CTProblems.jl.git",
    devbranch = "main"
)
