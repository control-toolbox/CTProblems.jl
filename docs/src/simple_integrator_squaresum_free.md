# Simple integrator - square sum min - free

```@example main
using CTProblems
```

The energy min double integrator problem consists in minimising
```math
    t_f + \frac{1}{2}\int_{0}^{t_f} (x^2(t) + u^2(t)) \, \mathrm{d}t
```
subject to the constraints
```math
    \dot x(t) = u(t),
```
and the limit conditions
```math
    x(0) = 0, \quad x(t_f) = x_f, \text{ free } t_f > 0.
```

You can access the problem in the CTProblems package:
```@example main
prob = Problem(:integrator, :dim1, :squaresum, :free)
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
