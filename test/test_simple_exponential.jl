function test_simple_exponential()

    # problem = model + solution
    prob = Problem(:exponential, :dim1, :energy) 
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
    fparams(ξ) = (t0, x0, ξ[1], tf)
    test_by_shooting(shoot!, ξ, f, fparams, sol, 1e-3, "energy")

end