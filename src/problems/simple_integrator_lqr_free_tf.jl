EXAMPLE=(:integrator, :lqr, :free_final_time, :x_dim_1, :u_dim_1, :bolza)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "simple integrator - bolza cost: tf + ½ ∫ x²+u²"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    x0=0
    xf=1

    @def ocp begin
        tf ∈ R, variable
        t ∈ [ t0, tf ], time
        x ∈ R, state
        u ∈ R, control
        x(t0) == x0,    (initial_con)
        x(tf) == xf,    (final_con)
        ẋ(t) == u(t)
        tf + ∫(0.5*(u(t)^2 + x(t)^2)) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    tf = atanh(sqrt(xf^2/(2+xf^2)))
    p0 = xf[1]/sinh(tf)
    x(t) = p0*sinh(t)
    p(t) = p0*cosh(t)
    u(t) = p(t)
    objective = tf + 0.5*xf^2*1/tanh(tf)

    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution()
    copy!(sol,ocp)
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(x)
    sol.costate = Base.deepcopy(p)
    sol.control = Base.deepcopy(u)
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "structure: smooth"
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end