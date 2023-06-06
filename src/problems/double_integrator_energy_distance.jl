EXAMPLE=(:integrator, :energy, :distance, :x_dim_2, :u_dim_1, :bolza)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "Double integrator energy/distance - minimise -x₁ + ∫ u²"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    tf=1
    x0=[0, 0]
    A = [ 0 1
        0 0 ]
    B = [ 0
        1 ]

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R², state
        u ∈ R, control
        x(t0) == x0,    (initial_con) 
        ẋ(t) == A * x(t) + B * u(t)
        -0.5x₁(tf) + ∫( 0.5u(t)^2 ) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    a = x0[1]
    b = x0[2]
    α = 0.5
    β = tf/2
    x(t) = [a+ b*t + t^2/12*(3*tf-t), b + t/4*(2*tf-t)]
    p(t) = [α, -α*t+β]
    u(t) = p(t)[2]
    objective = -0.5*x(tf)[1] + (1/3)*(tf^3/8)
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
    sol.message = "structure: smooth"
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end