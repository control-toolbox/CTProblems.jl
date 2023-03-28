# CTProblems.jl

[gh-ci-img]: https://github.com/control-toolbox/CTProblems.jl/actions/workflows/CI.yml/badge.svg?branch=main
[gh-ci-url]: https://github.com/control-toolbox/CTProblems.jl/actions/workflows/CI.yml?query=branch%3Amain

[gh-co-img]: https://codecov.io/gh/control-toolbox/CTProblems.jl/branch/main/graph/badge.svg?token=YM5YQQUSO3
[gh-co-url]: https://codecov.io/gh/control-toolbox/CTProblems.jl

[gh-doc-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[gh-doc-dev-url]: http://control-toolbox.github.io/CTProblems.jl/dev

[gh-doc-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[gh-doc-stable-url]: http://control-toolbox.github.io/CTProblems.jl/stable

The `CTProblems.jl` package is part of the [control-toolbox ecosystem](https://github.com/control-toolbox).

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![Documentation][gh-doc-stable-img]][gh-doc-stable-url] [![Documentation][gh-doc-dev-img]][gh-doc-dev-url] | [![Build Status][gh-ci-img]][gh-ci-url] [![Covering Status][gh-co-img]][gh-co-url] |

## Installation

To install a package from the control-toolbox ecosystem, please visit the [installation page](https://github.com/control-toolbox#installation).

## Overview of CTProblems.jl

The `CTProblems.jl` package provides a list of optimal control problems, each of them is made of a description, the model and the solution. You can get access to any problem by a simple `description`, see [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl).
For instance, to get the energy-min one dimensional exponential problem, simply

```julia
using CTProblems
prob = Problem(:exponential, :dim1, :energy)
```

and to print the complete list of [Problems](@ref):

```julia
Problems()
```

For more details, see the documentation.
