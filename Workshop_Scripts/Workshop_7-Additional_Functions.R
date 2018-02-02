# This function finds the row and column indicies of specified numbers in a
# matrix, and returns an NA if the number could not be found. "mat" is the
# input matrix, and numbers is a numeric vector of length one or more that
# contains numbers we want to search for:
find_positions <- function(mat,
                           numbers) {


    # Let's make sure the first argument is a matrix
    if (class(mat)[1] != "matrix") {
        stop("mat must be a matrix!")
    }

    # Check to make sure it is numeric
    if (class(mat[1,1])[1] != "numeric" &
        class(mat[1,1])[1] != "integer") {
        stop("mat must be a numeric matrix!")
    }

    # Now let's make sure that numbers are numeric
    if (class(numbers) != "numeric") {
        stop("numbers must be a numeric vector")
    }

    # Create a three column data.frame to store the row and column indices (and
    # the number itself), that we want to find.
    indices <- data.frame(row = rep(NA,length(numbers)),
                          column = rep(NA,length(numbers)),
                          number = numbers)

    # Loop over each number we want to find:
    for (i in 1:length(numbers)) {

        # We only want to find the first instance of a number, so we see a
        # boolean to let ourselves know that we found it (or not).
        Found <- FALSE

        #Loop over rows and columns of the matrix:
        for (j in 1:nrow(mat)) {
            for (k in 1:ncol(mat)) {
                if (mat[j,k] == numbers[i] & !Found) {
                    indices[i,1] <- j # store row index
                    indices[i,2] <- k # store column index
                    Found <- TRUE # flip boolean
                }
            }
        }
    }

    # Now just return results:
    return(indices)
}


# Here is another toy function that says hello to the 'name' argument five
# times, with a one second pause between each.
say_hello <- function(name) {
    for (i in 1:5) {
        # Say hello:
        cat("Hello ",name,"!\n", sep = "")
        # Tells R to pause for one second:
        Sys.sleep(1)
    }
}
