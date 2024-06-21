function test_problem()
   
    # displays
    Test.@test display(Problem(:integrator)) isa Nothing
    Test.@test display(Problems(:integrator)) isa Nothing
    Test.@test display(()) isa Nothing

    # exception
    e = CTProblems.NonExistingProblem((:dummy, ))
    @test_throws ErrorException error(e)
    Test.@test typeof(sprint(showerror, e)) == String
    @test_throws CTProblems.NonExistingProblem Problem(:dummy)

    # get problems
    Test.@test ProblemsDescriptions() isa Tuple
    Test.@test Problems(:integrator) isa Tuple
    Test.@test Problem(:integrator) isa CTProblems.OptimalControlProblem

    # get problems with expression
    Test.@test (@ProblemsDescriptions) isa Tuple
    Test.@test (@ProblemsDescriptions :integrator & :energy) isa Tuple
    Test.@test (@ProblemsDescriptions :integrator) isa Tuple
    Test.@test (@Problems) isa Tuple
    Test.@test (@Problems :integrator & :energy) isa Tuple
    Test.@test (@Problems :integrator) isa Tuple

    # _keep
    e = :(:integrator)
    d = (:integrator, :energy)
    Test.@test CTProblems._keep(d, e) == true
    
    e = :(:integrator)
    d = (:integrator, :energy)
    Test.@test CTProblems._keep(d, Symbol("!"), e) == false
    
    e = :(!(:integrator))
    d = (:integrator, :energy)
    Test.@test CTProblems._keep(d, e) == false
    
    e = :(!(:integrator))
    d = (:exponential, :energy)
    Test.@test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:integrator, :energy)
    Test.@test CTProblems._keep(d, e) == false
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:exponential, :energy)
    Test.@test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:goddard, :altitude)
    Test.@test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:exponential, :energy)
    Test.@test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:goddard, :altitude)
    Test.@test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:dummy, :altitude)
    Test.@test CTProblems._keep(d, e) == true

    e=:( !(:exponential & :energy) | :goddard | :dummy )
    d = (:exponential, :energy, :toto)
    Test.@test CTProblems._keep(d, e) == false

    e=:( !(:exponential & :energy) | :toto | :dummy )
    d = (:exponential, :energy, :toto)
    Test.@test CTProblems._keep(d, e) == true

    # list of problems
    ex0 = CTProblems.get_example("dummy_example.jl")
    ex1 = (:dummy,) #(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :noconstraints)
    Test.@test ex0 == ex1

end