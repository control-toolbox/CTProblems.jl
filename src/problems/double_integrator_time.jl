EXAMPLE=(:integrator, :time, :x_dim_2, :u_dim_1, :mayer, :u_cons)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "Double integrator time - minimise tf under the constraint |u| ≤ γ"

    # ------------------------------------------------------------------------------------------
    # the model
    t0=0
    x0=[-1, 0]
    xf=[0, 0]
    γ = 1
    A = [ 0 1
          0 0 ]
    B = [ 0
          1 ]

    @def ocp begin
        tf ∈ R, variable
        t ∈ [ t0, tf ], time
        x ∈ R², state
        u ∈ R, control
        x(t0) == x0,    (initial_con) 
        x(tf) == xf,    (final_con)
        -γ ≤ u(t) ≤ γ,  (u_con)
        ẋ(t) == A * x(t) + B * u(t)
        tf → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution
    a = x0[1]
    b = x0[2]

    t1 = sqrt(-a)
    tf = 2*t1
    α = 1/t1
    β = 1
    p(t) = [α, -α*t + β]
    u(t) = (t<t1)*γ + (t1≤t)*(-γ)
    x2_arc1(t) = t*γ + b
    x2_arc2(t) = (tf-t)*γ + xf[2] 
    x(t) = (t<t1)*[ 0.5*x2_arc1(t)^2 + a, x2_arc1(t)] + (t1≤t)*[-0.5*x2_arc2(t)^2, x2_arc2(t)]
    objective = tf

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
    sol.message = "structure: B+B-"
    sol.success = true
    sol.infos[:resolution] = :analytical
    #
    return OptimalControlProblem(title, ocp, sol)

end
