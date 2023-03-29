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
    A = [ 0 1 ; -1 0 ]
    B = [ 0 ; 1 ]
    constraint!(ocp, :dynamics, (x, u) -> A*x + B*u)
    objective!(ocp, :lagrange, (x, u) -> 0.5*(x[1]^2 + x[2]^2 + u^2))

    # the solution
    Id = [1 0 ; 0 1]
    Q = Id
    R = Id 
    Rm1 = Id
    a = x0[1]
    b = x0[2]

    ricatti(S, params, t) = S*(B'*Rm1*B)*S - (S*A + A'*S + Q)
    Sf = zeros(size(A))
    tspan = (tf, 0)
    prob = ODEProblem(ricatti,Sf,tspan)
    sol_S = solve(prob, Tsit5(), reltol=1e-12, abstol=1e-12)

    function S(t)
        i = argmin(abs.(t.-sol_S.t))
        return sol_S.u[i]
    end    

    tspan = (0, tf)
    dyn(x, params, t) = A*x + (B'*Rm1*B)*S(t)*x
    prob = ODEProblem(dyn,x0,tspan)
    sol_x = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)

    function x(t)
        i = argmin(abs.(t.-sol_x.t))
        return sol_x.u[i]
    end    
    u(t) = -((Rm1*B)'*S(t))*x(t) 
    h = 1e-8
    up(t) = (u(t+h)-u(t))/h
    p(t) = [x(t)[2]-up(t),u(t)]
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