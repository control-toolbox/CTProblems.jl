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
include("problems/simple_turnpike.jl")
include("problems/simple_integrator_abs.jl")
include("problems/simple_integrator_energy_free.jl")
include("problems/simple_integrator_squaresum_free.jl")
include("problems/simple_integrator_time_free.jl")
include("problems/goddard.jl")

# list of examples
problems = ()
problems = add(problems, (:integrator, :dim2, :energy))
problems = add(problems, (:goddard, :state_constraint))
problems = add(problems, (:exponential, :dim1, :energy))
problems = add(problems, (:integrator, :dim1, :time, :free, :constraint))
problems = add(problems, (:turnpike, :dim1))
problems = add(problems, (:integrator, :dim1, :squaresum, :free))
problems = add(problems, (:integrator, :dim1, :absolute, :constraint))
problems = add(problems, (:dummy, )) # to test exception not implemented

#
export Problems, Problem
export plot

end # module CTProblems
