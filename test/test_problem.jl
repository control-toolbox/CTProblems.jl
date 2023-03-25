function test_problem()
   
    @test Problems() isa Tuple

    @test_throws CTProblems.MethodNotImplemented Problem(:dummy)

end