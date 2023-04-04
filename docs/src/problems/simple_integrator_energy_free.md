# Simple integrator - energy min - free

```@example main
using CTProblems
```

The energy min double integrator problem consists in minimising
```math
    \frac{1}{2}\int_{0}^{t_f} u^2(t) \, \mathrm{d}t
```
subject to the constraints
```math
    \dot x(t) = u(t),
```
and the limit conditions
```math
    x(0) = 0, \quad c(t_f,x(t_f)) = 0, \\
    c(t_f,x_f) = x_f - t_f - 10, \text{ free } t_f > 0.
```

You can access the problem in the CTProblems package:
```@example main
prob = Problem(:integrator, :dim1, :energy, :free)
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
