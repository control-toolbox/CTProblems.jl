# [LQR: energy and distance minimisation](@id LQR)

The energy and distance minimisation LQR problem consists in minimising

```math
    0.5\int_{0}^{5} x_1^2(t) + x_2^2(t) + u^2(t) \, \mathrm{d}t 
```

subject to the constraints

```math
    \dot x_1(t) = x_2(t), \quad \dot x_2(t) = -x_1(t) + u(t), \quad u(t) \in \R
```

and the limit conditions

```math
    x(0) = (0,1)
```

```@example main
using CTProblems
using DifferentialEquations
using Plots
```

You can access the problem in the CTProblems package:

```@example main
prob = Problem(:lqr, :x_dim_2, :u_dim_1, :lagrange)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution)
```
