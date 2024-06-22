EXAMPLE=(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :u_cons)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "Double integrator energy - mininimise ∫ u² under the constraint |u| ≤ γ"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    tf=1
    x0=[-1, 0]
    xf=[0, 0]
    γ = 5
    A = [ 0 1
        0 0 ]
    B = [ 0
        1 ]

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R², state
        u ∈ R, control
        x(t0) == x0,    (initial_con) 
        x(tf) == xf,    (final_con)
        -γ ≤ u(t) ≤ γ,  (u_con)
        ẋ(t) == A * x(t) + B * u(t)
        ∫( 0.5u(t)^2 ) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    a = x0[1]
    b = x0[2]

    #
    t1(α,β) = (β-γ)/α
    t1(p0) = t1(p0[1], p0[2])

    #
    t2(α,β) = (β+γ)/α
    t2(p0) = t2(p0[1], p0[2])

    # arc 1
    x_arc_1(t,α,β) = [ a + b*t + 0.5*γ*t^2, b + γ*t]
    x_arc_1(t,p0) = x_arc_1(t, p0[1], p0[2])

    c(α,β) = x_arc_1(t1(α,β),α,β)[1]
    d(α,β) = x_arc_1(t1(α,β),α,β)[2] 

    # arc 2
    dp(α,β) = d(α,β) - (-0.5*α*t1(α,β)^2 + β*t1(α,β))
    cp(α,β) = c(α,β) - (dp(α,β)*t1(α,β) - α/6*t1(α,β)^3 + β/2*t1(α,β)^2)
    x_arc_2(t,α,β) = [cp(α,β) + (dp(α,β)*t  - α/6*t^3 + β/2*t^2), dp(α,β) - α/2*t^2 + β*t]
    x_arc_2(t,p0) = x_arc_2(t, p0[1], p0[2])

    e(α,β) = x_arc_2(t2(α,β),α,β)[1]
    f(α,β) = x_arc_2(t2(α,β),α,β)[2]

    # arc 3
    fp(α,β) = f(α,β) + γ*t2(α,β)
    ep(α,β) = e(α,β) - fp(α,β)*t2(α,β) + γ/2*t2(α,β)^2
    x_arc_3(t,α,β) = [ep(α,β) + fp(α,β)*t - γ/2*t^2, fp(α,β) - γ*t]
    x_arc_3(t,p0) = x_arc_3(t, p0[1], p0[2])

    g(α,β) = x_arc_3(tf,α,β)[1]
    h(α,β) = x_arc_3(tf,α,β)[2]

    # solve
    # function shoot!(s,α,β)
    #     s[1] = g(α,β) - xf[1]
    #     s[2] = h(α,β) - xf[2]
    # end

    #=
    #using MINPACK
    p0_ini = [1.5*2*γ/tf, 1.5*γ]
    ξ = [p0_ini[1],p0_ini[2]]
    nle = (s, ξ) -> shoot!(s, ξ[1], ξ[2])
    indirect_sol = fsolve(nle, ξ, show_trace=false)
    #println(indirect_sol)
    p0 = indirect_sol.x
    =#
     
    p0 = [12.90994448735837, 6.454972243678883]

    # the result of the newton method is [12.90994448735837, 6.454972243678883]
    x(t) = (t ≤ t1(p0)) * x_arc_1(t,p0) + (t1(p0) < t < t2(p0)) * x_arc_2(t,p0) + (t ≥ t2(p0)) * x_arc_3(t,p0)
    p(t) = [p0[1], -p0[1]*t+p0[2]]
    u(t) = (t ≤ t1(p0)) * γ + (t1(p0) < t < t2(p0)) * p(t)[2] + (t ≥ t2(p0)) * (-γ)
    objective = 0.5*γ^2*(t1(p0) + tf - t2(p0)) + 0.5*(1/3*(p0[1])^2*(t2(p0)^3 - t1(p0)^3) + p0[1]*p0[2]*(t1(p0)^2 - t2(p0)^2) + (p0[2])^2*(t2(p0) - t1(p0)))

    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution()
    copy!(sol,ocp)
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(x)
    sol.costate = Base.deepcopy(p)
    sol.control = Base.deepcopy(u)
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "structure: B+BaffineB-"
    sol.success = true
    sol.infos[:resolution] = :numerical

    #
    return OptimalControlProblem(title, ocp, sol)

end