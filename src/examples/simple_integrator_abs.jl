EXAMPLE=(:integrator, :dim1, :absolute, :constraint)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple integrator - absolute min - control constraint"

    # the model
    n=1
    m=1
    t0=0.0
    tf=1.0
    x0=-1.0
    xf=0.0
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0)
    constraint!(ocp, :final,   xf)
    constraint!(ocp, :dynamics, (x, u) -> -x + u)
    constraint!(ocp, :control, u -> u, -1., 1.) # constraints can be labeled or not
    objective!(ocp, :lagrange, (x, u) -> abs(u)) # default is to minimise

    # the solution
    p0 = 1/(x0-(xf-1)/exp(-tf))
    p(t) = exp(t)*p0
    u(t) = (abs(p(t)) > 1) ? sign(p(t)) : 0
    x(t) = (abs(p(t)) < 1) ? (x0*exp(-t)) : ((xf-1)*exp(tf-t) + 1) 
    objective = 1 + log(p0)
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