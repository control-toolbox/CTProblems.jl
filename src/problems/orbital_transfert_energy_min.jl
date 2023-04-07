EXAMPLE=(:orbital_transfert, :dim4, :energy)

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "Orbital transfert - energy min"

    # the model
    n=4
    m=2

    x0     = [-42272.67, 0, 0, -5796.72] # état initial
    μ      = 5.1658620912*1.0e12
    rf     = 42165.0 ;
    F_max  = 100.0
    γ_max  = F_max*3600.0^2/(2000.0*10^3)
    t0     = 0.0
    tf     = 20.0 
    rf3    = rf^3  ;
    α      = sqrt(μ/rf3);

    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, [t0, tf])
    constraint!(ocp, :initial, x0, :initial_constraint)
    #constraint!(ocp, :control, u -> sqrt(u[1]^2 + u[2]^2), -γ_max, γ_max, :control_constraint)
    constraint!(ocp, :boundary, (t0, x0, tf, xf) -> [sqrt(xf[1]^2 + xf[2]^2)-rf, xf[3] + α*xf[2], xf[4] - α*xf[1]],[0,0,0], :boundary_constraint)
    A = [ 0 0 1 0; 0 0 0 1; 1 0 0 0; 0 1 0 0]
    B = [ 0 0; 0 0; 1 0; 0 1 ]

    constraint!(ocp, :dynamics, (x, u) -> A*([-μ*x[1]/(sqrt(x[1]^2 + x[2]^2)^3);-μ*x[2]/(sqrt(x[1]^2 + x[2]^2)^3);x[3];x[4]]) + B*u)
    objective!(ocp, :lagrange, (x,u) -> 0.5*(u[1]^2 + u[2]^2)) # default is to minimise

    # the solution

    # Contrôle maximisant
    function control(p)
        u = zeros(eltype(p),2)
        u = [p[3],p[4]]
        #u = ((sqrt(p[3]^2 + p[4]^2) ≤ γ_max) ? [p[3],p[4]] : [p[3]*γ_max/sqrt(p[3]^2 + p[4]^2),p[4]*γ_max/sqrt(p[3]^2 + p[4]^2)])
        #u = [p[3]*γ_max/sqrt(p[3]^2 + p[4]^2),p[4]*γ_max/sqrt(p[3]^2 + p[4]^2)]
        return u
    end;

    #u(x,p) = [p[3],p[4]]

    # Hamiltonien maximisé
    function H(x, p)
        u = control(p)
        h = p[1]*x[3] + p[2]*x[4] + p[3]*(-μ*x[1]/norm(x[1:2])^3 + u[1]) + p[4]*(-μ*x[2]/(sqrt(x[1]^2+x[2]^2))^3 + u[2]) - 0.5*(u[1]^2 + u[2]^2)
        return h
    end

    # Système hamiltonien
    function hv(x, p)
        n  = size(x, 1)
        hv = zeros(eltype(x), 2*n)
        u = control(p)
        hv[1] = x[3]
        hv[2] = x[4]
        hv[3] = -μ*x[1]/(sqrt(x[1]^2+x[2]^2)^3) + u[1]
        hv[4] = -μ*x[2]/(sqrt(x[1]^2+x[2]^2)^3) + u[2]
        hv[5] = p[3]*μ*(x[1]^2+x[2]^2)^(-3/2) - p[3]*μ*(x[1]^2)*3*(x[1]^2+x[2]^2)^(-5/2) - p[4]*µ*x[1]*x[2]*3*(x[1]^2+x[2]^2)^(-5/2)
        hv[6] = p[4]*μ*(x[1]^2+x[2]^2)^(-3/2) - p[4]*μ*(x[2]^2)*3*(x[1]^2+x[2]^2)^(-5/2) - p[3]*µ*x[1]*x[2]*3*(x[1]^2+x[2]^2)^(-5/2)
        hv[7] = -p[1]
        hv[8] = -p[2]
        return hv
    end

    f = Flow(Hamiltonian(H));

    # shoot function
    function shoot(p0)
        
        s = zeros(eltype(p0), 4)
        xf, pf = f(t0,x0,p0,tf)
        s[1] = sqrt(xf[1]^2 + xf[2]^2) - rf
        s[2] = xf[3] + α*xf[2]
        s[3] = xf[4] - α*xf[1]
        s[4] = xf[2]*(pf[1]+α*pf[4]) - xf[1]*(pf[2]-α*pf[3])
        return s
    
    end;

    # Solve
    S(ξ) = shoot(ξ[1:4])
    jS(ξ) = ForwardDiff.jacobian(S, ξ)
    S!(s, ξ) = ( s[:] = S(ξ); nothing )
    jS!(js, ξ) = ( js[:] = jS(ξ); nothing )

    # Initial guess
    # using MINPACK  
    ξ_guess = [131.44483634733785, 34.166174258581485, 249.15735272142553, -23.973292003636686]   # pour F_max = 100N

    # Solve
    indirect_sol = fsolve(S!, jS!, ξ_guess, show_trace=true, tol=1e-8); println(indirect_sol)
    
    # Retrieves solution
    if indirect_sol.converged
        ξ_sol = indirect_sol.x
    else
        error("Not converged")
    end

    p0 = ξ_sol[1:4]
    # computing x, p, u
    ode_sol  = f((t0, tf), x0, p0)
    
    x(t) = ode_sol(t)[1:4]
    p(t) = ode_sol(t)[5:8]
    u(t) = control(p(t))
    objective = 0
    c(t) = [norm(x(t)[1:2]) - rf, x(t)[3] + α*x(t)[2], x(t)[4]-α*x(t)[1]]
    println(c(tf))

    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    sol.state_dimension = n
    sol.control_dimension = m
    sol.times = times
    sol.state = x
    sol.state_names = [ "x" * ctindices(i) for i ∈ range(1, n)]
    sol.adjoint = p
    sol.control = u
    sol.control_names = [ "u" * ctindices(i) for i ∈ range(1, m)]
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "structure: complex"
    sol.success = true
    sol.infos[:resolution] = :numerical

    #
    return OptimalControlProblem(msg, ocp, sol)

end