normL1(T, f) = sum( (T[2:end]-T[1:end-1]) .* [ abs(f(T[i])) for i ∈ 1:length(T)-1] ) 
normL2(T, f) = sqrt(sum( (T[2:end]-T[1:end-1]) .* [ abs(f(T[i]))^2 for i ∈ 1:length(T)-1] ))

range(i,j) = i == j ? i : i:j 

function initial_condition(ocp::OptimalControlModel) # pre-condition: there is an x0
    x0 = nothing
    constraints = ocp.constraints
    for (_, c) ∈ constraints
        @match c begin
            (:initial , f          , v, w) => begin x0=v end
            (:final   , f          , _, _) => nothing
            (:boundary, f          , _, _) => nothing
            (:control , f::Function, _, _) => nothing
            (:control , rg         , _, _) => nothing
            (:state   , f::Function, _, _) => nothing
            (:state   , rg         , _, _) => nothing
            (:mixed   , f          , _, _) => nothing
	    end # match
    end # for
    return x0
end

function final_condition(ocp::OptimalControlModel) # pre-condition: there is a xf
    xf = nothing
    constraints = ocp.constraints
    for (_, c) ∈ constraints
        @match c begin
            (:initial , f          , _, _) => nothing
            (:final   , f          , v, w) => begin xf=v end
            (:boundary, f          , _, _) => nothing
            (:control , f::Function, _, _) => nothing
            (:control , rg         , _, _) => nothing
            (:state   , f::Function, _, _) => nothing
            (:state   , rg         , _, _) => nothing
            (:mixed   , f          , _, _) => nothing
	    end # match
    end # for
    return xf
end

function test_by_shooting(ocp, shoot!, ξ, fparams, sol, atol, title; 
            display=false, flow=:ocp, test_objective=true, objective=nothing)

    # solve
    # MINPACK needs a vector of Float64
    # isreal = ξ isa Real
    # shoot_sol = fsolve((s, ξ) -> isreal ? shoot!(s, ξ[1]) : shoot!(s, ξ), 
    #     Float64.(isreal ? [ξ] : ξ), 
    #     show_trace=display)
    # display ? println(shoot_sol) : nothing
    # ξ⁺ = Base.deepcopy(isreal ? shoot_sol.x[1] : shoot_sol.x) # may not work without deepcopy

    # NonLinearSolve
    isreal = ξ isa Real
    function fun(du, u, p)
        isreal ? shoot!(du, u[1]) : shoot!(du, u)
    end
    prob = NonlinearProblem(fun, Float64.(isreal ? [ξ] : ξ))
    shoot_sol = init(prob, NewtonRaphson(); show_trace = Val(true), abstol=1e-1*atol, reltol=1e-1*atol, maxiters=100) #, sensealg=AutoFiniteDiff());
    solve!(shoot_sol)
    #println(shoot_sol.timer)
    #shoot_sol = solve(prob; show_trace=Val(true), sensealg=AutoFiniteDiff())
    ξ⁺ = Base.deepcopy(isreal ? shoot_sol.u[1] : shoot_sol.u) # may not work without deepcopy

    #
    T = sol.times # flow_sol.ode_sol.t
    n = sol.state_dimension
    m = sol.control_dimension

    x⁺ = nothing
    p⁺ = nothing
    u⁺ = nothing

    t0, x0, p0⁺, tf, f, v = fparams(ξ⁺) # compute optimal control solution    
    ocp⁺ = CTFlows.OptimalControlSolution(f((t0, tf), x0, p0⁺, v))
    x⁺ = t -> ocp⁺.state(t)
    p⁺ = t -> ocp⁺.costate(t)
    u⁺ = t -> ocp⁺.control(t)

    #
    @testset "$title" begin
        for i ∈ 1:n
            subtitle = "state " * string(i)
            @testset "$subtitle" begin
                Test.@test normL2(T, t -> (x⁺(t)[i] - sol.state(t)[i]) ) ≈ 0 atol=atol
            end
        end
        for i ∈ 1:n
            subtitle = "costate " * string(i)
            @testset "$subtitle" begin
                Test.@test normL2(T, t -> (p⁺(t)[i] - sol.costate(t)[i]) ) ≈ 0 atol=atol
            end
        end
        for i ∈ 1:m
            subtitle = "control " * string(i)
            @testset "$subtitle" begin
                Test.@test normL2(T, t -> (u⁺(t)[i] - sol.control(t)[i]) ) ≈ 0 atol=atol
            end
        end
        if test_objective
            if !isnothing(objective)
                @testset "objective - perso" begin
                    Test.@test objective(ξ⁺) ≈ sol.objective atol=atol
                end
            elseif !isnothing(ocp.mayer) && isnothing(ocp.lagrange)
                # Mayer case
                @testset "objective - mayer case" begin
                    Test.@test ocp.mayer(x0, x⁺(tf), v) ≈ sol.objective atol=atol #Test.@test ocp.mayer(t0, x0, tf, x⁺(tf)) ≈ sol.objective atol=atol
                end
            elseif isnothing(ocp.mayer) && !isnothing(ocp.lagrange)
                # Lagrange case
                @testset "objective - lagrange case" begin
                    ϕ(_, _, t) = [ocp.lagrange(t, x⁺(t), u⁺(t), v)]
                    tspan = (t0, tf)
                    x0 = [0.0]
                    prob = ODEProblem(ϕ, x0, tspan)
                    ode_sol = solve(prob, Tsit5(), reltol=1e-6, abstol=1e-6)
                    Test.@test ode_sol(tf)[1] ≈ sol.objective atol=atol rtol=1e-5
                end
            elseif !isnothing(ocp.mayer) && !isnothing(ocp.lagrange)
                # Bolza case
                @testset "objective - bolza case" begin
                    ϕ(_, _, t) = [ocp.lagrange(t, x⁺(t), u⁺(t), v)]
                    tspan = (t0, tf)
                    x0 = [0.0]
                    prob = ODEProblem(ϕ, x0, tspan)
                    ode_sol = solve(prob, Tsit5(), reltol=1e-6, abstol=1e-6)
                    Test.@test ocp.mayer(x0, x⁺(tf), v) + ode_sol(tf)[1] ≈ sol.objective atol=atol rtol=1e-5 #Test.@test ocp.mayer(t0, x0, tf, x⁺(tf)) + ode_sol(tf)[1] ≈ sol.objective atol=atol rtol=1e-5
                end
            end
        end
    end
end