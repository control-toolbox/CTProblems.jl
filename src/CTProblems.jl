module CTProblems

#
using CTBase
using DocStringExtensions
#

#
include("problem.jl")
#
include("problems/simple_exponential_energy.jl")
include("problems/double_integrator_energy.jl")
include("problems/goddard.jl")

# list of problems
problems = ()
problems = add(problems, (:exponential, :dim1, :energy))
problems = add(problems, (:integrator, :dim2, :energy))
problems = add(problems, (:goddard, :state_constraint))
problems = add(problems, (:dummy, )) # to test exception not implemented

#
export Problems, Problem
export plot

end # module CTProblems
