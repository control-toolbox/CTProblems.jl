# [Introduction to the CTProblems.jl package](@id introduction)

The `CTProblems.jl` package is part of the [control-toolbox ecosystem](https://github.com/control-toolbox).

!!! note

    To install a package from the control-toolbox ecosystem, please visit the [installation page](https://github.com/control-toolbox#installation).

The `CTProblems.jl` package provides a list of optimal control problems composed of a short title (a string), the model and the solution, respectively of types `OptimalControlModel` and `OptimalControlSolution`, defined in the package [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl). You can get any problem by a simple `description`, see [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl), that is a tuple of symbols.

For instance, to get the energy minimisation one dimensional exponential problem, simply

```@example main
using CTProblems
prob = Problem(:exponential, :energy, :state_dim_1)
```

!!! note

    You can give a partial description. The complete description is

    ```bash
    (:exponential, :energy, :state_dim_1, :control_dim_1, :lagrange)
    ```

!!! warning

    If you give a partial description, then, if several complete descriptions contains what is given, then, only the problem with the highest priority is returned. The higher in the list, the higher is the priority.
    See the [list of descriptions](@ref descriptions-list).

Then, the title is given by

```@example main
prob.title
```

The model is given by

```@example main
prob.model
```

And you can plot the solution.

```@example main
plot(prob.solution, size=(700, 500))
```

!!! note

    To get more than one problem, you can use the function [`Problems`](@ref), see also the [list of problems](@ref problems-list).
    