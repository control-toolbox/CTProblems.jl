EXAMPLE=(:exponential, :time, :x_dim_1, :u_dim_1, :lagrange)

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    #
    title = "simple exponential - time min"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    x0=-1
    xf=0
    γ=1

    @def ocp begin
        tf ∈ R, variable
        t ∈ [ t0, tf ], time
        x ∈ R, state
        u ∈ R, control
        x(t0) == x0,    (initial_con)
        x(tf) == xf,    (final_con)
        -γ ≤ u(t) ≤ γ,  (u_con) 
        ẋ(t) == -x(t) + u(t)
        tf → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    tf = log((-1-γ)/(xf-γ))
    x(t) = (-1-γ)*exp(-t) + γ
    p(t) = exp(t-tf)/(γ-xf)
    u(t) = γ*sign(p(t))
    objective = tf

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
    sol.message = "structure: B+"
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end