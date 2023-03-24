normL1(T, f) = sum( (T[2:end]-T[1:end-1]) .* [ abs(f(T[i])) for i ∈ 1:length(T)-1] ) 
normL2(T, f) = sqrt(sum( (T[2:end]-T[1:end-1]) .* [ abs(f(T[i]))^2 for i ∈ 1:length(T)-1] ))

function initial_condition(ocp::OptimalControlModel) # pre-condition: there is an x0
    x0 = nothing
    constraints = ocp.constraints
    for (_, c) ∈ constraints
        @match c begin
            (:initial , _, f          , v, w) => begin x0=v end
            (:final   , _, f          , _, _) => nothing
            (:boundary, _, f          , _, _) => nothing
            (:control , _, f::Function, _, _) => nothing
            (:control , _, rg         , _, _) => nothing
            (:state   , _, f::Function, _, _) => nothing
            (:state   , _, rg         , _, _) => nothing
            (:mixed   , _, f          , _, _) => nothing
	    end # match
    end # for
    return x0
end

function final_condition(ocp::OptimalControlModel) # pre-condition: there is a xf
    xf = nothing
    constraints = ocp.constraints
    for (_, c) ∈ constraints
        @match c begin
            (:initial , _, f          , _, _) => nothing
            (:final   , _, f          , v, w) => begin xf=v end
            (:boundary, _, f          , _, _) => nothing
            (:control , _, f::Function, _, _) => nothing
            (:control , _, rg         , _, _) => nothing
            (:state   , _, f::Function, _, _) => nothing
            (:state   , _, rg         , _, _) => nothing
            (:mixed   , _, f          , _, _) => nothing
	    end # match
    end # for
    return xf
end