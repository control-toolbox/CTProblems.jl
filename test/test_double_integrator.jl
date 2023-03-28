function test_double_integrator()

    # problem = model + solution
    prob = Problem(:integrator, :dim2, :energy) 
    ocp = prob.model
    sol = prob.solution

    # Flow(ocp, u)
    f = Flow(ocp, (x, p) -> p[2])

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    xf_ = final_condition(ocp)
    #
    function shoot!(s, p0)
        xf, pf = f(t0, x0, p0, tf)
        s[1:2] = xf - xf_
    end

    # tests
    ξ = [12.0, 6.0] # MINPACK needs Float64
    fparams(ξ) = (t0, x0, ξ, tf, f)
    test_by_shooting(shoot!, ξ, fparams, sol, 1e-3, "energy")

end