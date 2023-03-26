# CTProblems.jl

[gh-ci-img]: https://github.com/control-toolbox/CTProblems.jl/actions/workflows/CI.yml/badge.svg?branch=main
[gh-ci-url]: https://github.com/control-toolbox/CTProblems.jl/actions/workflows/CI.yml?query=branch%3Amain

[gh-co-img]: https://codecov.io/gh/control-toolbox/CTProblems.jl/branch/main/graph/badge.svg?token=YM5YQQUSO3
[gh-co-url]: https://codecov.io/gh/control-toolbox/CTProblems.jl

[gh-doc-img]: https://img.shields.io/badge/docs-dev-blue.svg
[gh-doc-url]: http://control-toolbox.github.io/CTProblems.jl/dev

The `CTProblems.jl` package is part of the [control-toolbox ecosystem](https://github.com/control-toolbox).

[![Build Status][gh-ci-img]][gh-ci-url]
[![Covering Status][gh-co-img]][gh-co-url]
[![Documentation][gh-doc-img]][gh-doc-url]

---

## Installation

To install a package from the control-toolbox ecosystem, you must add its registry into your `Julia` configuration.

Start `Julia`:

```shell
shell> julia

   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.8.2 (2022-09-29)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |
```

Then, add `ct-registry` to the list of known registries:

```shell
julia> ]
pkg> registry add https://github.com/control-toolbox/ct-registry.git
```

Finally, you can install any package as usual. For instance:

```shell
pkg> add CTProblems
```

---

## Overview of `CTProblems.jl`

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

For more details, see the [documentation][gh-doc-url].
