EXAMPLE=(:turnpike, :dim1)
add_to_list_of_problems = true

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple turnpike - state energy min"

    # the model
    n=1
    m=1
    t0=0
    tf=2
    x0=1
    xf=0.5
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0, :initial_constraint)
    constraint!(ocp, :final, xf, :final_constraint)
    constraint!(ocp, :control, -1, 1, :control_constraint)
    constraint!(ocp, :dynamics, (x, u) -> u)
    objective!(ocp, :lagrange, (x, u) -> x^2) # default is to minimise

    # the solution
    t1 = x0
    t2 = tf - xf
    p(t) = (t0 ≤ t ≤ t1)*((t1^2 - t^2) + 2*x0*(t - t1)) + (t1 < t ≤ t2)*0 + (t2 ≤ t ≤ tf)*((t^2 - t2^2) + 2*(xf-tf)*(t - t2))
    u(t) = (t0 ≤ t ≤ t1)*(-1) + (t1 < t ≤ t2)*0 + (t2 ≤ t ≤ tf)*(1)
    x(t) = (t0 ≤ t ≤ t1)*(-t + x0) + (t1 < t ≤ t2)*0 + (t2 ≤ t ≤ tf)*(t - tf + xf) 
    objective = t1^3/3 - t1^2*x0 + t1*x0^2 + 1/3*(tf^3-t2^3) + (xf-tf)*(tf^2-t2^2) + (xf-tf)^2*(tf-t2)
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
    return OptimalControlProblem(msg, ocp, sol)

end