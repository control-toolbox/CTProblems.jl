module CTProblems

#
using CTBase
using MINPACK
#

#
include("problem.jl")
#
include("examples/double_integrator_energy.jl")
include("examples/goddard.jl")
include("examples/simple_integrator_energy.jl")
include("examples/double_integrator_energy_cc.jl")

# list of examples
examples = ()
examples = add(examples, (:integrator, :dim2, :energy))
examples = add(examples, (:goddard, :state_constraint))
examples = add(examples, (:integrator, :dim1, :energy))
examples = add(examples, (:integrator, :dim2, :energy, :constraint))

Problems() = examples

#
export Problems, Problem
export plot

end # module CTProblems
