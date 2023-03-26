# `CTProblems.jl`

[gh-ci-img]: https://github.com/control-toolbox/CTProblems.jl/actions/workflows/CI.yml/badge.svg?branch=main
[gh-ci-url]: https://github.com/control-toolbox/CTProblems.jl/actions/workflows/CI.yml?query=branch%3Amain

[gh-co-img]: https://codecov.io/gh/control-toolbox/CTProblems.jl/branch/main/graph/badge.svg?token=YM5YQQUSO3
[gh-co-url]: https://codecov.io/gh/control-toolbox/CTProblems.jl

The `CTProblems.jl` package is part of the [control-toolbox ecosystem](https://github.com/control-toolbox).
[![Build Status][gh-ci-img]][gh-ci-url]
[![Covering Status][gh-co-img]][gh-co-url]
[![Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](http://control-toolbox.github.io/CTProblems.jl/dev)

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
