#
using Revise
try
    revise(CTProblems)
catch
end

using CTProblems

prob = Problem(:integrator, :dim2)

display(prob.model)

plot(prob.solution)

println(prob.message)