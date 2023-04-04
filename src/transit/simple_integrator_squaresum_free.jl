EXAMPLE=(:integrator, :dim1, :squaresum, :free)

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple integrator - square-sum min - free"

    # the model
    n=1
    m=1
    t0=0
    x0=0
    xf=1
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, :initial, t0)
    constraint!(ocp, :initial, x0, :initial_constraint)
    constraint!(ocp, :final, xf, :final_constraint)
    constraint!(ocp, :dynamics, (x, u) -> u)
    objective!(ocp, :lagrange, (x, u) -> 0.5*(u^2+x^2)) # default is to minimise

    # the solution
    tf = atanh(sqrt(xf^2/(2+xf^2)))
    p0 = xf[1]/sinh(tf)
    x(t) = p0*sinh(t)
    p(t) = p0*cosh(t)
    u(t) = p(t)
    objective = tf + 0.5*xf^2*1/tanh(tf)
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    sol.state_dimension = n
    sol.control_dimension = m
    sol.times = times
    sol.state = x
    sol.state_names = [ "x" ]
    sol.adjoint = p
    sol.control = u
    sol.control_names = [ "u" ]
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "analytical solution"
    sol.success = true

    #
    return OptimalControlProblem(msg, ocp, sol)

end