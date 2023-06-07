EXAMPLE=(:lqr, :x_dim_2, :u_dim_1, :lagrange)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "lqr - dimension 2 - ricatti"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    tf=5
    x0=[0, 1]
    A = [0 1 ; -1 0]
    B = [0 ; 1]

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R², state
        u ∈ R, control
        x(t0) == x0,    (initial_con) 
        ẋ(t) == A * x(t) + B * u(t)
        ∫( 0.5*(x₁(t)^2 + x₂(t)^2 + u(t)^2) ) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    Q = I
    R = I
    Rm1 = I
    a = x0[1]
    b = x0[2]

    # computing S
    ricatti(S) = -S*B*Rm1*B'*S - (-Q+A'*S+S*A)
    f = Flow(ricatti, autonomous=true, variable=false)
    S = f((tf, t0), zeros(size(A)))

    # computing x
    dyn(t, x) = A*x + B*Rm1*B'*S(t)*x
    f = Flow(dyn, autonomous=false, variable=false)
    x = f((t0, tf), x0)

    # computing u
    u(t) = Rm1*B'*S(t)*x(t) 
    
    # computing p
    ϕ(t, p) = [p[2]+x(t)[1], x(t)[2]-p[1]]
    f = Flow(ϕ, autonomous=false, variable=false)
    p = f((tf, t0), zeros(2))

    # computing objective
    ψ(t) = 0.5*(x(t)[1]^2 + x(t)[2]^2 + u(t)^2)
    f = Flow((t, _) -> ψ(t), autonomous=false, variable=false)
    obj = f((t0, tf), 0)
    objective = obj(tf)
    
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution()
    copy!(sol,ocp)
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(t -> x(t))
    sol.costate = Base.deepcopy(t -> p(t))
    sol.control = Base.deepcopy(u)
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "structure: smooth"
    sol.success = true
    sol.infos[:resolution] = :numerical

    #
    return OptimalControlProblem(title, ocp, sol)

end