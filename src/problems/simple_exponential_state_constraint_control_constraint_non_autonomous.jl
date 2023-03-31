EXAMPLE=(:exponential, :dim1, :state_constraint, :control_constraint, :non_autonomous)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple exponential - state constraint"

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
    sol.times = times
    sol.state = x
    sol.state_labels = [ "x" ]
    sol.adjoint = p
    sol.control = u
    sol.control_labels = [ "u" ]
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "analytical solution"
    sol.success = true

    #
    return OptimalControlProblem{EXAMPLE}(msg, ocp, sol)

end
