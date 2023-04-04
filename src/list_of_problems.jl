# list of problems
function get_info_problem(path)
    code = read(path,String)
    expr = Meta.parseall(code)
    EXAMPLE=eval(expr.args[2].args[2])
    add_to_list_of_problems=true#eval(expr.args[4].args[2])
    return EXAMPLE, add_to_list_of_problems
end

problems = ()

list_problem_files = []
list_problem_files = readdir("src/problems/")
for file in list_problem_files
    EXAMPLE, add_to_list_of_problems = get_info_problem("src/problems/"*file)
    if add_to_list_of_problems 
        if EXAMPLE ∈ problems
            println()
            println("The problem ", EXAMPLE, " is already defined.")
            println()
            println("Please provide a different description from the followings:")
            println()
            Problems()
            println()
            error("Not unique problem description.")
        else
            include("problems/"*file)
            global problems = add(problems, EXAMPLE)
        end
    end
end

# just for test
problems = add(problems, (:dummy, ))
