EXAMPLE=(:integrator, :state_dime_1, :state_constraint, :control_constraint, :nonautonomous)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "simple integrator - state and control constraints"

    # the model
    n=1
    m=1
    t0=0
    tf=3
    x0=0
    α=1 
    ocp = Model(time_dependence=:nonautonomous)
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0, :initial_constraint)
    constraint!(ocp, :control, 0, 3, :control_constraint)
    constraint!(ocp, :state, (x,u) -> 1 - x(t) - (t-2)^2, -Inf, 0, :state_constraint)
    constraint!(ocp, :dynamics, (x, u) -> u)
    objective!(ocp, :lagrange, (x, u) -> exp(-α*t)*u)

    # the solution
    arc(t) = [0 ≤ t < 1, 1 ≤ t < 2 , 2 ≤ t ≤ 3]
    x(t) = arc(t)[1]*0 + arc(t)[2]*(1-(t-2)^2) + arc(t)[3]*1
    p(t) = arc(t)[1]*(-exp(-α)) + arc(t)[2]*0 + arc(t)[3]*0
    u(t) = arc(t)[1]*0 + arc(t)[2]*(-2*(t-2)) + arc(t)[3]*0
    objective = 2/α*(2*exp(-α)-exp(-2*α))
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    sol.state_dimension = n
    sol.control_dimension = m
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(x)
    sol.state_names = [ "x" ]
    sol.adjoint = Base.deepcopy(p)
    sol.control = Base.deepcopy(u)
    sol.control_names = [ "u" ]
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "analytical solution"
    sol.success = true

    #
    return OptimalControlProblem(title, ocp, sol)

end
