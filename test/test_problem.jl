function test_problem()
   
    @test typeof(Problems()) == Nothing

    e = CTProblems.MethodNotImplemented("dummy", (:dummy, ))
    @test_throws ErrorException error(e)
    @test typeof(sprint(showerror, e)) == String

    @test_throws CTProblems.MethodNotImplemented Problem(:dummy)

end