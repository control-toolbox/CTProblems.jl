#
function get_example(file)
    fun = gensym()
    function mapexpr(expr)
        if expr.head isa Symbol && expr.head == :(=) && expr.args[1] == :EXAMPLE
            example = expr.args[2]
            code = quote
                $(fun)() = $(example)
            end
            return code
        else
            return :()
        end
    end
    path = joinpath("problems", file)
    include(mapexpr, path)
    example = eval(:($fun()))
    return example
end

# empty list
problems = ()

# adding problems to the list
for file in list_of_problems_files

    # get example
    example = get_example(file)

    # add example if not already in the list
    if example ∈ problems
        println()
        println("The problem \n\n", example, "\n\n is already defined.")
        println()
        println("Please provide a different description from the followings:")
        println()
        display(ProblemsDescriptions())
        println()
        error("Not unique problem description.")
    elseif any([example ⊆ problem for problem ∈ problems])
        println()
        println("warning: the problem description \n\n", example, "\n\n is already contained in another description.")
        println()
        println("Please provide a description not contained in any of the followings:")
        println()
        display(ProblemsDescriptions())
        println()
    else
        include(joinpath("problems", file))
        global problems = add(problems, example)
    end

end

# just for test
problems = add(problems, (:dummy, ))