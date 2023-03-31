# list of problems
problems = ()
problems = add(problems, (:exponential, :dim1, :energy))
problems = add(problems, (:integrator, :dim2, :energy))
problems = add(problems, (:goddard, :state_constraint))
problems = add(problems, (:integrator, :dim2, :energy, :control_constraint))
problems = add(problems, (:integrator, :dim2, :consumption, :control_constraint))
problems = add(problems, (:integrator, :dim2, :time, :control_constraint))
problems = add(problems, (:integrator, :dim2, :energy, :distance))
problems = add(problems, (:lqr, :dim2, :ricatti))
problems = add(problems, (:integrator, :dim2, :energy, :state_constraint))
problems = add(problems, (:dummy, )) # to test exception not implemented