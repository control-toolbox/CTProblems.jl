using CTProblems
using Test
using MINPACK
using CTFlows
using MLStyle
using CTBase
using LinearAlgebra
include("utils.jl")

@testset verbose = true showtiming = true "CTProblems" begin
    for name ∈ (
        :problem,
        :goddard,
        :simple_integrator,
        :double_integrator,
        )
        @testset "$(name)" begin
            test_name = Symbol(:test_, name)
            include("$(test_name).jl")
            @eval $test_name()
        end
    end
end