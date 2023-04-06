# [Goddard with state constraints: model 1](@id Godda)

```@example main
using CTProblems
```

You can access the problem in the CTProblems package:

```@example main
prob = Problem(:goddard, :state_constraint)
```

Then, the model is given by

```@example main
prob.model
```

You can plot the solution.

```@example main
plot(prob.solution, size=(700, 900))
```
