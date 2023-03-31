EXAMPLE=(:integrator, :dim1, :time, :free, :control_constraint)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "simple integrator - time min - free - control constraint"

    # the model
    n=1
    m=1
    t0=0
    x0=-1
    xf=0
    γ=0.5
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, :initial, t0)
    constraint!(ocp, :initial, x0, :initial_constraint)
    constraint!(ocp, :final, xf, :final_constraint)
    constraint!(ocp, :control, -γ, γ, :control_constraint) # constraints can be labeled or not
    constraint!(ocp, :dynamics, (x, u) -> -x + u)
    objective!(ocp, :mayer, (t0, x0, tf, xf) -> tf, :min)

    # the solution
    tf = log((-1-γ)/(xf-γ))
    x(t) = (-1-γ)*exp(-t) + γ
    p(t) = exp(t-tf)/(γ-xf)
    u(t) = γ*sign(p(t))
    objective = tf

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