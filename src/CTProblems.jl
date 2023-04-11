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

# When adding a problem, please follow the nomeclature given in the doc
# on how to add a problem, see https://control-toolbox.github.io/CTProblems.jl.
#
list_of_problems_files = [
    "double_integrator_energy.jl",
    "goddard.jl",
    "goddard_all_constraints.jl",
    "simple_exponential_consumption.jl",
    "simple_exponential_energy.jl",
    "simple_exponential_time.jl",
    "simple_integrator_energy_free_tf.jl",
    "simple_integrator_mixed_constraint.jl",
]
include("list_of_problems.jl")

#
export ProblemsList, Problem, Problems, @ProblemsList, @Problems
export plot

end # module CTProblems
