# using revise to recompile
using Revise
try
    revise(CTProblems)
catch
end

using CTProblems

prob = Problem((:exponential, :dim1, :state_constraint, :non_autonomous))

display(prob.model)

plot(prob.solution)

#println(prob.message) #if not commented the plot window does not show
