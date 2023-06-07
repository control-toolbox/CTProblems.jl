function test_simple_integrator_state_and_control_constraints_nonautonomous()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:integrator, :state_dime_1, :lagrange, :x_cons, :u_cons, :nonautonomous) 
    ocp = prob.model
    sol = prob.solution
    title = prob.title

    # Flow(ocp, u)
    #
    f0 = Flow(ocp, (_, _, _) -> 0)
    # constraint
    α = 1
    u = (t, _, _) -> -2*(t-2)
    g = (t, x) -> constraint(ocp, :x_con)(t, x)
    μ = (_, _, p) -> -α*p
    fc = Flow(ocp, u, (t, x, _) -> g(t, x), μ)

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    #
    function shoot!(s, p0, t1, t2, ν2)
        x1, p1 = f0(t0, x0, p0, t1)
        x2, p2 = fc(t1, x1, p1, t2)
        xf, pf = f0(t2, x2, p2+ν2, tf)
        s[1] = pf
        s[2] = g(t1, x1)
        s[3] = p1 - exp(-α*t1)
        s[4] = t2-2
    end

    # tests
    t1 = 1
    t2 = 2
    p0 = 0.35
    ν2 = -0.15
    ξ  = [p0, t1, t2, ν2]

    function fparams(ξ) 
        p0, t1, t2, ν2 = ξ[1:4]
        f = f0 * (t1, fc) * (t2, ν2, f0)
        return t0, x0, p0, tf, f, Real[]
    end

    nle = (s, ξ) -> shoot!(s, ξ...)
    test_by_shooting(ocp, nle, ξ, fparams, sol, 1e-3, title)

end