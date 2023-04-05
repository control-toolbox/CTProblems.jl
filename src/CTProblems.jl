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
list_of_problems_files = [
    "double_integrator_energy.jl",
    "goddard.jl",
    "goddard_all_constraints.jl",
    "simple_exponential_conso.jl",
    "simple_exponential_energy.jl",
    "simple_exponential_time.jl",
]
include("list_of_problems.jl")

#
export Problems, Problem
export plot

end # module CTProblems
