#### Functions ####


### Basic Example Functions ###

# User defined functions allow you to easily reuse a piece of code. These are
# really the heart of R programming, and the basis for all R packages. Mastering
# functions will allow you to enormously speed up your workflow and take on much
# more complex projects.

# Lets start with a really simple example
first_function <- function(number) {
    print(number + 1000)
}

# In our second example, we are going to define a function that will take the
# sum of a particular column of a matrix (where the column index is a number):
my_column_sum <- function(col_number,
                          my_matrix) {

    # Take the column sum of the matrix:
    col_sum <- sum(my_matrix[,col_number])

    # We always include a return statement at the end of the function which
    # gives us back whatever the function computed. Note that we can only return
    # one object (variable) in this return statement:
    return(col_sum)
}

# Once we have defined our function, we simply enter it into the console. If all
# went well, it will appear like nothing happened. However, the function will
# now be available for us to use.

# Lets try out our function on some example data:
my_mat <- matrix(1:100,
                 nrow = 10,
                 ncol = 10)

# Look at our matrix:
my_mat

# Now we use 'my_column_sum()' to take the sum of all elements in the first
# column:
temp <- my_column_sum(col_number = 1,
                      my_matrix = my_mat)

# Lets double check our result:
sum(my_mat[,1])


# Now we can loop through all columns in the matrix and apply our function to
# each one. This is where the real power of functions comes out --that we can
# use them inside of more complex programs, even inside other functions:
for (i in 1:10) {
    colsum <- my_column_sum(col_number = i,
                            my_matrix = my_mat)
    cat(colsum,"\n")
}



### A Function Template ###

# Lets go over a general function template. We are also going to cover some
# additional features of functions:

template <- function (argument1,
                      argument2 = 10, # default argument
                      argument3 = NULL # NULL argument
                      ) {

    # It is often a good idea to check the types of variables you are passing
    # in to functions. This can prevent you from introducing bugs into your
    # code.

    # For example, lets make sure the first argument is a matrix
    if (class(argument1)[1] != "matrix") {
        # the stop() function will halt execution if it is called.
        stop("argument1 must be a matrix!")
    }

    # We may also want to check to make sure it is a numeric matrix. To do so
    # we will need to check against both "numeric" and "integer" types in the
    # first cell:
    if (class(argument1[1,1])[1] != "numeric" &
        class(argument1[1,1])[1] != "integer") {
        # the stop() function will halt execution if it is called.
        stop("argument1 must be a numeric matrix!")
    }

    # Now lets make sure that a single number is provided as argument2.
    # First we make sure it is of length 1
    if (length(argument2) != 1) {
        stop("argument2 must be of length 1.")
    }
    # Now make sure it is numeric.
    if (class(argument2)[1] != "numeric") {
        stop("argument2 must be a number!")
    }

    # Check to see if argument 3 was NULL. If it was, do not do more stuff,
    # but if it was not NULL, do more stuff.
    do_more_stuff <- FALSE
    if (!is.null(argument3)) {
        do_more_stuff <- TRUE
        if (class(argument3)[1] != "character") {
            stop("argument3 must be a string, if it is provided.")
        }
    }

    # Let the user know all variables checked out:
    cat("All variables look good!\n")
    # Now actually do stuff:

    # Start by adding argument2 to each element of the matrix:
    argument1 <- argument1 + argument2

    # Now let's calcuate the sum:
    total <- sum(argument1)

    # If argument3 was provided:
    if (do_more_stuff) {
        # Visit each cell in the matrix
        for (i in 1:nrow(argument1)) {
            for (j in 1:ncol(argument1)) {
                cat("The cell at [",i,",",j,"] contains ",argument1[i,j]," ",
                    argument3,"s \n",sep = "")
            }
        }
    }

    # now return the updated matrix in argument1, and argument3 together in a
    # list object
    to_return <- list()
    to_return$argument1 <- argument1
    to_return$argument3 <- argument3

    # We can only return one object, so a list can help work around this
    # limitation:
    return (to_return)

}

# Let's try it out!

# Start by creating a matrix
my_mat <- matrix(1:100,
                 ncol = 10,
                 nrow = 10)

# We do not need to give an argument name if there is only one required
# argument (one without a default value):
temp <- template(my_mat)

# Now let's change one of the default arguments
temp <- template(my_mat,
                 argument2 = 20)

# Finally let's change argument3
temp <- template(my_mat,
                 argument2 = 1000,
                 argument3 = "koala bear")

# Let's break it! First, we just pass in a string as the first argument:
temp <- template("catzzz rule",
                 argument2 = 1000,
                 argument3 = "koala bear")

# Now instead, we can try a matrix full of strings:
my_catzz <- matrix("catttzzzzz",
                 ncol = 10,
                 nrow = 10)

# Which throws a different error:
temp <- template(my_catzz,
                 argument2 = 1000,
                 argument3 = "koala bear")


### Using Functions Stored in Another File ###

# Start by setting your working directory:
setwd("~/Desktop")

# Now use source() to load in additional user-defined functions:
source("Workshop_7-Additional_Functions.R")

# Let's try out our function on some example data:
my_mat <- matrix(1:900,
                 nrow = 30,
                 ncol = 30)

# We need to pick some numbers to find:
nums_to_find <- c(1,47,450,2000)

# Now try out the function:
find_positions(mat = my_mat,
               numbers = nums_to_find)

# And for some fun, lets say hello:
say_hello("everyone")



