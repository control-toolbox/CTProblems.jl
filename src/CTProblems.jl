module CTProblems

#
using CTBase
#

#
include("problem.jl")
#
include("examples/double_integrator_energy.jl")
include("examples/goddard.jl")

# list of examples
examples = ()
examples = add(examples, (:integrator, :dim2, :energy))
examples = add(examples, (:goddard, :state_constraint))

Problems() = examples

#
export Problems, Problem
export plot

end # module CTProblems
