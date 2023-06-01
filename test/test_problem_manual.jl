# using revise to recompile
using Revise
try
    revise(CTProblems)
catch
end

using CTProblems

probs = [Problem(:integrator, :time, :x_dim_2, :u_dim_1, :mayer, :u_cons),
        Problem(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :noconstraints),
        Problem(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :x_cons, :order_2),
        Problem(:integrator, :consumption, :x_dim_2, :u_dim_1, :lagrange, :u_cons, :non_diff_wrt_u),
        Problem(:integrator, :energy, :x_dim_2, :u_dim_1, :lagrange, :u_cons),
        Problem(:integrator, :energy, :distance, :x_dim_2, :u_dim_1, :bolza),
        Problem(:lqr, :x_dim_2, :u_dim_1, :lagrange),
        Problem(:exponential, :consumption, :x_dim_1, :u_dim_1, :lagrange, :non_diff_wrt_u),
        Problem(:exponential, :energy, :x_dim_1, :u_dim_1, :lagrange),
        Problem(:exponential, :time, :x_dim_1, :u_dim_1, :lagrange),
        Problem(:integrator, :energy, :free_final_time, :x_dim_1, :u_dim_1, :lagrange),
        Problem(:integrator, :lqr, :free_final_time, :x_dim_1, :u_dim_1, :bolza),
        Problem(:integrator, :x_dim_1, :u_dim_1, :lagrange, :mixed_constraint),
        Problem(:turnpike, :integrator, :state_energy, :x_dim_1, :u_dim_1, :lagrange, :u_cons, :singular_arc),
        Problem(:integrator, :state_dime_1, :lagrange, :x_cons, :u_cons, :nonautonomous),
        Problem(:orbital_transfert, :consumption, :x_dim_4, :u_dim_2, :lagrange, :u_cons, :non_diff_wrt_u)
        ]


for prob in probs
    display(prob.model)
    display(plot(prob.solution))
end
