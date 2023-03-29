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
include("list_of_problems.jl")
include("problem.jl")

# include problems
include("problems/simple_exponential_energy.jl")
include("problems/double_integrator_energy.jl")
include("problems/goddard.jl")
include("problems/simple_integrator_abs.jl")
include("problems/simple_integrator_energy_free.jl")
include("problems/simple_integrator_squaresum_free.jl")
include("problems/simple_integrator_time_free.jl")
include("problems/simple_turnpike.jl")

#
export Problems, Problem
export plot

end # module CTProblems
