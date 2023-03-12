# Double integrator - energy min

```@example main
using CTProblems
```

The energy min double integrator problem consists in minimising
```math
    \frac{1}{2}\int_{t_0}^{t_f} u^2(t) \, \mathrm{d}t
```
subject to the constraints
```math
    \dot x_1(t) = x_2(t), \quad \dot x_2(t) = u(t),
```
and the limit conditions
```math
    x(t_0) = (-1, 0), \quad x(t_f) = (0, 0).
```

You can access the problem in the CTProblems package:
```@example main
prob = Problem(:integrator, :dim2, :energy)
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
