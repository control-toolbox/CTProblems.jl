EXAMPLE=(:goddard, :classical, :altitude, :x_dim_3, :u_dim_1, :mayer, :x_cons, :u_cons, :singular_arc)

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem with a message, a model and a solution

    # 
    title = "Goddard problem with state constraint - maximise altitude"

    # ------------------------------------------------------------------------------------------
    # the model
    # parameters
    Cd = 310
    Tmax = 3.5
    β = 500
    b = 2
    t0 = 0
    r0 = 1
    v0 = 0
    vmax = 0.1
    m0 = 1
    mf = 0.6
    x0 = [ r0, v0, m0 ]

    function F0(x)
        r, v, m = x
        D = Cd * v^2 * exp(-β*(r - 1))
        return [ v, -D/m - 1/r^2, 0 ]
    end
    function F1(x)
        r, v, m = x
        return [ 0, Tmax/m, -b*Tmax ]
    end
    f(x, u) = F0(x) + u*F1(x)
    
    @def ocp begin
        tf ∈ R, variable
        t ∈ [ t0, tf ], time
        x ∈ R³, state
        u ∈ R, control
        x(t0) == x0,    (initial_con) 
        r = x₁
        v = x₂
        m = x₃
        m(tf) == mf,    (final_con)
        0 ≤ u(t) ≤ 1,   (u_con)
        r0 ≤ r(t) ≤ Inf, (x_con_rmin)
        0 ≤ v(t) ≤ vmax, (x_con_vmax)
        ẋ(t) == f(x(t),u(t))
        r(tf) → max
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    # bang controls
    u0 = 0
    u1 = 1

    # singular control
    H0 = Lift(F0)
    H1 = Lift(F1)
    H01  = @Poisson {H0, H1}
    H001 = @Poisson {H0, H01}
    H101 = @Poisson {H1, H01}
    us(x, p) = -H001(x, p) / H101(x, p)

    # boundary control
    g(x)    = vmax-x[2] # g(x) ≥ 0
    ub(x)   = -Lie(F0, g)(x) / Lie(F1, g)(x)
    μ(x, p) = H01(x, p) / Lie(F1, g)(x)

    # flows
    f0 = Flow(ocp, (x, p, v) -> u0)
    f1 = Flow(ocp, (x, p, v) -> u1)
    fs = Flow(ocp, (x, p, v) -> us(x, p))
    fb = Flow(ocp, (x, p, v) -> ub(x), (x, u, v) -> g(x), (x, p, v) -> μ(x, p))

    # solution
    p0 = [3.945764658668555, 0.15039559623198723, 0.053712712939991955]
    t1 = 0.023509684041475312
    t2 = 0.059737380900899015
    t3 = 0.10157134842460895
    tf = 0.20204744057146434
    
    f1sb0 = f1 * (t1, fs) * (t2, fb) * (t3, f0) # concatenation of the flows
    flow_sol = f1sb0((t0, tf), x0, p0)
    sol = CTFlows.OptimalControlSolution(flow_sol)

    # add to the sol
    sol.objective = flow_sol.ode_sol(tf)[1]
    sol.message = "structure: B+SCB0"
    sol.infos[:resolution] = :numerical

    #
    return OptimalControlProblem(title, ocp, sol)

end