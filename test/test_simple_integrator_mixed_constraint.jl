function test_simple_integrator_mixed_constraint()

    # ---------------------------------------------------------------
    # problem = model + solution
    prob = Problem(:integrator, :x_dim_1, :u_dim_1, :lagrange, :mixed_constraint) 
    ocp = prob.model
    sol = prob.solution
    title = prob.title

    # Flow(ocp, u)
    u(x, p) = -x
    g(x, u) = x+u
    η(x, p) = -(p+1)
    f = Flow(ocp, u, g, η)

    # shooting function
    t0 = ocp.initial_time
    tf = ocp.final_time
    x0 = initial_condition(ocp)
    #
    function shoot!(s, p0)
        xf, pf = f(t0, x0, p0, tf)
        s[1] = pf
    end
 
    # tests
    p0 = 1
    fparams(p0) = (t0, x0, p0, tf, f, Real[])
    test_by_shooting(ocp, shoot!, p0, fparams, sol, 1e-3, title, flow=:ocp)

end