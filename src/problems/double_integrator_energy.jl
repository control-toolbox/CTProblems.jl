EXAMPLE=(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :noconstraints)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "Double integrator energy - minimise ∫ u²"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    tf=1
    x0=[-1, 0]
    xf=[0, 0]
    A = [ 0 1
        0 0 ]
    B = [ 0
        1 ]

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R², state
        u ∈ R, control
        x(t0) == [-1, 0],    (initial_con) 
        x(tf) == [0, 0],    (final_con)
        ẋ(t) == A * x(t) + B * u(t)
        ∫( 0.5u(t)^2 ) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    a = x0[1]
    b = x0[2]
    C = [-(tf-t0)^3/6 (tf-t0)^2/2
         -(tf-t0)^2/2 (tf-t0)]
    D = [-a-b*(tf-t0), -b]+xf
    p0 = C\D
    α = p0[1]
    β = p0[2]
    x(t) = [a+b*(t-t0)+β*(t-t0)^2/2.0-α*(t-t0)^3/6.0, b+β*(t-t0)-α*(t-t0)^2/2.0]
    p(t) = [α, -α*(t-t0)+β]
    u(t) = p(t)[2]
    objective = 0.5*(α^2*(tf-t0)^3/3+β^2*(tf-t0)-α*β*(tf-t0)^2)

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
