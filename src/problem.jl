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

```@example
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
struct OptimalControlProblem <: AbstractCTProblem
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
function Base.show(io::IO, ::MIME"text/plain", problem::OptimalControlProblem)
    println(io, "description     = ", problem.description)
    println(io, "model    (Type) = ", typeof(problem.model))
    print(  io, "solution (Type) = ", typeof(problem.solution))
end

"""
$(TYPEDSIGNATURES)

Print a tuple of descriptions.
"""
function Base.show(io::IO, ::MIME"text/plain", problems::Tuple{Vararg{OptimalControlProblem}})
    println(io, "List of optimal control problems:\n")
    for problem ∈ problems
        println(io, "description     = ", problem.description)
        println(io, "model    (Type) = ", typeof(problem.model))
        print(  io, "solution (Type) = ", typeof(problem.solution))
        println(io, "\n")
    end
end

"""
$(TYPEDSIGNATURES)

Print an empty tuple.
"""
function Base.show(io::IO, ::MIME"text/plain", t::Tuple{})
    print(io, "Tuple{}")
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
$(TYPEDEF)

Throw a [`NonExistingProblem`](@ref) exception if there is no optimal control problem described by `example`.

# Example

```julia-repl
julia> CTProblems.OCPDef{(:ocp, :dummy)}()
ERROR: there is no optimal control problem described by (:ocp, :dummy)
```

"""
struct OCPDef{description} 
    function OCPDef{description}() where {description}
        throw(NonExistingProblem(description))
    end
end

"""
$(TYPEDSIGNATURES)

Return the list of optimal control problems without the dummy problem.
"""
_problems_without_dummy() = Tuple(setdiff(problems, ((:dummy,),)))

"""
$(TYPEDSIGNATURES)

Returns the list of problems consistent with the description, as a Tuple of Description, 
see [List of problems](@ref) for details.

# Example

```@example
julia> ProblemsList(:integrator, :energy)
```

"""
function ProblemsList(description...)::Tuple{Vararg{Description}}
    desc = makeDescription(description...)
    problems_list = filter(pb -> desc ⊆ pb, _problems_without_dummy()) # filter only the problems that contain desc
    return problems_list
end

"""
$(TYPEDSIGNATURES)

Returns the list of problems consistent with the description, as a Tuple of OptimalControlProblem, 
see [List of problems](@ref) for details.

# Example

```@example
julia> Problems(:integrator, :energy)
```

"""
function Problems(description...)::Tuple{Vararg{OptimalControlProblem}}
    problems_list = ProblemsList(description...)
    return map(e -> OCPDef{e}(), problems_list)   # return the list of problems that match desc
end

"""
$(TYPEDSIGNATURES)

Returns the optimal control problem described by `description`.
See [Overview of CTProblems.jl](@ref) and [Problems](@ref) for details.

# Example

```@example
julia> Problem(:integrator, :energy)
```

"""
function Problem(description...) 
    example = getFullDescription(makeDescription(description...), problems)
    return OCPDef{example}()
end

"""
$(TYPEDSIGNATURES)

A binding to [CTBase.jl](https://control-toolbox.github.io/CTBase.jl) plot function.

"""
function CTProblems.plot(sol; kwargs...)
    return CTBase.plot(sol; kwargs...)
end

# more sophisticated filters
function _keep(description::Description, e::QuoteNode)
    return e.value ∈ description
end

function _keep(description::Description, s::Symbol, q::QuoteNode)
    @assert s == Symbol("!")
    return q.value ∉ description
end

function _keep(description::Description, s::Symbol, e::Expr)
    @assert s == Symbol("!")
    return !_keep(description, e)
end

function _keep(description::Description, e::Expr)
    @assert hasproperty(e, :head) 
    @assert e.head == :call
    if length(e.args) == 2
        return _keep(description, e.args[1], e.args[2])
    elseif length(e.args) == 3
        @assert e.args[1] == Symbol("|") || e.args[1] == Symbol("&")
        if e.args[1] == Symbol("|") 
            return _keep(description, e.args[2]) || _keep(description, e.args[3])
        elseif e.args[1] == Symbol("&")
            return _keep(description, e.args[2]) && _keep(description, e.args[3])
        end
    else
        error("bad expression")
    end
end

"""
$(TYPEDSIGNATURES)

Returns the list of problems consistent with the expression, as a Tuple of Description, 
see [List of problems](@ref) for details.

# Example

```@example
julia> ProblemsList(:(:integrator & :energy))
```

See also [`@ProblemsList`](@ref) for a simpler usage

!!! note

    The authorised operators are: `!` (negation), `|` (or) and `&` (and).

"""
function ProblemsList(expr::Union{QuoteNode, Expr})::Tuple{Vararg{Description}}
    problems_list = filter(description -> _keep(description, expr), _problems_without_dummy()) # filter only the problems that contain desc
    return problems_list
end

"""
$(TYPEDSIGNATURES)

Returns the list of problems consistent with the expression, as a Tuple of Description, 
see [List of problems](@ref) for details.

# Example

```@example
julia> @ProblemsList :integrator & :energy
```

!!! note

    The authorised operators are: `!` (negation), `|` (or) and `&` (and).

"""
macro ProblemsList(expr::Union{QuoteNode, Expr})
    return ProblemsList(expr)
end
macro ProblemsList()
    return ProblemsList()
end

"""
$(TYPEDSIGNATURES)

Returns the list of problems consistent with the expression, as a Tuple of OptimalControlProblem, 
see [List of problems](@ref) for details.

# Example

```@example
julia> Problems(:(:integrator & :energy))
```

See also [`@Problems`](@ref) for a simpler usage.

!!! note

    The authorised operators are: `!` (negation), `|` (or) and `&` (and).

"""
function Problems(expr::Union{QuoteNode, Expr})::Tuple{Vararg{OptimalControlProblem}}
    problems_list = ProblemsList(expr)
    return map(e -> OCPDef{e}(), problems_list)   # return the list of problems that match desc
end

"""
$(TYPEDSIGNATURES)

Returns the list of problems consistent with the expression, as a Tuple of OptimalControlProblem, 
see [List of problems](@ref) for details.

# Example

```@example
julia> @Problems :integrator & :energy
```

!!! note

    The authorised operators are: `!` (negation), `|` (or) and `&` (and).

"""
macro Problems(expr::Union{QuoteNode, Expr})
    return Problems(expr)
end
macro Problems()
    return Problems()
end