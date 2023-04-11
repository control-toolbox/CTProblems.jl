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
include("problem.jl")

# When adding a problem, please follow the nomeclature given in the doc
# on how to add a problem, see https://control-toolbox.github.io/CTProblems.jl.
#
list_of_problems_files = [
    "double_integrator_energy.jl",
    "double_integrator_consumption_control_constraint.jl",
    "double_integrator_energy_control_constraint.jl",
    "double_integrator_energy_distance.jl",
    "double_integrator_energy_state_constraint.jl",
    "double_integrator_time_control_constraint.jl",
    "lqr_ricatti.jl",

]
include("list_of_problems.jl")

#
export ProblemsList, Problem, Problems, @ProblemsList, @Problems
export plot

end # module CTProblems
