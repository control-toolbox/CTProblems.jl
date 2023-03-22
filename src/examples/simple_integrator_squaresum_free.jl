EXAMPLE=(:integrator, :dim1, :squaresum, :free)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple integrator - min - free"

    # the model
    n=1
    m=1
    t0=0.0
    #tf=1.0
    x0=[0.0]
    xf=[1.0]
    ocp = Model{:autonomous}()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, :initial, t0)
    constraint!(ocp, :initial, x0)
    constraint!(ocp, :final, xf)
    A = [ 0.0 ]
    B = [ 1.0 ]
    constraint!(ocp, :dynamics, (x, u) -> A*x + B*u[1])
    objective!(ocp, :lagrange, (x, u) -> 0.5*(u[1]^2+x[1]^2)) # default is to minimise

    # the solution
    tf = atanh(sqrt(xf[1]^2/(2+xf[1]^2)))
    p0 = [xf[1]/sinh(tf)]
    x(t) = [p0[1]*sinh(t)]
    p(t) = [p0[1]*cosh(t)]
    u(t) = p(t)
    objective = tf + 0.5*xf[1]^2*1/tanh(tf)
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    sol.state_dimension = n
    sol.control_dimension = m
    sol.times = times
    sol.state = x
    sol.state_labels = [ "x" * ctindices(i) for i ∈ range(1, n)]
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