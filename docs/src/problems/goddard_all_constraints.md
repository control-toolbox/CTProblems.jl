# [Goddard with state constraints: model 2](@id Go2)

```@example main
using CTProblems
```

You can access the problem in the CTProblems package:

```@example main
prob = Problem(:goddard, :all_constraints)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 900))
```
