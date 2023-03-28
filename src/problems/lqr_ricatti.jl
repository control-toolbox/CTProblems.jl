EXAMPLE=(:lqr, :dim2, :ricatti)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "lqr - dimension 2 - ricatti"

    # the model
    n=2
    m=1
    t0=0
    tf=1
    x0=[0, 1]
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0)
    A = [ 0 1
        -1 0 ]
    B = [ 0
        1 ]
    constraint!(ocp, :dynamics, (x, u) -> A*x + B*u)
    objective!(ocp, :lagrange, (x, u) -> 0.5*(x[1]^2 + x[2]^2 + u^2))

    # the solution
    Q = I
    R = I
    Rm1 = I 
    a = x0[1]
    b = x0[2]
    
    function LQ_solve(tf)

        ricatti(S, params, t) = S*B*Rm1*B'*S - (S*A + A'*S + Q)
        Sf = zeros(2, 2)
        tspan = (tf, 0)
        prob = ODEProblem(ricatti,Sf,tspan)
        S = solve(prob, Tsit5(), reltol=1e-12, abstol=1e-12)

        tspan = (0, tf)
        dyn(x, params, t) = A*x + B*Rm1*B'*S(t)*x
        prob = ODEProblem(dyn,x0,tspan)
        x = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)

        return x,S
    end

    x,S = LQ_solve(tf)
    p(t) = 0
    u(t) = 0
    objective = 0

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