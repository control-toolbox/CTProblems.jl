# Simple integrator

```@example main
using CTProblems
```

The energy min double integrator problem consists in minimising

```math
    \frac{1}{2}\int_{0}^{1} u^2(t) \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = - x(t) + u(t),
```

and the limit conditions

```math
    x(0) = -1, \quad x(1) = 0.
```

You can access the problem in the CTProblems package:

```@example main
prob = Problem(:integrator, :dim1, :energy)
nothing # hide
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution)
```
