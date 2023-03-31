# list of problems
problems = ()
problems = add(problems, (:goddard, :state_constraint))
problems = add(problems, (:integrator, :dim2, :energy))
problems = add(problems, (:exponential, :dim1, :energy))
problems = add(problems, (:exponential, :dim1, :absolute, :control_constraint))
problems = add(problems, (:exponential, :dim1, :mixed_constraint))
problems = add(problems, (:exponential, :dim1, :state_constraint, :control_constraint, :non_autonomous))
problems = add(problems, (:integrator, :dim1, :energy, :free))
problems = add(problems, (:integrator, :dim1, :squaresum, :free))
problems = add(problems, (:integrator, :dim1, :time, :free, :control_constraint))
problems = add(problems, (:turnpike, :dim1))
problems = add(problems, (:dummy, )) # to test exception not implemented