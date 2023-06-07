function test_double_integrator_energy_state_constraint()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :x_cons, :order_2) 
    ocp = prob.model
    sol = prob.solution
    title = prob.title

    #
    fs = Flow(ocp, (x, p) -> p[2])
    l = 1/9
    u = FeedbackControl(x -> 0)
    g = StateConstraint(x -> x[1]-l)
    μ = Multiplier((x, p) -> 0)
    fc = Flow(ocp, u, g, μ)

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    xf_ = final_condition(ocp)
    #
    function shoot!(s, p0, t1, t2, ν1, ν2)
        x1, p1 = fs(t0, x0, p0, t1)
        x2, p2 = fc(t1, x1, p1+ν1*[1, 0], t2)
        xf, pf = fs(t2, x2, p2+ν2*[1, 0], tf)
        s[1:2] = xf_ - xf
        s[3] = g(x1)
        s[4] = x1[2]
        s[5] = p1[2]
        s[6] = p2[2]
    end

    # tests
    t1 = 1/3
    t2 = 2/3
    p0 = [-18, -6]
    ν1 = 18
    ν2 = 18
    ξ  = [p0..., t1, t2, ν1, ν2]

    function fparams(ξ) 
        p0 = ξ[1:2]
        t1, t2, ν1, ν2 = ξ[3:6]
        f = fs * (t1, ν1*[1, 0], fc) * (t2, ν2*[1, 0], fs)
        return (t0, x0, p0, tf, f, Real[])
    end

    nle = (s, ξ) -> shoot!(s, ξ[1:2], ξ[3:6]...)
    test_by_shooting(ocp, nle, ξ, fparams, sol, 1e-3, title)

end