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
    @test CTProblems._valid(e; description=d) == true
    
    e = :(:integrator)
    d = (:integrator, :energy)
    @test CTProblems._valid(Symbol("!"), e; description=d) == false
    
    e = :(!(:integrator))
    d = (:integrator, :energy)
    @test CTProblems._valid(e; description=d) == false
    
    e = :(!(:integrator))
    d2 = (:exponential, :energy)
    @test CTProblems._valid(e; description=d2) == true
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:integrator, :energy)
    @test CTProblems._valid(e; description=d) == false
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:exponential, :energy)
    @test CTProblems._valid(e; description=d) == true
    
    e=:( (!:integrator & :energy) | :goddard )
    d = (:goddard, :altitude)
    @test CTProblems._valid(e; description=d) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:exponential, :energy)
    @test CTProblems._valid(e; description=d) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:goddard, :altitude)
    @test CTProblems._valid(e; description=d) == true
    
    e=:( (!:integrator & :energy) | :goddard | :dummy )
    d = (:dummy, :altitude)
    @test CTProblems._valid(e; description=d) == true

end