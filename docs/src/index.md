# Introduction to the `CTProblems.jl` package

The `CTProblems.jl` package is part of the [control-toolbox ecosystem](https://github.com/control-toolbox). We give below an overview ot the `CTProblems.jl` package with the list of available optimal control problems.

**Contents.**

```@contents
Pages = ["index.md", "problems.md", "api.md", "developers.md"]
Depth = 2
```

## Installation

To install a package from the control-toolbox ecosystem, please visit the [installation page](https://github.com/control-toolbox#installation).

## Overview of CTProblems.jl

The `CTProblems.jl` package provides a list of optimal control problems, each of them is made of a description, the model and the solution. You can get access to any problem by a simple `description`, see [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl).
For instance, to get the energy-min one dimensional exponential problem, simply

```@example main
using CTProblems
prob = Problem(:exponential, :dim1, :energy)
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
