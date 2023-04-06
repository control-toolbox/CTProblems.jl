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

# Nomenclature
# 
# :name_of_the_problem, and other symbols for a clear description
#
# Classical objectives: time, energy, consumption
#
# then
#
# Dimensions: :state_dim_1, :state_dim_2... :control_dim_1, :control_dim_2...
# Objective: :lagrange, :mayer, :bolza
# Constraint arc (active on the solution): :state_constraint, :control_constraint, :mixed_constraint
# Singular arc (on the solution): :singular_arc
# Differentiability: :state_non_differentiable, :control_non_differentiable

#
list_of_problems_files = [
    "double_integrator_energy.jl",
    "goddard.jl",
    "goddard_all_constraints.jl",
    "simple_exponential_consumption.jl",
    "simple_exponential_energy.jl",
    "simple_exponential_time.jl",
]
include("list_of_problems.jl")

#
export ProblemsList, Problem, Problems, @ProblemsList, @Problems
export plot

end # module CTProblems
