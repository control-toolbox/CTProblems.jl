# Developers guide

```@contents
Pages = ["developers.md"]
Depth = 3
```

## How to add a problem

### Find a description

Let us assume you want to add a `planar orbital time minimisation` transfer problem from space mechanics. 
This problem will be described by a `description`, cf. [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl),
following the `nomenclature` given in `src/CTProblems.jl`. For instance:

```julia
(:orbital, :time, :state_dim_4, control_dim_2, :mayer)
```

### Create a new file with an empty template

You have to create a new file in the directory `src/problems`. For instance:

```bash
touch src/problems/orbital_planar.jl
```

Add it to the list of problems, in `src/CTProblems.jl`:

```julia
list_of_problems_files = [
    "double_integrator_energy.jl",
    "orbital_planar.jl"
]
```

Then, you can write into this file the following empty template:

```julia
EXAMPLE=(:orbital, :time, :state_dim_4, control_dim_2, :mayer)
@eval function OCPDef{EXAMPLE}()

    # the description
    description = "Planar orbital transfer"

    # the model: to be completed
    ocp = Model()

    # the solution: to be completed
    sol = OptimalControlSolution()

    ...

    sol.message = "structure: ..."  # give the structure as an additional info. B+S for 
                                    # positive bang followed by singular arc.
    sol.infos[:resolution] = :numerical # either :numerical or :analytical
                                        # depending on how you get the solution

    #
    return OptimalControlProblem(msg, ocp, sol)

end
```

### Code the model and the solution

For now, you have to complete the model and the solution. You can take example from the already existing problems in `src/problems`. See also the documentation of [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl). Try to fulfill all the fields of `OptimalControlSolution`.

### Add a unit test

To complete the process, a unit test must be created. See the `test` directory for examples. The unit test should be written by a different person to robustify the process.
