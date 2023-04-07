function test_problem()
   
    @test ProblemsList() isa Tuple
    @test Problems(:integrator) isa Tuple

    e = CTProblems.NonExistingProblem((:dummy, ))
    @test_throws ErrorException error(e)
    @test typeof(sprint(showerror, e)) == String

    @test_throws CTProblems.NonExistingProblem Problem(:dummy)

    @test display(Problem(:integrator)) isa Nothing

    @test (CTProblems.plot(Problem(:integrator).solution); true)

    e = :(:integrator)
    d = (:integrator, :energy)
    @test CTProblems._keep(d, e) == true
    
    e = :(:integrator)
    d = (:integrator, :energy)
    @test CTProblems._keep(d, Symbol("!"), e) == false
    
    e = :(!(:integrator))
    d = (:integrator, :energy)
    @test CTProblems._keep(d, e) == false
    
    e = :(!(:integrator))
    d = (:exponential, :energy)
    @test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:integrator, :energy)
    @test CTProblems._keep(d, e) == false
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:exponential, :energy)
    @test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:goddard, :altitude)
    @test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:exponential, :energy)
    @test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:goddard, :altitude)
    @test CTProblems._keep(d, e) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:dummy, :altitude)
    @test CTProblems._keep(d, e) == true

    e=:( !(:exponential & :energy) | :goddard | :dummy )
    d = (:exponential, :energy, :toto)
    @test CTProblems._keep(d, e) == false

    e=:( !(:exponential & :energy) | :toto | :dummy )
    d = (:exponential, :energy, :toto)
    @test CTProblems._keep(d, e) == true

end