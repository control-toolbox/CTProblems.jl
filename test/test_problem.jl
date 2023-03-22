#
prob = Problem(:integrator, :dim2, :energy)
@test prob isa CTProblems.OptimalControlProblem

#
prob = Problem(:goddard, :state_constraint)
@test prob isa CTProblems.OptimalControlProblem

#
prob = Problem(:integrator, :dim1, :energy)
@test prob isa CTProblems.OptimalControlProblem
