EXAMPLE=(:exponential, :dim1, :energy)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple exponential - energy min"

    # the model
    n=1
    m=1
    t0=0
    tf=1
    x0=-1
    xf=0
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0)
    constraint!(ocp, :final,   xf)
    constraint!(ocp, :dynamics, (x, u) -> -x + u)
    objective!(ocp, :lagrange, (x, u) -> 0.5u^2) # default is to minimise

    # the solution
    a = xf - x0*exp(-tf)
    b = sinh(tf)
    p0 = a/b
    x(t) = p0*sinh(t) + x0*exp(-t)
    p(t) = exp(t)*p0
    u(t) = p(t)
    objective = (exp(2)-1)*p0^2/4 
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
