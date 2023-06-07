EXAMPLE=(:turnpike, :integrator, :state_energy, :x_dim_1, :u_dim_1, :lagrange, :u_cons, :singular_arc)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "simple nonsmooth turnpike - state energy min - affine system in u"

    # ------------------------------------------------------------------------------------------
    # the model
    n=1
    m=1
    t0=0
    tf=2
    x0=1
    xf=0.5

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R, state
        u ∈ R, control
        x(t0) == x0,    (initial_con)
        x(tf) == xf,    (final_con)
        -1 ≤ u(t) ≤ 1,  (u_con) 
        ẋ(t) == u(t)
        ∫(x(t)^2) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    t1 = x0
    t2 = tf - xf
    p(t) = (t0 ≤ t ≤ t1)*((t1^2 - t^2) + 2*x0*(t - t1)) + (t1 < t ≤ t2)*0 + (t2 ≤ t ≤ tf)*((t^2 - t2^2) + 2*(xf-tf)*(t - t2))
    u(t) = (t0 ≤ t ≤ t1)*(-1) + (t1 < t ≤ t2)*0 + (t2 ≤ t ≤ tf)*(1)
    x(t) = (t0 ≤ t ≤ t1)*(-t + x0) + (t1 < t ≤ t2)*0 + (t2 ≤ t ≤ tf)*(t - tf + xf) 
    objective = t1^3/3 - t1^2*x0 + t1*x0^2 + 1/3*(tf^3-t2^3) + (xf-tf)*(tf^2-t2^2) + (xf-tf)^2*(tf-t2)
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
    sol.message = "structure: -1 0 +1"
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end