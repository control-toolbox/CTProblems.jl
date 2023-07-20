function test_goddard()

    #
    prob = Problem(:goddard, :classical, :altitude, :x_dim_3, :u_dim_1, 
        :mayer, :x_cons, :u_cons, :singular_arc)
    ocp = prob.model
    sol = prob.solution
    title = prob.title

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

    #
    remove_constraint!(ocp, :x_con_rmin)
    g(x) = vmax-constraint(ocp, :x_con_vmax)(x,Real[]) # g(x, u) ≥ 0 (cf. nonnegative multiplier)
    final_mass_cons(xf) = mf-constraint(ocp, :final_con)(x0, xf, Real[])

    function F0(x)
        r, v, m = x
        D = Cd * v^2 * exp(-β*(r - 1))
        return [ v, -D/m - 1/r^2, 0 ]
    end
    function F1(x)
        r, v, m = x
        return [ 0, Tmax/m, -b*Tmax ]
    end

    # flows
    # bang controls
    u0 = 0
    u1 = 1

    # singular control
    H0 = Lift(F0)
    H1 = Lift(F1)
    H01  = @Lie {H0, H1}
    H001 = @Lie {H0, H01}
    H101 = @Lie {H1, H01}
    us(x, p) = -H001(x, p) / H101(x, p)

    # boundary control
    #g(x)    = vmax-x[2] # g(x) ≥ 0
    ub(x)   = -Lie(F0, g)(x) / Lie(F1, g)(x)
    μ(x, p) = H01(x, p) / Lie(F1, g)(x)

    # flows
    f0 = Flow(ocp, (x, p, v) -> u0)
    f1 = Flow(ocp, (x, p, v) -> u1)
    fs = Flow(ocp, (x, p, v) -> us(x, p))
    fb = Flow(ocp, (x, p, v) -> ub(x), (x, u, v) -> g(x), (x, p, v) -> μ(x, p))

    # shooting function
    t0 = ocp.initial_time
    x0 = initial_condition(ocp)
    function shoot!(s, p0, t1, t2, t3, tf) # B+ S C B0 structure

        x1, p1 = f1(t0, x0, p0, t1)
        x2, p2 = fs(t1, x1, p1, t2)
        x3, p3 = fb(t2, x2, p2, t3)
        xf, pf = f0(t3, x3, p3, tf)
        s[1] = final_mass_cons(xf)
        s[2:3] = pf[1:2] - [ 1, 0 ]
        s[4] = H1(x1, p1)
        s[5] = H01(x1, p1)
        s[6] = g(x2)
        s[7] = H0(xf, pf) # free tf

    end

    # tests
    t1 = 0.02350968402023801
    t2 = 0.05973738095397227
    t3 = 0.10157134841905507
    tf = 0.20204744057725113
    ξ = [3.9457646591162034, 0.15039559628359686, 0.053712712969520515, 
        t1, 
        t2, 
        t3, 
        tf] # initial guess

    function fparams(ξ) 
        # concatenation of the flows
        p0 = ξ[1:3]
        t1, t2, t3, tf = ξ[4:7]
        f1sb0 = f1 * (t1, fs) * (t2, fb) * (t3, f0)
        return t0, x0, p0, tf, f1sb0, tf # t0, x0, p0, tf, flow, tf
    end

    nle = (s, ξ) -> shoot!(s, ξ[1:3], ξ[4], ξ[5], ξ[6], ξ[7])
    test_by_shooting(ocp, nle, ξ, fparams, sol, 1e-3, title)

end