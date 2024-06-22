# [Simple exponential: energy minimisation](@id SEE)

The energy minimisation simple exponential problem consists in minimising

```math
    \frac{1}{2}\int_{0}^{1} u^2(t) \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = - x(t) + u(t), u(t) \in \mathbb{R}
```

and the limit conditions

```math
    x(0) = -1, \quad x(1) = 0.
```

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:exponential, :energy)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
using Plots
plot(prob.solution)
```
