module CTProblems

#
using CTBase
#

#
include("problem.jl")
#
include("examples/double_integrator_energy.jl")
include("examples/goddard.jl")
include("examples/simple_integrator_energy.jl")
include("examples/simple_integrator_abs.jl") #dont work for now
include("examples/simple_integrator_energy_free.jl")
include("examples/simple_integrator_squaresum_free.jl")
include("examples/simple_integrator_time_free.jl")
include("examples/simple_turnpike.jl")

# list of examples
examples = ()
examples = add(examples, (:integrator, :dim2, :energy))
examples = add(examples, (:goddard, :state_constraint))
examples = add(examples, (:integrator, :dim1, :energy))
examples = add(examples, (:integrator, :dim1, :absolute))
examples = add(examples, (:integrator, :dim1, :energy, :free))
examples = add(examples, (:integrator, :dim1, :squaresum, :free))
examples = add(examples, (:integrator, :dim1, :time, :free))
examples = add(examples, (:turnpike, :dim1))


Problems() = examples

#
export Problems, Problem
export plot

end # module CTProblems
