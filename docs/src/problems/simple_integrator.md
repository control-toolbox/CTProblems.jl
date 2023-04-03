# Simple integrator

The simple integrator dynamics is given by $\dot{x} = u$.

```@contents
Pages =  ["simple_integrator.md"]
Depth = 3
```

## Without state constraint

### Energy minimisation problem with free final state and time

#### Presentation of the problem

The energy-min simple integrator with free fina state and time problem consists in minimising

```math
    \frac{1}{2}\int_{0}^{tf} u^2(t) \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = u(t), u(t) \in \mathbb{R}
```

and the limit conditions

```math
    x(0) = -1, \quad x(tf) - tf - 10 = 0.
```

#### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:integrator, :dim1, :energy, :free)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```

### Square-sum minimisation problem with free final time

#### Presentation of the problem

The square-sum-min simple integrator with free final time problem consists in minimising

```math
    tf + \frac{1}{2}\int_{0}^{tf} u(t)^2 + x(t)^2 \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = u(t), u(t) \in \mathbb{R}
```

and the limit conditions

```math
    x(0) = 0, \quad x(tf) = 1.
```

#### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:integrator, :dim1, :squaresum, :free)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```

### Squared position minimisation problem with turnpike

#### Presentation of the problem

The consumption-min simple integrator problem consists in minimising

```math
    \int_{0}^{2} x(t)^2 \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) =u(t), u(t) \in \mathbb{R}
```

and the limit conditions

```math
    x(0) = 1, \quad x(2) = 0.5.
```

#### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:turnpike, :dim1)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```

## With state constraint

### Constraint minimisation problem with mixed constraint and free final state

#### Presentation of the problem

The constraint-min simple integrator problem consists in minimising

```math
    -\int_{0}^{1} u(t) \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = u(t), u(t) \in [0,\infty], \\
    x(t) + u(t) \in [-\infty,0]
```

and the limit conditions

```math
    x(0) = -1, \quad x(1) = xf.
```

#### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:integrator, :dim1, :mixed_constraint)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```

### Constraint minimisation problem with state and control constraint and free final state

#### Presentation of the problem

The constraint-min simple integrator problem consists in minimising

```math
    \int_{0}^{3} e^{-α*t}*u(t) \, \mathrm{d}t
```

subject to the constraints

```math
    \dot x(t) = u(t), u(t) \in [0,3], \\
    1 - x(t) - (t-1)^2 \in [-\infty,0]
```

and the limit conditions

```math
    x(0) = 0, \quad x(1) = xf.
```

#### The problem from CTProblems.jl

You can access the problem in the CTProblems package:

```@example main
using CTProblems
prob = Problem(:integrator, :dim1, :state_constraint, :control_constraint, :non_autonomous)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 400))
```