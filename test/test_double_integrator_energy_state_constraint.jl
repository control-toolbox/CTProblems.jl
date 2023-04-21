function test_double_integrator_energy_state_constraint()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:integrator, :energy, :state_dim_2, :control_dim_1, :lagrange, :state_constraint, :order_2) 
    ocp = prob.model
    sol = prob.solution
    title = prob.title

    # Flow(ocp, u)
    #
    fs = Flow(ocp, (x, p) -> p[2])
    # constraint
    A = [ 0 1
        0 0 ]
    F0(x) = A*x
    B = [ 0
        1 ]
    F1(x) = B
    H0(x, p) = p' * F0(x)
    H1(x, p) = p' * F1(x)
    H01 = Poisson(H0, H1)
    H001 = Poisson(H0, H01)
    H101 = Poisson(H1, H01)
    uc(x, _) = 0
    F01(x) = ...
    μc(x, p) = H001(x, p) / 
    fc = Flow(ocp, (x, p) -> 0)

    # shooting function
    t0 = ocp.initial_time
    x0 = initial_condition(ocp)
    xf = final_condition(ocp)
    #
    function shoot!(s, p0, t1, tf)
        x1, p1 = fp(t0, x0, p0, t1)
        xf_, pf = fm(t1, x1, p1, tf)
        s[1:2] = xf_ - xf
        s[3] = p1[2]
        s[4] = pf[1]*xf_[2]+pf[2]*(-γ) - 1
    end

    # tests
    t1 = 1
    tf = 2
    p0 = [1, 1]
    ξ = [p0..., t1, tf]

    function fparams(ξ) 
        # concatenation of the flows
        p0 = ξ[1:2]
        t1, tf = ξ[3:4]
        return t0, x0, p0, tf, fp * (t1, fm)
    end

    nle = (s, ξ) -> shoot!(s, ξ[1:2], ξ[3], ξ[4])
    test_by_shooting(nle, ξ, fparams, sol, 1e-3, title)

end