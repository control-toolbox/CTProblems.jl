# Problems

In the following table, we give some hints about the problems and their solutions.

| **Problem**                                | **(x, u) dims** | **Objective** | **Constraints** | **Singular arc** | **Differentiable** |
| :----------------------------------------- | :-------------- | :------------ | :-------------- | :--------------- | :----------------- |
| [Simple exponential energy](@ref SEE)      | (1, 1)          | `Lagrange`    | ❌              | ❌               | ✅                 |
| [Simple exponential time](@ref SET)        | (1, 1)          | `Lagrange`    | ❌              | ❌               | ✅                 |
| [Simple exponential consumption](@ref SEC) | (1, 1)          | `Lagrange`    | ❌              | ❌               | ❌ `u`             |
| [Double integrator energy](@ref DIE)       | (2, 1)          | `Lagrange`    | ❌              | ❌               | ✅                 |
| [Goddard](@ref Godda)                      | (3, 1)          | `Mayer`       | ✅ `x`, `u`     | ✅               | ✅                 |

Legend:

- **Problem**: an id / link to the problem
- **(x, u) dims**: dimension of the state and the control
- **Objective**: `Lagrange`, `Mayer` or `Bolza`
- **Constraints** (active on the solution):
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
  