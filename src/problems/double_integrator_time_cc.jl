EXAMPLE=(:integrator, :dim2, :time , :constraint)

@eval function OptimalControlProblem{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "Double integrator - time min - control constraint"

    # the model
    n=2
    m=1
    t0=0
    x0=[-1, 0]
    xf=[0, 0]
    γ = 1
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, :initial, t0)
    constraint!(ocp, :initial, x0)
    constraint!(ocp, :final,   xf)
    A = [ 0 1
        0 0 ]
    B = [ 0
        1 ]
    constraint!(ocp, :dynamics, (x, u) -> A*x + B*u)
    constraint!(ocp, :control, u -> u, -γ, γ)
    objective!(ocp, :mayer,  (t0, x0, tf, xf) -> tf, :min) 

    # the solution
    a = x0[1]
    b = x0[2]

    t1(α,β) = β/α
    tf(α,β) = (1-γ*β)/(γ*α)
    # arc 1
    x_arc_1(t,α,β) = [ a + b*t + 0.5*γ*t^2, b + γ*t]

    c(α,β) = x_arc_1(t1(α,β),α,β)[1]
    d(α,β) = x_arc_1(t1(α,β),α,β)[2] 

    # arc 2
    dp(α,β) = d(α,β) + γ*t1(α,β)
    cp(α,β) = c(α,β) - dp(α,β)*t1(α,β) + 0.5*γ*t1(α,β)^2
    x_arc_2(t,α,β) = [cp(α,β)+ dp(α,β)*t - 0.5*γ*t^2, dp(α,β)-γ*t]

    e(α,β) = x_arc_2(tf(α,β),α,β)[1]
    f(α,β) = x_arc_2(tf(α,β),α,β)[2]


    # solve
    #S(α,β) = [e(α,β),f(α,β)] - xf
    function shoot!(s,α,β)
        s[1] = e(α,β) - xf[1]
        s[2] = f(α,β) - xf[2]
    end

    #using MINPACK
    p0_ini = [0.1, 1.5/(2*γ)]
    ξ = [p0_ini[1],p0_ini[2]]
    nle = (s, ξ) -> shoot!(s, ξ[1], ξ[2])
    indirect_sol = fsolve(nle, ξ, show_trace = true)
    println(indirect_sol)
     
    # the result of the newton method
    p0 = indirect_sol.x
    println("α = ", p0[1], " β = ", p0[2])
    println("Times ",t1(p0[1],p0[2]),"  ",tf(p0[1],p0[2]))
    x(t) = (t ≤ t1(p0[1],p0[2]))*x_arc_1(t,p0[1],p0[2]) + (t1(p0[1],p0[2])≤t)*x_arc_2(t,p0[1],p0[2])
    p(t) = [p0[1],-p0[1]*t + p0[2]]
    u(t) = (t<t1(p0[1],p0[2]))*γ + (t1(p0[1],p0[2])≤t)*(-γ)
    objective = tf(p0[1],p0[2])

    #
    N=201
    times = range(t0, tf(p0[1],p0[2]), N)
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