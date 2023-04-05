# list of problems
function get_info_problem(path)
    code = read(path, String)
    expr = Meta.parseall(code)
    example=eval(expr.args[2].args[2])
    add_to_list_of_problems=true #eval(expr.args[4].args[2])
    return example, add_to_list_of_problems
end

# empty list
problems = ()

# adding problems to the list
dir_problems = abspath(joinpath("src", "problems"))
list_problem_files = readdir(dir_problems)
for file in list_problem_files
    example, add_to_list_of_problems = get_info_problem(joinpath(dir_problems, file))
    if add_to_list_of_problems 
        if example ∈ problems
            println()
            println("The problem ", example, " is already defined.")
            println()
            println("Please provide a different description from the followings:")
            println()
            display(Problems())
            println()
            error("Not unique problem description.")
        else
            include(joinpath("problems", file))
            global problems = add(problems, example)
        end
    end
end

# just for test
problems = add(problems, (:dummy, ))
