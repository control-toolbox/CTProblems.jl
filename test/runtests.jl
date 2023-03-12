using CTProblems
using Test

@testset verbose = true showtiming = true "CTProblems" begin
    for name in (
        "problem", 
        )
        @testset "$name" begin
            include("test_$name.jl")
        end
    end
end