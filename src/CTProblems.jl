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

# to remove when a new release of ctbase is available
function Base.show(io::IO, ::MIME"text/plain", descriptions::Tuple{Vararg{Description}})
    for description ∈ descriptions
        println(io, description)
    end
end

#
include("list_of_problems.jl")
include("problem.jl")

#
export Problems, Problem
export plot

end # module CTProblems
