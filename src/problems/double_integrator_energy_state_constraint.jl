EXAMPLE=(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :x_cons, :order_2)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "Double integrator energy - mininimise ∫ u² under the constraint x₁ ≤ l"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    tf=1
    x0=[0, 1]
    xf=[0, -1]
    l = 1/9
    A = [ 0 1
        0 0 ]
    B = [ 0
        1 ]
    
    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R², state
        u ∈ R, control
        x(t0) == x0,                    (initial_con) 
        x(tf) == xf,                    (final_con)
        -Inf ≤ x₁(t) ≤ l,               (x_con)
        ẋ(t) == A * x(t) + B * u(t)
        ∫( 0.5u(t)^2 ) → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution (case l ≤ 1/6 because it has 3 arc)
    arc(t) = [0 ≤ t ≤ 3*l, 3*l < t ≤ 1 - 3*l, 1 - 3*l < t ≤ 1]
    x(t) =  arc(t)[1]*[l*(1-(1-t/(3l))^3), (1-t/(3l))^2] + 
            arc(t)[2]*[l, 0] + 
            arc(t)[3]*[l*(1-(1-(1-t)/(3l))^3), -(1-(1-t)/(3l))^2]
    u(t) =  arc(t)[1]*(-2/(3l)*(1-t/(3l))) + 
            arc(t)[2]*0 + 
            arc(t)[3]*(-2/(3l)*(1-(1-t)/(3l)))
    # p(t) = arc(t)[1]*[2/9*l^2, 2/(3*l)*(1-t/(3*l))] + arc(t)[2]*[0, 0] + arc(t)[3]*[-2/9*l^2, 2/(3*l)*(1-(1-t)/(3*l))]    
    α = -18
    β = -6
    p(t) = arc(t)[1]*[α, -α*t+β] + arc(t)[2]*[0, 0] + arc(t)[3]*[-α, α*(t-2/3)]
    objective = 4/(9l)

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
    sol.message = "structure: "
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end