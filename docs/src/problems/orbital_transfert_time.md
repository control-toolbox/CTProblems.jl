# [Orbital transfert: time minimisation](@id OTT)

The time minimisation orbital transfer problem consists in minimising

```math
    t_f
```

subject to the constraints

```math
    \dot x_1(t) = x_3(t) \\
    \dot x_2(t) = x_4(t) \\
    \dot x_3(t) = -\frac{\mu*x_1(t)}{r(t)^3} + u_1(t) \\
    \dot x_4(t) = -\frac{\mu*x_2(t)}{r(t)^3} + u_2(t) \\
    \lVert u(t) \rVert \leq \gamma_{max} \\
    r(t) = \sqrt{x_1(t)^2 + x_2(t)^2}
```

and the limit conditions

```math
    x_1(0) = x_{0,1}, \quad x_2(0) = x_{0,2}, \quad x_3(0) = x_{0,3}, \quad x_4(0) = x_{0,4} \\
    r(tf) = r_f, \quad x_3(t_f) = -\sqrt{\frac{\mu}{{r_f}^3}}*x_2(t_f), \quad x_4(t_f) = -\sqrt{\frac{\mu}{{r_f}^3}}*x_1(t_f) \\
```

with the constants

```math
t_0 = 0 \\
x0 = [-42272.67, 0, 0, -5796.72] \\
μ      = 5.1658620912*1e12 \\
rf     = 42165 \\
m_0     = 2000 \\
F_{max} = 100 \\
γ_{max}  = \frac{F_{max}*3600.0^2}{m_0*10^3} \\
```

```@example main
using CTProblems
using DifferentialEquations
using Plots
```

You can access the problem in the CTProblems package:

```@example main
prob = Problem(:orbital_transfert, :time)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution)
```
