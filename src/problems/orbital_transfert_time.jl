EXAMPLE=(:orbital_transfert, :time, :x_dim_4, :u_dim_2, :mayer, :u_cons)

@eval function OCPDef{EXAMPLE}()
    # 
    title = "Orbital transfert - time minimisation"

    # ------------------------------------------------------------------------------------------
    # the model
    x0     = [-42272.67, 0, 0, -5796.72] # état initial
    μ      = 5.1658620912*1e12
    rf     = 42165.0 ;
    rf3    = rf^3  ;
    m0     = 2000.0
    F_max  = 100.0
    γ_max  = F_max*3600.0^2/(m0*10^3)
    t0     = 0.0
    α      = sqrt(μ/rf3);
    A = [ 0 0 1 0; 0 0 0 1; 1 0 0 0; 0 1 0 0]
    B = [ 0 0; 0 0; 1 0; 0 1 ]
    t0=0.0

    @def ocp begin
        tf ∈ R, variable
        t ∈ [ t0, tf ], time
        x ∈ R⁴, state
        u ∈ R², control
        x(t0) == x0,    (initial_con) 
        [norm(x(tf)[1:2])-rf, x₃(tf) + α*x₂(tf), x₄(tf) - α*x₁(tf)] == [0,0,0], (boundary_con)
        0 ≤ norm(u(t)) ≤ γ_max, (u_con)
        ẋ(t) == A*([-μ*x₁(t)/(sqrt(x₁(t)^2 + x₂(t)^2)^3);-μ*x₂(t)/(sqrt(x₁(t)^2 + x₂(t)^2)^3);x₃(t);x₄(t)]) + B*u(t)
        tf → min
    end

    # ------------------------------------------------------------------------------------------
    # the solution

    function control(p)
        u = zeros(eltype(p),2)
        u[1] = p[3]*γ_max/sqrt(p[3]^2 + p[4]^2)
        u[2] = p[4]*γ_max/sqrt(p[3]^2 + p[4]^2)
        return u
    end;

    function H(x, p)
        u = control(p)
        h = p[1]*x[3] + p[2]*x[4] + p[3]*(-μ*x[1]/(sqrt(x[1]^2+x[2]^2))^3 + u[1]) + p[4]*(-μ*x[2]/(sqrt(x[1]^2+x[2]^2))^3 + u[2])
        return h
    end

    abstol=1e-12
    reltol=1e-12
    f = Flow(Hamiltonian(H), abstol=abstol, reltol=reltol)

    # shoot function
    # function shoot(p0, tf)
        
    #     s = zeros(eltype(p0), 5)
    #     xf, pf = f(t0,x0,p0,tf)
    #     s[1] = sqrt(xf[1]^2 + xf[2]^2) - rf
    #     s[2] = xf[3] + α*xf[2]
    #     s[3] = xf[4] - α*xf[1]
    #     s[4] = xf[2]*(pf[1]+α*pf[4]) - xf[1]*(pf[2]-α*pf[3])
    #     s[5] = H(xf,pf) - 1
    #     return s
    # end

    # using MINPACK
    ξ_guess =  [0.00010323118913618907, 4.89264278123618e-5, 0.0003567967293906554, -0.0001553613886286001, 13.403181957149329]   # pour F_max = 100N

    #=
    foo(ξ) = shoot(ξ[1:4], ξ[5])
    jfoo(ξ) = ForwardDiff.jacobian(foo, ξ)
    foo!(s, ξ) = ( s[:] = foo(ξ); nothing )
    jfoo!(js, ξ) = ( js[:] = jfoo(ξ); nothing )

    indirect_sol = fsolve(foo!, jfoo!, ξ_guess, show_trace=true); println(indirect_sol)

    tf = (indirect_sol.x)[5]
    p0 = (indirect_sol.x)[1:4]
    =#

    tf = ξ_guess[5]
    p0 = ξ_guess[1:4]

    # computing x, p, u
    ode_sol  = f((t0, tf), x0, p0)

    x(t) = ode_sol(t)[1:4]
    p(t) = ode_sol(t)[5:8]
    u(t) = control(p(t))
    objective = tf
    
    #
    N=201
    times = range(t0, tf, N)
    #
    sol = OptimalControlSolution() #n, m, times, x, p, u)
    copy!(sol,ocp)
    sol.times = Base.deepcopy(times)
    sol.state = Base.deepcopy(x)
    sol.costate = Base.deepcopy(p)
    sol.control = Base.deepcopy(u)
    sol.objective = objective
    sol.iterations = 0
    sol.message = "structure: bang"
    sol.success = true
    sol.infos[:resolution] = :numerical

    #
    return OptimalControlProblem(title, ocp, sol)

end