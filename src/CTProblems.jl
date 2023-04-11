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
using OrdinaryDiffEq
using ForwardDiff
using LinearAlgebra
#

#
include("problem.jl")

# When adding a problem, please follow the nomeclature given in the doc
# on how to add a problem, see https://control-toolbox.github.io/CTProblems.jl.
#
list_of_problems_files = [
    "orbital_transfert_consumption_min.jl",
    "orbital_transfert_energy_min.jl",
    "orbital_transfert_time_min.jl",
]
include("list_of_problems.jl")
include("utils_problems.jl")
#
export ProblemsList, Problem, Problems, @ProblemsList, @Problems
export plot

end # module CTProblems
