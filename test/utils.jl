normL1(T, f) = sum( (T[2:end]-T[1:end-1]) .* [ abs(f(T[i])) for i ∈ 1:length(T)-1] ) 
normL2(T, f) = sqrt(sum( (T[2:end]-T[1:end-1]) .* [ abs(f(T[i]))^2 for i ∈ 1:length(T)-1] ))

function initial_condition(ocp::OptimalControlModel) # pre-condition: there is an x0
    x0 = nothing
    constraints = ocp.constraints
    for (_, c) ∈ constraints
        @match c begin
            (:initial , _, f          , v, w) => begin x0=v end
            (:final   , _, f          , _, _) => nothing
            (:boundary, _, f          , _, _) => nothing
            (:control , _, f::Function, _, _) => nothing
            (:control , _, rg         , _, _) => nothing
            (:state   , _, f::Function, _, _) => nothing
            (:state   , _, rg         , _, _) => nothing
            (:mixed   , _, f          , _, _) => nothing
	    end # match
    end # for
    return x0
end

function final_condition(ocp::OptimalControlModel) # pre-condition: there is a xf
    xf = nothing
    constraints = ocp.constraints
    for (_, c) ∈ constraints
        @match c begin
            (:initial , _, f          , _, _) => nothing
            (:final   , _, f          , v, w) => begin xf=v end
            (:boundary, _, f          , _, _) => nothing
            (:control , _, f::Function, _, _) => nothing
            (:control , _, rg         , _, _) => nothing
            (:state   , _, f::Function, _, _) => nothing
            (:state   , _, rg         , _, _) => nothing
            (:mixed   , _, f          , _, _) => nothing
	    end # match
    end # for
    return xf
end

function test_by_shooting(shoot!, ξ, flow, fparams, sol, atol, title, display=false)

    # solve
    shoot_sol = fsolve(shoot!, ξ, show_trace=display)
    display ? println(shoot_sol) : nothing
    ξ⁺ = shoot_sol.x

    # compute optimal control solution    
    t0, x0, p0⁺, tf = fparams(ξ⁺)
    #
    ocp⁺ = CTFlows.OptimalControlSolution(flow((t0, tf), x0, p0⁺))
    x⁺(t) = ocp⁺.state(t)
    p⁺(t) = ocp⁺.adjoint(t)
    u⁺(t) = ocp⁺.control(t)

    #
    T = sol.times # flow_sol.ode_sol.t

    #
    @testset "$title" begin
        @test normL2(T, t -> (u⁺(t)[1] - sol.control(t)[1]) ) ≈ 0 atol=atol
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