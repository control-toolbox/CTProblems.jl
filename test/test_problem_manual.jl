# using revise to recompile
using Revise
try
    revise(CTProblems)
catch
end

using CTProblems

prob = Problem(:orbital_transfert, :energy, :state_dim_4, :control_dim_2, :lagrange, :singular_arc)

display(prob.model)

plot(prob.solution)

#println(prob.message) #if not commented the plot window does not show
