function test_simple_exponential_energy()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:exponential, :energy, :state_dim_1, :control_dim_1, :lagrange) 
    ocp = prob.model
    sol = prob.solution

    # Flow(ocp, u)
    f = Flow(ocp, (x, p) -> p)

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    xf_ = final_condition(ocp)
    #
    function shoot!(s, p0)
        xf, pf = f(t0, x0, p0[1], tf)
        s[1] = xf - xf_
    end
 
    # tests
    a = xf_ - x0*exp(-tf)
    b = sinh(tf)
    ξ = [a/b] # MINPACK needs a vector of Float64
    fparams(ξ) = (t0, x0, ξ[1], tf, f)
    test_by_shooting(shoot!, ξ, fparams, sol, 1e-3, "energy")

end