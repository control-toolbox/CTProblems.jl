# [Goddard with state constraints](@id Godda)

This well-known problem[^1] [^2] models the ascent of a rocket through the atmosphere, and we restrict here ourselves to vertical (one dimensional) trajectories.
The state variables are the altitude $r$, speed $v$ and mass $m$ of the rocket during the flight, for a total dimension of 3. 
The rocket is subject to gravity $g$, thrust $u$ and drag force $D$ (function of speed and altitude). The final time $T$ is free, and the objective is to reach a maximal altitude with a bounded fuel consumption.

We thus want to solve the optimal control problem in Mayer form

```math
    \max\, r(T)
```

subject to the control dynamics

```math
    \dot{r} = v, \quad
    \dot{v} = \frac{T_{\max}\,u - D(r,v)}{m} - g, \quad
    \dot{m} = -u,
```

and subject to the control constraint $u(t) \in [0,1]$ and the state constraint
$v(t) \leq v_{\max}$. The initial state is fixed while only the final mass is prescribed.

!!! note

    The Hamiltonian is affine with respect to the control, so singular arcs may occur, as well as constrained arcs due to the path constraint on the velocity (see below).

## Model and solution

```@example main
using CTProblems
using DifferentialEquations
using Plots
```

You can access the problem in the CTProblems package:

```@example main
prob = Problem(:goddard)
```

Then, the model is given by

```@example main
prob.model
```

with 

```julia
function F0(x)
    r, v, m = x
    D = Cd * v^2 * exp(-β*(r - 1))
    return [ v, -D/m - 1/r^2, 0 ]
end
function F1(x)
    r, v, m = x
    return [ 0, Tmax/m, -b*Tmax ]
end
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 700))
```

The solution is given by:

```@example main
# initial costate
println("p0 = ", prob.solution.infos[:initial_costate])

# switching times
println("t1 = ", prob.solution.infos[:switching_times][1])
println("t2 = ", prob.solution.infos[:switching_times][2])
println("t3 = ", prob.solution.infos[:switching_times][3])

# final time
println("T  = ", prob.solution.infos[:final_time])
```

## References

[^1]: R.H. Goddard. A Method of Reaching Extreme Altitudes, volume 71(2) of Smithsonian Miscellaneous Collections. Smithsonian institution, City of Washington, 1919.

[^2]: H. Seywald and E.M. Cliff. Goddard problem in presence of a dynamic pressure limit. Journal of Guidance, Control, and Dynamics, 16(4):776–781, 1993.
