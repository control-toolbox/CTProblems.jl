"""
[`CTProblems`](@ref) module.

Lists all the imported modules and packages:

$(IMPORTS)

List of all the exported names:

$(EXPORTS)

"""
module CTProblems

#
using CTBase
using CTFlows
using DocStringExtensions
using MINPACK
#

#
include("problem.jl")
#
include("problems/simple_exponential_energy.jl")
include("problems/double_integrator_energy.jl")
include("problems/goddard.jl")
include("problems/double_integrator_energy_cc.jl")
include("problems/double_integrator_consum_cc.jl")
include("problems/double_integrator_time_cc.jl")

# list of problems
problems = ()
problems = add(problems, (:exponential, :dim1, :energy))
problems = add(problems, (:integrator, :dim2, :energy))
problems = add(problems, (:goddard, :state_constraint))
problems = add(problems, (:integrator, :dim2, :energy, :constraint))
problems = add(problems, (:integrator, :dim2, :consum, :constraint))
problems = add(problems, (:integrator, :dim2, :time, :constraint))
problems = add(problems, (:dummy, )) # to test exception not implemented

#
export Problems, Problem
export plot

end # module CTProblems
