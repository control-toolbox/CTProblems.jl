EXAMPLE=(:integrator, :state_dime_1, :lagrange, :x_cons, :u_cons, :nonautonomous)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "simple integrator - state and control constraints - nonautonomous"

    # the model
    n=1
    m=1
    t0=0
    tf=3
    x0=0
    α=1 

    @def ocp begin
        t ∈ [ t0, tf ], time
        x ∈ R, state
        u ∈ R, control
        x(t0) == x0,    (initial_con)
        0 ≤ u(t) ≤ 3,   (u_con) 
        -Inf ≤ 1-x(t)-(t-2)^2 ≤ 0,  (x_con)
        ẋ(t) == u(t)
        ∫exp(-α*t)*u(t) → min
    end
    # ocp = Model(autonomous=false)
    # state!(ocp, n)   # dimension of the state
    # control!(ocp, m) # dimension of the control
    # time!(ocp, [t0, tf])
    # constraint!(ocp, :initial, x0, :initial_constraint)
    # constraint!(ocp, :control, 0, 3, :u_cons)
    # constraint!(ocp, :state, (t, x) -> 1-x-(t-2)^2, -Inf, 0, :x_cons)
    # dynamics!(ocp, (t, x, u) -> u)
    # objective!(ocp, :lagrange, (t, x, u) -> exp(-α*t)*u)

    # the solution
    arc(t) = [0 ≤ t < 1, 1 ≤ t < 2 , 2 ≤ t ≤ 3]
    x(t) = arc(t)[1]*0 + arc(t)[2]*(1-(t-2)^2) + arc(t)[3]*1
    p(t) = arc(t)[1]*(exp(-α)) + arc(t)[2]*exp(-α*t) + arc(t)[3]*0
    u(t) = arc(t)[1]*0 + arc(t)[2]*(-2*(t-2)) + arc(t)[3]*0
    objective = exp(-2*α)/α^2 * (2*exp(α)*(α-1) + 2)
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    copy!(sol,ocp)
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(x)
    sol.costate = Base.deepcopy(p)
    sol.control = Base.deepcopy(u)
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "structure: 0C0"
    sol.success = true
    sol.infos[:resolution] = :analytical

    #
    return OptimalControlProblem(title, ocp, sol)

end
