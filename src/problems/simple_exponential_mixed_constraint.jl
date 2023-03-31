EXAMPLE=(:exponential, :dim1, :mixed_constraint)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple exponential - state constraint"

    # the model
    n=1
    m=1
    t0=0
    tf=1
    x0=-1
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0, :initial_constraint)
    constraint!(ocp, :control, -Inf, 0, :control_constraint)
    constraint!(ocp, :mixed, (x,u) -> x - u, -Inf, 0, :mixed_constraint)
    constraint!(ocp, :dynamics, (x, u) -> -u)
    objective!(ocp, :lagrange, (x, u) -> u)

    # the solution
    x(t) = -exp(-t)
    p(t) = 1-exp(t-1)
    u(t) = x(t)
    objective = exp(-1) - 1
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
