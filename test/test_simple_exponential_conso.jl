function test_simple_exponential_conso()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:exponential, :dim1, :consumption) 
    ocp = prob.model
    sol = prob.solution

    # Flow(ocp, u)
    f0 = Flow(ocp, (x, p) -> 0)
    f1 = Flow(ocp, (x, p) -> 1)

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    xf_ = final_condition(ocp)
    #
    function shoot!(s, p0, t1)
        x1, p1 = f0(t0, x0, p0[1], t1)
        xf, pf = f1(t1, x1, p1, tf)
        s[1] = xf - xf_
        s[2] = p1 - 1
    end

    # tests
    p0 = 1/(x0-(xf_-1)/exp(-tf))
    ξ = [p0, -log(p0)]
    function fparams(ξ)
        p0 = ξ[1]
        t1 = ξ[2]
        f = f0 * (t1, f1)
        return (t0, x0, p0, tf, f)
    end

    nle = (s, ξ) -> shoot!(s, ξ[1], ξ[2])
    test_by_shooting(nle, ξ, fparams, sol, 1e-3, "conso")

end