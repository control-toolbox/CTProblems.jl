#
function get_example(file)
    fun = gensym()
    function mapexpr(expr)
        if expr.head isa Symbol && expr.head == :(=)
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

# just for test
problems = add(problems, (:dummy, ))