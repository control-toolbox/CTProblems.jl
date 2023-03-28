# Developers guide

```@contents
Pages = ["developers.md"]
Depth = 3
```

## How to add a problem

### Find a description

Let us assume you want to add a `planar orbital` transfer problem from space mechanics. This problem will be described by the following `description`, cf. [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl):

```julia
(:orbital, :planar)
```

First, you have to add the description from the list of available problems. You need to add the line

```julia
problems = add(problems, (:orbital, :planar))
```

to the file `src/list_of_problems.jl`:

```julia
# list of problems
problems = ()
problems = add(problems, (:exponential, :dim1, :energy))
...
problems = add(problems, (:orbital, :planar))
problems = add(problems, (:dummy, )) # to test exception not implemented
```

### Create a new file with an empty template

Then, you have to create a new file in the directory `src/problems`. For instance:

```bash
touch src/problems/orbital_planar.jl
```

Then, you can write into this file the following empty template:

```julia
EXAMPLE=(:orbital, :planar) # same description as in src/list_of_problems.jl 

"""
$(TYPEDSIGNATURES)

Returns an OptimalControlProblem with a description, a model and a solution.

Planar orbital transfer

"""
@eval function OptimalControlProblem{EXAMPLE}()

    # the description
    description = "Planar orbital transfer"

    # the model: to be completed
    ocp = Model()

    # the solution: to be completed
    sol = OptimalControlSolution()

    #
    return OptimalControlProblem{EXAMPLE}(msg, ocp, sol)

end
```

### Update `src/CTProblems.jl`

You need then to include this file into the main module. Add the line

```bash
include("problems/orbital_planar.jl")
```

into `src/CTProblems.jl`, after the comment

```julia
# include problems
```

replacing of course the name of the file with the one you have created.

### Code the model and the solution

For now, you have to complete the model and the solution. You can take example from the already existing problems in `src/problems`. See also the documentation of [`CTBase.jl`](https://github.com/control-toolbox/CTBase.jl). Try to fulfill all the fields of `OptimalControlSolution`.

### Add a unit test

To complete the process, a unit test must be created. See the `test` directory for examples. The unit test should be written by a different person to robustify the process.
