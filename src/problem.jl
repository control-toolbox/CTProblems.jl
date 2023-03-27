#
"""
$(TYPEDEF)
"""
abstract type AbstractCTProblem end

"""
$(TYPEDEF)

**Fields**

$(TYPEDFIELDS)

# Example
```jldoctest
julia> using CTProblems
julia> using CTBase
julia> description = "My empty optimal control problem"
julia> ocp = Model()
julia> sol = OptimalControlSolution()
julia> prob = CTProblems.OptimalControlProblem{(:ocp, :empty)}(description, ocp, sol)
julia> prob isa CTProblems.AbstractCTProblem
true
julia> prob isa CTProblems.OptimalControlProblem
true
julia> prob isa isa CTProblems.OptimalControlProblem{(:ocp, :empty)}
true
julia> prob isa CTProblems.OptimalControlProblem{(:ocp, :empty, :dummy)}
false
```
"""
struct OptimalControlProblem{example} <: AbstractCTProblem
    description::String
    model::OptimalControlModel
    solution::OptimalControlSolution
end

"""
$(TYPEDSIGNATURES)

Show the description, the model and the solution of the optimal control problem.

```@example
julia> using CTProblems
julia> Problem(:integrator)
description     = Double integrator - energy min
model    (Type) = CTBase.OptimalControlModel{:autonomous, :scalar}
solution (Type) = CTBase.OptimalControlSolution
```

"""
function Base.show(io::IO, ::MIME"text/plain", prob::OptimalControlProblem)
    println(io, "description     = ", prob.description)
    println(io, "model    (Type) = ", typeof(prob.model))
    println(io, "solution (Type) = ", typeof(prob.solution))
end

"""
$(TYPEDSIGNATURES)

Print the list of available problems, see [List of problems](@ref) for details.

"""
function Problems()
    for description ∈ problems
        :dummy ∉ description ? println(description) : nothing
    end
end

"""
$(TYPEDSIGNATURES)

Returns the optimal control problem described by `description`.
See [Overview of CTProblems.jl](@ref) and [Problems](@ref) for details.

"""
function Problem(description...) 
    example = getFullDescription(makeDescription(description...), problems)
    return OptimalControlProblem{example}()
end

# exception
"""
$(TYPEDEF)
"""
abstract type CTProblemsException <: Exception end

# not implemented
"""
$(TYPEDEF)

**Fields**

$(TYPEDFIELDS)
"""
struct NonExistingProblem <: CTProblemsException
    example::Description
end

"""
$(TYPEDSIGNATURES)

Print the error message when the optimal control problem described by `e.example` does not exist. 

"""
function Base.showerror(io::IO, e::NonExistingProblem) 
    print(io, "there is no optimal control problem described by ", e.example)
end

"""

    OptimalControlProblem{example}() where {example}

Throw a [`NonExistingProblem`](@ref) exception if there is no optimal control problem described by `example`.

# Example
```julia-repl
julia> CTProblems.OptimalControlProblem{(:ocp, :dummy)}()
ERROR: there is no optimal control problem described by (:ocp, :dummy)
```

"""
function OptimalControlProblem{example}() where {example}
    throw(NonExistingProblem(example))
end

"""
$(TYPEDSIGNATURES)

A binding to [`CTBase.plot`](@ref) function.

"""
function CTProblems.plot(sol; kwargs...)
    return CTBase.plot(sol; kwargs...)
end