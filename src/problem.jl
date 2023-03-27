#
abstract type AbstractCTProblem end

struct OptimalControlProblem{example} <: AbstractCTProblem
    description::String
    model::OptimalControlModel
    solution::OptimalControlSolution
end

function Base.show(io::IO, ::MIME"text/plain", prob::OptimalControlProblem)
    println(io, "description     = ", prob.description)
    println(io, "model    (Type) = ", typeof(prob.model))
    println(io, "solution (Type) = ", typeof(prob.solution))
end

"""
    $(SIGNATURES)

Print the list of available problems.
"""
function Problems()
    for description ∈ problems
        :dummy ∉ description ? println(description) : nothing
    end
end

function Problem(description...) 
    example = getFullDescription(makeDescription(description...), problems)
    return OptimalControlProblem{example}()
end

# exception
abstract type CTTestProbemsException <: Exception end

# not implemented
struct MethodNotImplemented <: CTTestProbemsException
    method::String
    example::Description
end

function Base.showerror(io::IO, e::MethodNotImplemented) 
    print(io, "the method ", e.method, " is not implemented for example ", e.example)
end

function OptimalControlProblem{example}() where {example}
    throw(MethodNotImplemented("Problem", example))
end