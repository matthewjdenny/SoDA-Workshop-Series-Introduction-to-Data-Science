### Handling Big Data ###
setwd("~/Desktop")

# Start by setting the seed so our results are reproducible
set.seed(12345)

# Next create some big fake sparse (lots of zeros) data:
big_data <- matrix(round(rnorm(10000000) * runif(10000000, min = 0,max = 0.2)),
                   nrow = 1000000,
                   ncol = 100)

# Find out how many entries are just zeros:
length(which(big_data == 0))

# Now lets represent this as a simple triplet matrix:
install.packages("slam", dependencies = TRUE)
library(slam)

# Now we can use this function provided by slam to transform our dense matrix
# into a sparse matrix:
sparse_big_data <- slam::as.simple_triplet_matrix(big_data)

# Lets check the value at this index in the matrix object:
big_data[1436,1]

# Now we can try the same thing for the sparse matrix object:
as.matrix(sparse_big_data[1436,1])

# Now lets see what happens when we save the data as a .csv vs. as an .RData
# file:

# install.packages("rio", dependencies = TRUE)
library(rio)
setwd("~/Desktop")

# Try saving in both formats and look at the file sizes:
export(big_data, file = "Data.csv")
save(big_data, file = "Data.RData")





## Parallelization ###

# Lets start with an example of parallelization using the foreach package in R:

# First we create some toy data:
num_cols <- 300
my_data <- matrix(rnorm(100000),
                  nrow = 100000,
                  ncol = num_cols)

# Define a function that we are going to run in parallel:
my_function <- function(col_number,
                        my_data){
    temp <- 0
    for (j in 1:nrow(my_data)) {
        if (my_data[j,col_number] > 0.1) {
            if (my_data[j,col_number] < 0.5) {
                temp <- temp + sum(my_data[j,])
            }
        }
    }

    return(temp)
}

# We will rely on a couple of packages here, so make sure you have them
# installed:
# install.packages(c("doParallel","foreach"), dependencies = TRUE)
library(doParallel)
library(foreach)

# First we need to register the number of cores you want to use:
cores <- 4

# Then we create a cluster:
cl <- makePSOCKcluster(cores)

# Next we register the cluster with DoParallel:
registerDoParallel(cl)

# Run analysis in serial
system.time({
    serial_results <- rep(0,num_cols)
    for (i in 1:num_cols) {
        if (i %% 10 == 0) {
            print(i)
        }
        serial_results[i] <- my_function(i, my_data)
    }
})

# Run analysis in parallel:
system.time({
    parallel_results <- foreach(i = 1:num_cols,.combine = rbind) %dopar% {
        cur_result <- my_function(i, my_data)
    }
})
stopCluster(cl)


# Now lets try to redo one of our earlier examples managing multiple datasets:
read_in_dataset <- function(filename, # the name of the file we want to read in.
                            has_header, # option for whether file includes a header.
                            columns_to_keep) { # number of columns to keep in dataset.

    # Assumes a .csv file, but could be modified ot deal with other file types:
    temp <- read.csv(filename,
                     stringsAsFactors = F,
                     header = has_header)


    # lets set some column names using 'paste()' for fun:
    colnames(temp) <-  paste("Bill",1:ncol(temp), sep = "_")

    # If columns_to_keep was NULL, set it to the number of columns in the dataset.
    if (is.null(columns_to_keep)) {
        columns_to_keep <- ncol(temp)
    }
    temp <- temp[,1:columns_to_keep]

    return(temp)

}

# Now lets define a function for extracting cosponsorship information from a
# dataset and putting it in a cosponsorship matrix:
generate_cosponsorship_matrix <- function(raw_data) {

    # Get the number of legislators:
    num_legislators <- nrow(raw_data)

    # Create a sociomatrix:
    sociomatrix <- matrix(0,
                          ncol = num_legislators,
                          nrow = num_legislators)

    # Loop through bills (columns)
    for (j in 1:ncol(raw_data)) {

        # If there are a lot of bills, then we may want to check in with the
        # user periodically to let them know about progress:
        if (j %% 1000 == 0) {
            cat("Working on bill",j,"of",ncol(raw_data),"\n")
        }

        # Find out who the bill sponsor is (coded as a 1):
        for (i in 1:nrow(raw_data)) {
            if (raw_data[i,j] == 1) {
                sponsor <- i
            }
        }

        # Find all of the cosponsors:
        for (i in 1:nrow(raw_data)) {
            if (raw_data[i,j] == 2) {
                sociomatrix[i,sponsor] <- sociomatrix[i,sponsor] + 1
            }
        }
    }

    return(sociomatrix)
}


# Now we define a function that calls these two functions to do everything:
preprocess_data <- function(filenames,
                            has_header = FALSE,
                            columns_to_keep = NULL) {

    # Create a list object to store the raw and preprocessed data:
    data_list <- vector(mode = "list",
                        length = length(filenames))

    # Loop over files and load/preprocess them
    for (i in 1:length(filenames)) {
        cat("Reading in file",i,"\n")
        data_list[[i]]$raw_data <- read_in_dataset(filenames[i],
                                                   has_header,
                                                   columns_to_keep)

        cat("Preprocessing file",i,"\n")
        data_list[[i]]$sociomatrix <- generate_cosponsorship_matrix(data_list[[i]]$raw_data)
    }

    # Give list entries some basic names:
    names(data_list) <-  paste("Dataset",1:length(filenames), sep = "_")

    # Now just return everything
    return(data_list)
}

# Here we ar going to go one step further, and try this in parallel:

wrapper_function <- function(filename,
                             has_header,
                             columns_to_keep,
                             fun1,
                             fun2) {
    # Create a blank list object
    data_list <- list()

    # Load in the data and save it to the list object:
    data_list$raw_data <- fun1(filename,
                               has_header,
                               columns_to_keep)
    # Preprocess the data:
    data_list$sociomatrix <- fun2(data_list$raw_data)

    # Return the list object:
    return(data_list)
}

preprocess_parallel <- function(filenames,
                                cores = 1,
                                has_header = FALSE,
                                columns_to_keep = NULL,
                                fun1 = read_in_dataset,
                                fun2 = generate_cosponsorship_matrix) {

    # Create a cluster instance:
    cl <- parallel::makeCluster(getOption("cl.cores", cores))

    # Run our function on the cluster:
    data_list <- parallel::clusterApplyLB(cl = cl,
                                          x = filenames,
                                          fun = wrapper_function,
                                          has_header = has_header,
                                          columns_to_keep = columns_to_keep,
                                          fun1 = fun1,
                                          fun2 = fun2)

    # Stop the cluster when we are done:
    parallel::stopCluster(cl)

    # Give list entries some basic names:
    names(data_list) <-  paste("Dataset",1:length(filenames), sep = "_")

    # Now just return everything:
    return(data_list)
}

# Lets try it out!
setwd("~/Desktop/Data")
filenames <- list.files()

# Time the standard way of doing it:
system.time({
    serial_data <- preprocess_data(filenames,
                                   columns_to_keep = 200)
})

# Now try it out in parallel on 4 cores:
system.time({
    parallel_data <- preprocess_parallel(filenames,
                                         cores = 4,
                                         columns_to_keep = 200)
})