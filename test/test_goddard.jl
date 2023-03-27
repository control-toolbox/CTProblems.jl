function test_goddard()

    #
    prob = Problem(:goddard, :state_constraint)
    @test prob isa CTProblems.OptimalControlProblem

end