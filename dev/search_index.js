var documenterSearchIndex = {"docs":
[{"location":"simple_integrator.html#Simple-integrator","page":"Simple integrator","title":"Simple integrator","text":"","category":"section"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"using CTProblems","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"The energy min double integrator problem consists in minimising","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"    frac12int_0^1 u^2(t)  mathrmdt","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"subject to the constraints","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"    dot x(t) = - x(t) + u(t)","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"and the limit conditions","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"    x(0) = -1 quad x(1) = 0","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"You can access the problem in the CTProblems package:","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"prob = Problem(:integrator, :dim1, :energy)\nnothing # hide","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"Then, the model is given by","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"prob.model","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"You can plot the solution.","category":"page"},{"location":"simple_integrator.html","page":"Simple integrator","title":"Simple integrator","text":"plot(prob.solution)","category":"page"},{"location":"api.html#API","page":"API","title":"API","text":"","category":"section"},{"location":"api.html","page":"API","title":"API","text":"CurrentModule = CTProblems ","category":"page"},{"location":"api.html","page":"API","title":"API","text":"Modules = [CTProblems]\nOrder = [:module, :type, :function, :macro]","category":"page"},{"location":"api.html#CTProblems.Problems-Tuple{}","page":"API","title":"CTProblems.Problems","text":"Problems()\n\n\nPrint the list of available examples.\n\n\n\n\n\n","category":"method"},{"location":"problems.html#Problems","page":"Problems","title":"Problems","text":"","category":"section"},{"location":"problems.html","page":"Problems","title":"Problems","text":"Pages = [\n    \"simple_integrator.md\",\n    \"double_integrator.md\",\n]\nDepth = 1","category":"page"},{"location":"double_integrator.html#Double-integrator","page":"Double integrator","title":"Double integrator","text":"","category":"section"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"using CTProblems","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"The energy min double integrator problem consists in minimising","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"    frac12int_t_0^t_f u^2(t)  mathrmdt","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"subject to the constraints","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"    dot x_1(t) = x_2(t) quad dot x_2(t) = u(t)","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"and the limit conditions","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"    x(t_0) = (-1 0) quad x(t_f) = (0 0)","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"You can access the problem in the CTProblems package:","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"prob = Problem(:integrator, :dim2, :energy)\nnothing # hide","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"Then, the model is given by","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"prob.model","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"You can plot the solution.","category":"page"},{"location":"double_integrator.html","page":"Double integrator","title":"Double integrator","text":"plot(prob.solution)","category":"page"},{"location":"index.html#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"Pages = [\"index.md\"]\nDepth = 3","category":"page"},{"location":"index.html#Control-toolbox-ecosystem","page":"Introduction","title":"Control-toolbox ecosystem","text":"","category":"section"},{"location":"index.html#Presentation","page":"Introduction","title":"Presentation","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"The CTProblems.jl package is part of the control-toolbox ecosystem which gathers Julia packages for mathematical control and applications. It is an outcome of a research initiative supported by the Centre Inria of Université Côte d'Azur and a sequel to previous developments, notably Bocop and Hampath. See also: ct gallery. The root package is OptimalControl.jl which aims to provide tools to solve optimal control problems by direct and indirect methods.","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"(Image: doc OptimalControl.jl)","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"An optimal control problem can be described as minimising the cost functional","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"g(t_0 x(t_0) t_f x(t_f)) + int_t_0^t_f f^0(t x(t) u(t))mathrmdt","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"where the state largex and the control largeu are functions subject, for larget in t_0 t_f, to the differential constraint","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"   dotx(t) = f(t x(t) u(t))","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"and other constraints such as","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"beginarrayllcll\nxi_l  le xi(t u(t))        le xi_u \npsi_l le psi(t x(t) u(t)) le psi_u \neta_l le eta(t x(t))       le eta_u \nphi_l le phi(t_0 x(t_0) t_f x(t_f)) le phi_u\nendarray","category":"page"},{"location":"index.html#Installation","page":"Introduction","title":"Installation","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"To install a package from the control-toolbox ecosystem, you must add its registry into your Julia configuration.","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"Start Julia:","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"shell> julia\n\n   _       _ _(_)_     |  Documentation: https://docs.julialang.org\n  (_)     | (_) (_)    |\n   _ _   _| |_  __ _   |  Type \"?\" for help, \"]?\" for Pkg help.\n  | | | | | | |/ _` |  |\n  | | |_| | | | (_| |  |  Version 1.8.2 (2022-09-29)\n _/ |\\__'_|_|_|\\__'_|  |  Official https://julialang.org/ release\n|__/                   |","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"Then, add ct-registry to the list of known registries:","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"julia> ]\npkg> registry add https://github.com/control-toolbox/ct-registry.git","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"Finally, you can install any package as usual. For instance:","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"pkg> add CTProblems","category":"page"},{"location":"index.html#Main-repositories","page":"Introduction","title":"Main repositories","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"The main repositories of the control-toolbox ecosystem are:","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"bocop: Bocop3, a direct solver for optimal control problem developed in C++\nct-registry: the control-toolbox registry since the packages are not yet available in the official registry\nCTBase.jl: fundamentals of the control-toolbox ecosystem\nCTDirect.jl: direct transcription of an optimal control problem and resolution\nCTDirectShooting.jl: direct shooting transcription of an optimal control problem and resolution\nCTFlows.jl: classical flow, Hamiltonian flow, flow from optimal control problem\nCTProblems.jl: library of optimal control problems\nOptimalControl.jl: main package\nPathFollowing.jl: path following methods","category":"page"},{"location":"index.html#Discussions","page":"Introduction","title":"Discussions","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"We discuss about the control-toolbox ecosystem here:","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"(Image: Github Issues)\n(Image: GitHub Discussions)\n(Image: GitHub Wiki)","category":"page"},{"location":"index.html#Overview-of-CTProblems.jl","page":"Introduction","title":"Overview of CTProblems.jl","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"The CTProblems.jl package provides a list of optimal control problems, each of them is made of a description, the model and the solution. You can get access to any problem by a simple description, see CTBase.jl. For instance, to get the energy-min one dimensional integrator problem, simply","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"using CTProblems\nprob = Problem(:integrator, :dim1, :energy)","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"Then, the model is given by","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"prob.model","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"You can plot the solution.","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"plot(prob.solution)","category":"page"},{"location":"index.html#List-of-problems","page":"Introduction","title":"List of problems","text":"","category":"section"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"To print the complete list of Problems:","category":"page"},{"location":"index.html","page":"Introduction","title":"Introduction","text":"Problems()","category":"page"}]
}
