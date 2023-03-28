function test_problem()
   
    @test typeof(Problems()) == Nothing

    e = CTProblems.NonExistingProblem((:dummy, ))
    @test_throws ErrorException error(e)
    @test typeof(sprint(showerror, e)) == String

    @test_throws CTProblems.NonExistingProblem Problem(:dummy)

end