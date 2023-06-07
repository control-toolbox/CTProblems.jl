EXAMPLE=(:integrator, :energy, :free_final_time, :x_dim_1, :u_dim_1, :lagrange)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "simple integrator - energy min - free tf"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    x0=0

    @def ocp begin
        tf ∈ R, variable
        t ∈ [ t0, tf ], time
        x ∈ R, state
        u ∈ R, control
        x(t0) == x0,    (initial_con)
        x(tf)-tf-10 == 0,  (boundary_constraint) 
        ẋ(t) == u(t)
        ∫( 0.5u(t)^2 ) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    tf = 10
    x(t) = t*(tf+10)/tf
    p(t) = (tf+10)/tf
    u(t) = p(t)
    objective = 1/2 * ((tf+10)^2)/tf
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