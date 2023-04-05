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
        :simple_exponential_conso,
        :simple_exponential_energy,
        :simple_exponential_time,
        :double_integrator_energy,
        :goddard,
        :goddard_all_constraints,
        )
        @testset "$(name)" begin
            test_name = Symbol(:test_, name)
            include("$(test_name).jl")
            @eval $test_name()
        end
    end
end