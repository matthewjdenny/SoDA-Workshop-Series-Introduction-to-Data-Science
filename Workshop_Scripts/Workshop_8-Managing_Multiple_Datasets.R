#### Managing Multiple Datasets ####

### Reading in Multiple Datasets ###

# Some preliminaries:
rm(list = ls())

# Set your working directory to the "Data" directory associated with this topic.
# For me, this looks like:
setwd("~/Desktop/Data")

# We are going to be looking at a dataset that comprises legislative
# cosponsorship activity for 11 sessions of the U.S. Senate (22 years). It is
# broken up into 11 .csv files, which we will need to read in one at a time. The
# list.files() function can help us do this. It will return a list of all files
# in a folder as a character vector. We can use this vector to read in
# the files by name. They key thing is to make sure that there are not any
# files you do not want to read in in the folder, or to remove those afterward:
filenames <- list.files()

# These data are arranged in the following format: There is one row for each
# Senator (in a given session of Congress), and one column for each piece of
# legislation introduced in that session of Congress. The [i,j] entries in this
# matrix are equal to 1 if the i'th Senator was the "sponsor" of a bill --
# meaning that they wrote it, and 2 if the i'th Senator was a "cosponsor" of the
# bill (meaning they declared their formal, public support for it). The goal
# here is for each session of Congress, to construct a Senators x Senators
# matrix recording the number of times Senator i cosponsored a piece of
# legislation sponsored by senator j. We call this a sociomatrix, or
# adjacency matrix.

# Let's begin by loading in some data:
cat("Loading Data... \n")

# Create a list object to store the raw data in:
cosponsorship_data <- vector(mode = "list",
                             length = length(filenames))

# Loop over sessions of Congress:
for (i in 1:length(filenames)) {
    # Let ourselves know about progress:
    cat("Currently working on file:",i,"\n")

    # Read in the current dataset:
    temp <- read.csv(filenames[i],
                     stringsAsFactors = F,
                     header = F) # there are no column names in the raw data.


    # let's set some column names using 'paste()' for fun:
    colnames(temp) <-  paste("Bill",1:ncol(temp), sep = "_")

    # We are only going to look at the first 100 bills from each Congress to
    # save time. Alternatively, we could look at all of them:
    temp <- temp[,1:100]
    cosponsorship_data[[i]]$raw_data <- temp
}

# now let's set names for each list entry
names(cosponsorship_data) <-  paste("Congress",100:110, sep = "_")



### Processing Multiple Datasets ###

cat("Transforming Raw Data Into Cosponsorship Matrices...\n")

# Loop over sessions of Congress:
for (i in 1:length(filenames)) {
    # Let the user know what iteration we are on:
    cat("Currently on dataset number: ",i,"\n")

    # Extract the raw data so we can use it:
    temp <- cosponsorship_data[[i]]$raw_data

    # Create a sociomatrix to populate. Each entry in this matrix will record
    # the number of times Senator i cosponsored a bill introduced by Senator j.
    num_senators <- nrow(temp)
    temp_sociomatrix <- matrix(0,
                               ncol = num_senators,
                               nrow = num_senators)

    # This is an example of nested looping:
    for (j in 1:ncol(temp)) { # For every bill:

        # Find out who the bill sponsor is (coded as a 1):
        for (k in 1:nrow(temp)) { # For every Senator:
            if (temp[k,j] == 1) {
                sponsor <- k
            }
        }

        # Find all of the cosponsors:
        for (k in 1:nrow(temp)) { # For every Senator
            if (temp[k,j] == 2) {
                temp_sociomatrix[k,sponsor] <- temp_sociomatrix[k,sponsor] + 1
            }
        }
    }

    # Store the sociomatrix in a new field:
    cosponsorship_data[[i]]$sociomatrix <- temp_sociomatrix

}


# Let's have a little bit of fun plotting these networks:

# First, we will need a package for handling network data:
install.packages("statnet", dependencies = TRUE)
library(statnet)

# We are going to define a function that takes a year and a color and makes a
# network plot
netplot <- function(session,
                    color,
                    data_list = cosponsorship_data){

    # Create an objet of class "network" that can be used by statnet to generate
    # a network plot:
    net <- network::as.network(data_list[[session]]$sociomatrix)

    # When we give 'plot()' a network object, it returns a network plot:
    plot(net, vertex.col = color)

    # Wait for one second after plotting before moving on:
    Sys.sleep(1)

    # This function does not return anything.
}

# Now we are going to use a for() loop to plot these networks

for (i in 1:11) {
    netplot(i,i)
}



### Automating Tasks Using Functions ###

# So all of what we did above was suited to our particular data, but what
# happens if we want to do the same thing to a different dataset? Well we could
# go in an change our code to make it work for that dataset, or we could
# enclose it in functions so it is easy to apply it to other datasets. One of
# the key concepts here, is that the functions we write can call other functions
# we have also written, making our code more flexible and extensible. Below, I
# am going to rewrite the above code by warpping it in a series of functions
# that I can then use to replicate the process of reading in and preprocessing
# the network data:

# It is always best to start with the lowest level functions we want to work
# with. In this case, those would be a function to read in a single dataset,
# and a function to deal with a single bill (determining the cosponsors, if any).

read_in_dataset <- function(filename, # the name of the file we want to read in.
                            has_header, # option for whether file includes a header.
                            columns_to_keep) { # number of columns to keep in dataset.

    # Assumes a .csv file, but could be modified to deal with other file types:
    temp <- read.csv(filename,
                     stringsAsFactors = F,
                     header = has_header)


    # let's set some column names using 'paste()' for fun:
    colnames(temp) <-  paste("Bill",1:ncol(temp), sep = "_")

    # If columns_to_keep was NULL, set it to the number of columns in the dataset.
    if (is.null(columns_to_keep)) {
        columns_to_keep <- ncol(temp)
    }
    temp <- temp[,1:columns_to_keep]

    return(temp)

}

# Now let's define a function for extracting cosponsorship information from a
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
load_and_preprocess_cosponsorship_data <- function (filenames,
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

# Lets try it out!
setwd("~/Desktop/Data")
filenames <- list.files()

cosponsorship_data_2 <- load_and_preprocess_cosponsorship_data(filenames,
                                                               columns_to_keep = 100)



