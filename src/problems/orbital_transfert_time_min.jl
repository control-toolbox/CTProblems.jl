EXAMPLE=(:orbital_transfert, :dim4, :time)
add_to_list_of_problems = true

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "Orbital transfert - time min"

    # the model
    n=4
    m=2

    x0     = [-42272.67, 0, 0, -5796.72] # état initial
    μ      = 5.1658620912*1e12
    rf     = 42165.0 ;
    F_max  = 100.0
    γ_max  = F_max*3600.0^2/(2000.0*10^3)
    t0     = 0.0
    rf3    = rf^3  ;
    α      = sqrt(μ/rf3);

    t0=0.0
    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, :initial, t0)
    constraint!(ocp, :initial, x0)
    constraint!(ocp, :boundary, (t0, x0, tf, xf) -> [sqrt(xf[1]^2 + xf[2]^2)-rf, xf[3] + α*xf[2], xf[4] - α*xf[1]],[0,0,0])
    A = [ 0 0 1 0; 0 0 0 1; 1 0 0 0; 0 1 0 0]
    B = [ 0 0; 0 0; 1 0; 0 1 ]
    constraint!(ocp, :dynamics, (x, u) -> A*[-μ*x[1]/(sqrt(x[1]^2 + x[2]^2)^3);-μ*x[2]/(sqrt(x[1]^2 + x[2]^2)^3);x[3];x[4]] + B*u)
    objective!(ocp, :mayer, (t0, x0, tf, xf) -> tf) # default is to minimise

    # the solution
    x(t) = [0,0,0,0]
    p(t) = [0,0,0,0]
    u(t) = [0,0]
    tf = 1
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
    sol.state_labels = [ "x" * ctindices(i) for i ∈ range(1, n)]
    sol.adjoint = p
    sol.control = u
    sol.control_labels = [ "u" * ctindices(i) for i ∈ range(1, m)]
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "analytical solution"
    sol.success = true

    #
    return OptimalControlProblem(msg, ocp, sol)

end