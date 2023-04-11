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
        :double_integrator_energy,
        :goddard_all_constraints,
        :goddard,
        :problem,
        :simple_exponential_consumption,
        :simple_exponential_energy,
        :simple_exponential_time,
        :simple_integrator_energy_free_tf,
        :simple_integrator_mixed_constraint,
        )
        @testset "$(name)" begin
            test_name = Symbol(:test_, name)
            include("$(test_name).jl")
            @eval $test_name()
        end
    end
end