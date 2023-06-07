EXAMPLE=(:integrator, :x_dim_1, :u_dim_1, :lagrange, :mixed_constraint)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "simple integrator - mixed constraint"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    tf=1
    x0=-1

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R, state
        u ∈ R, control
        x(t0) == x0,            (initial_con)
        0 ≤ u(t) ≤ +Inf,        (u_con) 
        -Inf ≤ x(t) + u(t) ≤ 0, (mixed_con)
        ẋ(t) == u(t)
        ∫(-u(t)) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    x(t) = -exp(-t)
    p(t) = exp(t-1) - 1
    u(t) = -x(t)
    objective = exp(-1) - 1
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    copy!(sol,ocp)
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(x)
    sol.costate = Base.deepcopy(p)
    sol.control = Base.deepcopy(u)
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "structure: smooth but the mixed constraint is active all over the solution"
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end
