# Simple exponential: time minimisation

The time minimisation simple exponential problem consists in minimising

```math
    tf
```

subject to the constraints

```math
    \dot x(t) = - x(t) + u(t), u(t) \in [-1,1]
```

and the limit conditions

```math
    x(0) = -1, \quad x(1) = 0.
```

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:exponential, :dim1, :time)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```
