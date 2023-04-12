# [List of problems](@id problems-list)

```@contents
Pages = ["problems-list.md"]
Depth = 2
```

## Characteristics of the problems

In the following table, we give some characteristics about the problems and their solutions.

| **Problem**                                   | **(x, u) dims** | **Objective** | **Constraint arc** | **Singular arc** | **Differentiable** |
| :-------------------------------------------- | :-------------- | :------------ | :----------------- | :--------------- | :----------------- |
| [Simple exponential energy](@ref SEE)         | (1, 1)          | `Lagrange`    | ❌                 | ❌               | ✅                 |
| [Simple exponential time](@ref SET)           | (1, 1)          | `Lagrange`    | ❌                 | ❌               | ✅                 |
| [Simple exponential consumption](@ref SEC)    | (1, 1)          | `Lagrange`    | ❌                 | ❌               | ❌ `u`             |
| [Double integrator energy](@ref DIE)          | (2, 1)          | `Lagrange`    | ❌                 | ❌               | ✅                 |
| [Goddard](@ref Godda) ([version 2](@ref Go2)) | (3, 1)          | `Mayer`       | ✅ `x`, `u`        | ✅               | ✅                 |
| [Orbital transfert time](@ref OTT)            | (4, 2)          | `Mayer`       | ❌                 | ❌               | ✅                 |
| [Orbital transfert energy](@ref OTE)          | (4, 2)          | `Mayer`       | ❌                 | ❌               | ✅                 |
| [Orbital transfert consumtion](@ref OTC)      | (4, 2)          | `Mayer`       | ✅ `u`             | ❌               | ❌ `u`             |


Legend:

- **Problem**: a name with a link to the problem page
- **(x, u) dims**: dimension of the state and the control
- **Objective**: `Lagrange`, `Mayer` or `Bolza`
- **Constraint arc** (active on the solution):
  - ❌ (no)
  - ✅ `x`(pure state constraints)
  - ✅ `u` (pure control constraints)
  - ✅ `(x,u)` (mixed state/control constraints)
- **Singular arc**: in the case of affine problems, we tell if the solution has a singular arc, that is a non-empty arc along which the switching function vanishes.
  - ❌ (no)
  - ✅ (yes)
- **Differentiable**:
  - ✅ (yes)
  - ❌ `x` (the dynamics and/or other data from the model is non differentiable wrt to the state)
  - ❌ `u` (the dynamics and/or other data from the model is non differentiable wrt to the control)

## Get some problems for tests

To get all the problems as a tuple of `OptimalControlProblem`, simply

```julia
Problems()
```

To get all the problems with one dimensional state and with a Lagrange cost:

```julia
Problems(:state_dim_1, :lagrange)
```

You can use more sophisticated rules to filter. You simply have to define a logical condition with the combination of symbols and the three operators: `!`, `|` and `&`, respectively for the negation, the disjunction and the conjunction.

Here is an example to get the problems, as a tuple of `OptimalControlProblem`, whom description does not contain `:lagrange`, or contains `:time` (the `or` is not exclusive):

```julia
@Problems !:lagrange | :time
```
