EXAMPLE=(:orbital_transfert, :dim4, :energy)

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "Orbital transfert - energy min"

    # the model
    n=4
    m=2

    x0     = [-42272.67, 0, 0, -5796.72] # état initial
    μ      = 5.1658620912*1e12
    rf     = 42165.0 ;
    F_max  = 100#20.0
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

    constraint!(ocp, :dynamics, (x, u) -> A*([-μ*x[1]/(sqrt(x[1]^2 + x[2]^2)^3);-μ*x[2]/(sqrt(x[1]^2 + x[2]^2)^3);x[3];x[4]]) + B*u)
    objective!(ocp, :lagrange, (x,u) -> 0.5*(u[1]^2 + u[2]^2)) # default is to minimise

    # the solution

    # Contrôle maximisant
    function control(p)
        u = zeros(eltype(p),2)
        u[1] = p[3]*γ_max/sqrt(p[3]^2 + p[4]^2)
        u[2] = p[4]*γ_max/sqrt(p[3]^2 + p[4]^2)
        return u
    end;

    # Hamiltonien maximisé
    function hfun(x, p)
        u = control(p)
        h = p[1]*x[3] + p[2]*x[4] + p[3]*(-μ*x[1]/(sqrt(x[1]^2+x[2]^2))^3 + u[1]) + p[4]*(-μ*x[2]/(sqrt(x[1]^2+x[2]^2))^3 + u[2]) -0.5*(u[1]^2 + u[2]^2)
        return h
    end

    # Système hamiltonien
    function hv(x, p)
        n  = size(x, 1)
        hv = zeros(eltype(x), 2*n)
        u = control(p)
        hv[1] = x[3]
        hv[2] = x[4]
        hv[3] = -μ*x[1]/(sqrt(x[1]^2+x[2]^2)^3) + p[3]*γ_max/(sqrt(p[3]^2 + p[4]^2))
        hv[4] = -μ*x[2]/(sqrt(x[1]^2+x[2]^2)^3) + p[4]*γ_max/(sqrt(p[3]^2 + p[4]^2))
        hv[5] = p[3]*μ*(x[1]^2+x[2]^2)^(-3/2) - p[3]*μ*(x[1]^2)*3*(x[1]^2+x[2]^2)^(-5/2) - p[4]*µ*x[1]*x[2]*3*(x[1]^2+x[2]^2)^(-5/2)
        hv[6] = p[4]*μ*(x[1]^2+x[2]^2)^(-3/2) - p[4]*μ*(x[2]^2)*3*(x[1]^2+x[2]^2)^(-5/2) - p[3]*µ*x[1]*x[2]*3*(x[1]^2+x[2]^2)^(-5/2)
        hv[7] = -p[1]
        hv[8] = -p[2]
        return hv
    end

    # Function to get the flow of a Hamiltonian system
    function Flow(hv)

        function rhs!(dz, z, dummy, t)
            n = size(z, 1)÷2
            dz[:] = hv(z[1:n], z[n+1:2*n])
        end
        
        function f(tspan, x0, p0; abstol=1e-12, reltol=1e-12, saveat=0.1)
            z0 = [ x0 ; p0 ]
            ode = ODEProblem(rhs!, z0, tspan)
            sol = solve(ode, Tsit5(), abstol=abstol, reltol=reltol, saveat=saveat)
            return sol
        end
        
        function f(t0, x0, p0, t; abstol=1e-12, reltol=1e-12, saveat=[])
            sol = f((t0, t), x0, p0; abstol=abstol, reltol=reltol, saveat=saveat)
            n = size(x0, 1)
            return sol[1:n, end], sol[n+1:2*n, end]
        end
        
        return f

    end;

    f = Flow(hv);

    function shoot(p0, tf)
        
        s = zeros(eltype(p0), 5)
        xf, pf = f(t0,x0,p0,tf)
        s[1] = sqrt(xf[1]^2 + xf[2]^2) - rf
        s[2] = xf[3] + α*xf[2]
        s[3] = xf[4] - α*xf[1]
        s[4] = xf[2]*(pf[1]+α*pf[4]) - xf[1]*(pf[2]-α*pf[3])
        s[5] = hfun(xf,pf)
        return s
    end;

    

    # using MINPACK
    ξ_guess =  [1.0323e-4, 4.915e-5, 3.568e-4, -1.554e-4, 13.4]   # pour F_max = 100N
    #ξ_guess = [-0.0013615, -7.34989e-6, -5.359923e-5, -0.00858271, 50.8551668] # for F_max = 20N


    foo(ξ) = shoot(ξ[1:4], ξ[5])
    jfoo(ξ) = ForwardDiff.jacobian(foo, ξ)
    foo!(s, ξ) = ( s[:] = foo(ξ); nothing )
    jfoo!(js, ξ) = ( js[:] = jfoo(ξ); nothing )

    indirect_sol = fsolve(foo!, jfoo!, ξ_guess, show_trace=true); println(indirect_sol)

    tf = (indirect_sol.x)[5]
    p0 = (indirect_sol.x)[1:4]

    # computing x, p, u
    ode_sol  = f((t0, tf), x0, p0)

    x(t) = ode_sol(t)[1:4]#[0,0,0,0]
    p(t) = ode_sol(t)[5:8]#[0,0,0,0]
    u(t) = control(ode_sol(t)[5:8])#[0,0]
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
    sol.control_labels = [ "u" * ctindices(i) for i ∈ range(1, m)]
    sol.objective = objective
    sol.iterations = 0
    sol.stopping = :dummy
    sol.message = "numerical solution"
    sol.success = true

    #
    return OptimalControlProblem(msg, ocp, sol)

end