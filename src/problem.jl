#
abstract type AbstractCTProblem end

struct OptimalControlProblem{example} <: AbstractCTProblem
    message::String
    model::OptimalControlModel
    solution::OptimalControlSolution
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

function Problem(description...) 
    example = getFullDescription(makeDescription(description...), Problems())
    return OptimalControlProblem{example}()
end