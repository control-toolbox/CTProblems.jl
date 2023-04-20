function test_double_integrator_consumption()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:integrator, :consumption, :state_dim_2, :control_dim_1, :lagrange, :control_constraint, :control_non_differentiable) 
    ocp = prob.model
    sol = prob.solution
    title = prob.title

    # Flow(ocp, u)
    γ  = 5
    fm = Flow(ocp, (x, p) -> -γ)
    fp = Flow(ocp, (x, p) -> +γ)
    f0 = Flow(ocp, (x, p) -> 0)

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    xf = final_condition(ocp)
    #
    function shoot!(s, p0, t1, t2)
        x1, p1 = fp(t0, x0, p0, t1)
        x2, p2 = f0(t1, x1, p1, t2)
        xf_, pf = fm(t2, x2, p2, tf)
        s[1:2] = xf_ - xf
        s[3] = p1[2] - 1
        s[4] = p2[2] + 1
    end

    # tests
    t1 = 0.25*tf
    t2 = 0.75*tf
    p0 = [11/tf, 6]
    ξ = [p0..., t1, t2]

    function fparams(ξ) 
        # concatenation of the flows
        p0 = ξ[1:2]
        t1 = ξ[3]
        t2 = ξ[4]
        return t0, x0, p0, tf, fp * (t1, f0) * (t2, fm)
    end

    nle = (s, ξ) -> shoot!(s, ξ[1:2], ξ[3], ξ[4])
    test_by_shooting(nle, ξ, fparams, sol, 1e-3, title)

end