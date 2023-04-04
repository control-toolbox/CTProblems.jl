function test_problem()
   
    @test Problems() isa Tuple

    e = CTProblems.NonExistingProblem((:dummy, ))
    @test_throws ErrorException error(e)
    @test typeof(sprint(showerror, e)) == String

    @test_throws CTProblems.NonExistingProblem Problem(:dummy)

    @test display(Problem(:integrator)) isa Nothing

    @test (CTProblems.plot(Problem(:integrator).solution); true)

end