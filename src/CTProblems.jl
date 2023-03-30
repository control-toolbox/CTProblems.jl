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
using LinearAlgebra
using OrdinaryDiffEq
#

#
include("list_of_problems.jl")
include("problem.jl")

# include problems
include("problems/simple_exponential_energy.jl")
include("problems/double_integrator_energy.jl")
include("problems/goddard.jl")
include("problems/double_integrator_energy_cc.jl")
include("problems/double_integrator_consum_cc.jl")
include("problems/double_integrator_time_cc.jl")
include("problems/double_integrator_energy_distance.jl")
include("problems/lqr_ricatti.jl")
include("problems/double_integrator_energy_state_constraint.jl")

#
export Problems, Problem
export plot

end # module CTProblems
