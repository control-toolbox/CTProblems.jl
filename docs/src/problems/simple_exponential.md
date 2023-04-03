# Simple exponential

The simple exponential dynamics is given by $\dot{x} = -x + u$.

```@contents
Pages =  ["simple_exponential.md"]
Depth = 2
```

## Energy minimisation problem

### Presentation of the problem

The energy-min simple exponential problem consists in minimising

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

### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:exponential, :dim1, :energy)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```

## Consumption minimisation problem with control constraint

### Presentation of the problem

The consumption-min simple exponential problem consists in minimising

```math
    \int_{0}^{1} |u(t)| \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = - x(t) + u(t), u(t) \in [-1,1]
```

and the limit conditions

```math
    x(0) = -1, \quad x(1) = 0.
```

### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:exponential, :dim1, :absolute, :control_constraint)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```

## Time minimisation problem with control constraint

### Presentation of the problem

The consumption-min simple exponential problem consists in minimising

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

### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:integrator, :dim1, :time, :free, :control_constraint)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```