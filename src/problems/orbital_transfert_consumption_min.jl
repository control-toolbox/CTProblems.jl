EXAMPLE=(:orbital_transfert, :dim4, :consumption)

@eval function OCPDef{EXAMPLE}()
    # should return an OptimalControlProblem{example} with a message, a model and a solution

    # 
    msg = "Orbital transfert - consumption min"

    # the model
    n=4
    m=2

    rf     = 42165.0 ;
    m0     = 2000.0
    F_max = 20.0
    γ_max  = F_max*3600.0^2/(m0*10^3)
    μ      = 5.1658620912*1e12
    t0     = 0.0
    rf3    = rf^3  ;
    α      = 0.2625084254205472#sqrt(μ/rf3);
    β      = 0.0

    tol    = 1e-12;

    x0 = [-42272.67, 0, 0, -5796.72, m0, 0.0]

    F_max_20  = 20.0

    tf_min_20 = 59.85516688789379 # minimal time for Fmax = 20 N
    tf_20     = 1.5*tf_min_20
    ε_init_1e0    = 1.0
    p0_guess_20_a = [0.00668994517486452, 0.0008069227480003886, 0.005884496585344698, -0.04176783251179745, -0.35861897272689147, 0.0]
    p0_guess_20_b = [-0.0009737407120528945, 0.0002585826411057628, 0.0018857179140932638, -0.034991324485475844, -0.1693846147531423, 0.0]

    ε_init_1e_1 = 1e-1
    p0_guess_20_1e_1 = [-0.00020083445561831767, 8.824275956250577e-5, 0.0006435116910019646, -0.011854368081064033, -0.056208392675317714, 0.0]

    ε_init_1e_2 = 1e-2
    p0_guess_20_1e_2 = [-9.979024683936127e-5, 7.24625045489202e-5, 0.000528433931997731, -0.010141334052060913, -0.04650571716662274, 0.0]

    ε_init_1e_3 = 1e-3
    p0_guess_20_1e_3 = [-0.00010295342528640484, 6.955334470904565e-5, 0.0005072188389996865, -0.010062085459039827, -0.045536464232390994, 0.0]

    ε_init_5e_4 = 5e-4
    p0_guess_20_5e_4 = [0.0]

    nx = size(p0_guess_20_a, 1)

    Th(F) = F*3600.0^2/(10^3) # u_max


    ocp = Model()
    state!(ocp, n)   # dimension of the state
    control!(ocp, m) # dimension of the control
    time!(ocp, :initial, t0)
    constraint!(ocp, :initial, x0)
    constraint!(ocp, :boundary, (t0, x0, tf, xf) -> [sqrt(xf[1]^2 + xf[2]^2)-rf, xf[3] + α*xf[2], xf[4] - α*xf[1]],[0,0,0])
    constraint!(ocp, :control, u -> sqrt(u[1]^2 + u[2]^2), -γ_max, γ_max, :control_constraint)
    A = [ 0 0 1 0; 0 0 0 1; 1 0 0 0; 0 1 0 0]
    B = [ 0 0; 0 0; 1 0; 0 1 ]

    constraint!(ocp, :dynamics, (x, u) -> A*([-μ*x[1]/(sqrt(x[1]^2 + x[2]^2)^3);-μ*x[2]/(sqrt(x[1]^2 + x[2]^2)^3);x[3];x[4]]) + B*u)
    objective!(ocp, :lagrange, (x, u) -> sqrt(u[1]^2 + u[2]^2)) # default is to minimise

    # the solution
    norm(u) = sqrt(sum(u[i]^2 for i in eachindex(u)))
    # Hamiltonian
    # beta = 0 so we do not take it into account
    #
    function control(x, p, ε, u_max)
        φ = [p[3], p[4]]; nφ = norm(φ)
        m = x[5]
        ψ = -1.0 + (u_max/m)*nφ + p[6] - p[5]*β*u_max
        α = (ψ - 2ε + √(ψ^2 + 4ε^2))/(2ψ)
        u = (α/nφ)*φ
        return u
    end

    #H(x, p, u, ε, u_max) = (-norm(u) + ε*(log(max(norm(u), 1e-3))+log(max(1.0-norm(u), 1e-3)))
    H(x, p, u, ε, u_max) = (-norm(u) + ε*(log(norm(u))+log(1.0-norm(u)))
                            + p[1]*x[3]
                            + p[2]*x[4]
                            + p[3]*(-μ*x[1]/norm(x[1:2])^3+(u_max/x[5])*u[1])
                            + p[4]*(-μ*x[2]/norm(x[1:2])^3+(u_max/x[5])*u[2])
                            - p[5]*β*u_max*norm(u)
                            + p[6]*norm(u)); # on ajoute la conso dans le hamiltonien: x[6]

    H(x, p, ε, u_max) = H(x, p, control(x, p, ε, u_max), ε, u_max) 



    # Flow
    f = Flow(Hamiltonian(H));

    
    # Fonction de tir
    function shoot(p0, tf, ε, u_max, α)
        
        # Integration
        println("before f")
        xf, pf = f(t0, x0, p0, tf, ε, u_max, abstol=tol, reltol=tol)
        

        # Conditions
        s = zeros(eltype(p0), 6)
        
        s[1] = norm(xf[1:2]) - rf
        s[2] = xf[3] + α*xf[2]
        println("after f")
        s[3] = xf[4] - α*xf[1]
        s[4] = xf[2]*(pf[1] + α*pf[4]) - xf[1]*(pf[2] - α*pf[3])
        s[5] = pf[5]
        s[6] = pf[6]
        
        return s
    
    end;
    
    ε_init = ε_init_1e_3
    p0_first_shoot = p0_guess_20_1e_3
    tf_first_shoot = tf_20
    Fm_first_shoot = F_max_20
    tf_min_first_shoot = tf_min_20
    
    # Initial guess
    ξ_guess  = p0_first_shoot #+ 1e-4.*(-1.0 .+ (2.0 .* rand(Float64, 6)))
    
    # Solve
    println(tf_first_shoot,"  ", ε_init,"  ", Th(Fm_first_shoot))
    S(ξ) = shoot(ξ, tf_first_shoot, ε_init, Th(Fm_first_shoot),α) # on fixe les valeurs des paramètres
    jS(ξ) = ForwardDiff.jacobian(S, ξ)
    S!(s, ξ) = ( s[:] = S(ξ); nothing )
    # jS!(js, ξ) = ( js[:] = jS(ξ); nothing )
    
    println("Initial value of shooting:\n", S(ξ_guess), "\n\n")
    
    # indirect_sol = fsolve(S!, jS!, ξ_guess, show_trace=true, tol=1e-8); println(nl_sol)
    
    # # Retrieves solution
    # if indirect_sol.converged
    #     p0_sol_first_shoot = indirect_sol.x[1:nx]
    # else
    #     error("Not converged")
    # end

    # tf = (indirect_sol.x)[5]
    # p0 = (indirect_sol.x)[1:4]

    # # computing x, p, u
    # ode_sol  = f((t0, tf), x0, p0)
    tf = 1
    x(t) = [0,0,0,0,0,0]
    p(t) = [0,0,0,0,0,0]
    u(t) = [0,0]
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
    sol.state_names = [ "x" * ctindices(i) for i ∈ range(1, n)]
    sol.adjoint = p
    sol.control = u
    sol.control_names = [ "u" * ctindices(i) for i ∈ range(1, m)]
    sol.objective = objective
    sol.iterations = 0
    sol.message = "structure: complex"
    sol.success = true
    sol.infos[:resolution] = :numerical

    #
    return OptimalControlProblem(msg, ocp, sol)

end