EXAMPLE=(:goddard, :state_constraint)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "Goddard problem with state constraint - maximise altitude"

    # the model
    n = 3
    m = 1
    #
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

    # model
    ocp = Model()

    time!(ocp, :initial, t0) # if not provided, final time is free
    state!(ocp, 3, ["r", "v", "m"]) # state dim
    control!(ocp, 1) # control dim

    constraint!(ocp, :initial, x0)
    constraint!(ocp, :control, u -> u, 0, 1, :control_constraint_1) # constraints can be labeled or not
    constraint!(ocp, :state, x -> x[1], r0, Inf,  :state_constraint_1)
    constraint!(ocp, :state, x -> x[2], 0, vmax,  :state_constraint_2)
    constraint!(ocp, :state, x -> x[3], mf, m0,   :state_constraint_3)

    objective!(ocp, :mayer,  (t0, x0, tf, xf) -> xf[1], :max)

    function F0(x)
        r, v, m = x
        D = Cd * v^2 * exp(-β*(r - 1))
        F = [ v, -D/m - 1/r^2, 0 ]
        return F
    end

    function F1(x)
        r, v, m = x
        F = [ 0, Tmax/m, -b*Tmax ]
        return F
    end

    f(x, u) = F0(x) + u*F1(x)

    constraint!(ocp, :dynamics, f)

    # the solution
    #sol = OptimalControlSolution()

    # bang controls
    u0(x, p) = 0.
    u1(x, p) = 1.

    # singular control of order 1
    H0(x, p) = p' * F0(x)
    H1(x, p) = p' * F1(x)
    H01 = Poisson(H0, H1)
    H001 = Poisson(H0, H01)
    H101 = Poisson(H1, H01)
    us(x, p) = -H001(x, p) / H101(x, p)

    # boundary control
    #remove_constraint!(ocp, :state_constraint_1)
    #remove_constraint!(ocp, :state_constraint_3)
    #constraint!(ocp, :boundary, (t0, x0, tf, xf) -> xf[3], mf, :boundary_constraint_1) # one value => equality (not boxed inequality); changed to equality constraint for shooting
    #
    g(x) = vmax-constraint(ocp, :state_constraint_2)(x) # g(x, u) ≥ 0 (cf. nonnegative multiplier)
    ub(x, _) = -Ad(F0, g)(x) / Ad(F1, g)(x)
    μb(x, p) = H01(x, p) / Ad(F1, g)(x)

    # associated flows
    abstol=1e-12
    reltol=1e-12
    f0 = Flow(ocp, u0, abstol=abstol, reltol=reltol)
    f1 = Flow(ocp, u1, abstol=abstol, reltol=reltol)
    fs = Flow(ocp, us, abstol=abstol, reltol=reltol)
    fb = Flow(ocp, ub, (x, _) -> g(x), μb, abstol=abstol, reltol=reltol)

    # shooting function
#=     function shoot!(s, p0, t1, t2, t3, tf) # B+ S C B0 structure

        x1, p1 = f1(t0, x0, p0, t1)
        x2, p2 = fs(t1, x1, p1, t2)
        x3, p3 = fb(t2, x2, p2, t3)
        xf, pf = f0(t3, x3, p3, tf)
        s[1] = mf-constraint(ocp, :boundary_constraint_1)(t0, x0, tf, xf)
        s[2:3] = pf[1:2] - [ 1, 0 ]
        s[4] = H1(x1, p1)
        s[5] = H01(x1, p1)
        s[6] = g(x2)
        s[7] = H0(xf, pf) # free tf

    end =#

    ξ = [3.945764658668555, 0.15039559623198723, 0.053712712939991955, 
        0.023509684041475312, 
        0.059737380900899015, 
        0.10157134842460895, 
        0.20204744057146434]
    #nle = (s, ξ) -> shoot!(s, ξ[1:3], ξ[4], ξ[5], ξ[6], ξ[7])
    #indirect_sol = fsolve(nle, ξ, show_trace=true)
    #println(indirect_sol)
    #ξ = indirect_sol.x
    p0 = ξ[1:3]
    t1 = ξ[4]
    t2 = ξ[5]
    t3 = ξ[6]
    tf = ξ[7]
    
    f1sb0 = f1 * (t1, fs) * (t2, fb) * (t3, f0) # concatenation of the flows
    flow_sol = f1sb0((t0, tf), x0, p0)
    sol = CTFlows.OptimalControlSolution(flow_sol)

    # objective
    sol.objective = flow_sol.ode_sol(tf)[1]
    
    #
    return OptimalControlProblem{EXAMPLE}(msg, ocp, sol)

end