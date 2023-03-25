# CTProblems.jl

```@contents
Pages = ["index.md"]
Depth = 3
```

## Control-toolbox ecosystem

### Presentation

The `CTProblems.jl` package is part of the [control-toolbox ecosystem](https://github.com/control-toolbox)
which gathers `Julia` packages for mathematical control and applications. It is an outcome of a research initiative supported by the [Centre Inria of Université Côte d'Azur](https://www.inria.fr/en/inria-centre-universite-cote-azur) and a sequel to previous developments, notably [Bocop](https://www.bocop.org) and [Hampath](https://www.hampath.org). See also: [ct gallery](https://ct.gitlabpages.inria.fr/gallery). The root package is [OptimalControl.jl](https://github.com/control-toolbox/OptimalControl.jl) which aims to provide tools to solve optimal control problems by direct and indirect methods.

[![doc OptimalControl.jl](https://img.shields.io/badge/doc-OptimalControl.jl-blue)](https://control-toolbox.github.io/OptimalControl.jl)

An optimal control problem can be described as minimising the cost functional

```math
g(t_0, x(t_0), t_f, x(t_f)) + \int_{t_0}^{t_f} f^{0}(t, x(t), u(t))~\mathrm{d}t
```

where the state $\large{x}$ and the control $\large{u}$ are functions subject, for $\large{t \in [t_0, t_f]}$,
to the differential constraint

```math
   \dot{x}(t) = f(t, x(t), u(t))
```

and other constraints such as

```math
\begin{array}{llcll}
~\xi_l  &\le& \xi(t, u(t))        &\le& \xi_u, \\
\psi_l &\le& \psi(t, x(t), u(t)) &\le& \psi_u, \\
\eta_l &\le& \eta(t, x(t))       &\le& \eta_u, \\
\phi_l &\le& \phi(t_0, x(t_0), t_f, x(t_f)) &\le& \phi_u.
\end{array}
```

### Installation

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

### Main repositories

The [main repositories](https://github.com/orgs/control-toolbox/repositories?type=all) of the control-toolbox ecosystem are:

* [`bocop`](https://github.com/control-toolbox/bocop): Bocop3, a direct solver for optimal control problem developed in `C++`
* [`ct-registry`](https://github.com/control-toolbox/ct-registry): the control-toolbox registry since the packages are not yet available in the [official registry](https://github.com/JuliaRegistries/General)
* [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl): fundamentals of the control-toolbox ecosystem
* [`CTDirect.jl`](https://github.com/control-toolbox/CTDirect.jl): direct transcription of an optimal control problem and resolution
* [`CTDirectShooting.jl`](https://github.com/control-toolbox/CTDirectShooting.jl): direct shooting transcription of an optimal control problem and resolution
* [`CTFlows.jl`](https://github.com/control-toolbox/CTFlows.jl): classical flow, Hamiltonian flow, flow from optimal control problem
* [`CTProblems.jl`](https://github.com/control-toolbox/CTProblems.jl): library of optimal control problems
* [`OptimalControl.jl`](https://github.com/control-toolbox/OptimalControl.jl): main package
* [`PathFollowing.jl`](https://github.com/control-toolbox/PathFollowing.jl): path following methods

### Discussions

We discuss about the control-toolbox ecosystem here:

* [![Github Issues](https://img.shields.io/github/issues-search?color=green&label=open%20issues&query=is%3Aopen%20is%3Aissue%20user%3Acontrol-toolbox%20archived%3Afalse)](https://github.com/issues?q=is%3Aopen+is%3Aissue+user%3Acontrol-toolbox+archived%3Afalse+)
* [![GitHub Discussions](https://img.shields.io/github/discussions/control-toolbox/control-toolbox.github.io?color=green)](https://github.com/orgs/control-toolbox/discussions)
* [![GitHub Wiki](https://img.shields.io/badge/wiki-ct-green)](https://github.com/control-toolbox/control-toolbox.github.io/wiki)

## Overview of `CTProblems.jl`

The `CTProblems.jl` package provides a list of optimal control problems, each of them is made of a description, the model and the solution. You can get access to any problem by a simple `description`, see [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl).
For instance, to get the energy-min one dimensional integrator problem, simply

```@example main
using CTProblems
prob = Problem(:integrator, :dim1, :energy)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution)
```

## List of problems

To print the complete list of [Problems](@ref):

```@example main
Problems()
```
