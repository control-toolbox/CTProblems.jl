function test_simple_integrator()

    # problem = model + solution
    prob = Problem(:integrator, :dim1, :energy) 
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
 
    # solve
    a = xf_ - x0*exp(-tf)
    b = sinh(tf)
    p0 = [a/b] # MINPACK needs a vector of Float64
    shoot_sol = fsolve(shoot!, p0, show_trace=false)
    #println(shoot_sol.x)

    # tests
    p0⁺ = shoot_sol.x
    ocp⁺ = CTFlows.OptimalControlSolution(f((t0, tf), x0, p0⁺[1]))
    x⁺(t) = ocp⁺.state(t)
    p⁺(t) = ocp⁺.adjoint(t)
    u⁺(t) = ocp⁺.control(t) # check if u⁺(t) may be a scalar
    #
    T = sol.times # flow_sol.ode_sol.t
    #
    @testset "energy" begin
        @test normL2(T, t -> (u⁺(t)[1] - sol.control(t)[1]) ) ≈ 0 atol=1e-3
        #@test sol.adjoint(t0) ≈ p0_sol atol=1e-6
        # x, p, objective (need augmented system)
    end

    # afficher dans un tableau style dataframe
    #times = range(t0, tf, 10)
    #println("p⁺ = ", p⁺.(times))
    #println("u⁺ = ", u⁺.(times))
    #println("")
    #println("p = ", sol.adjoint.(times))
    #println("u = ", sol.control.(times))
    #println("")

end