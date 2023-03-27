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

# list of examples
examples = ()
examples = add(examples, (:integrator, :dim2, :energy))
examples = add(examples, (:goddard, :state_constraint))
examples = add(examples, (:integrator, :dim1, :energy))

Problems() = examples

#
export Problems, Problem
export plot

end # module CTProblems
