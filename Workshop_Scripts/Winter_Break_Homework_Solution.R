###### Cleaning and Combining Datasets: Assignment 2 SOLUTION #####


### Preliminaries ###
rm(list = ls())

# Set your working directory to the folder containing 471 .csv files. For me,
# this looks like:
setwd("~/Desktop/Multi_Datasets")

# You will want to make use of the following package, which you can download if
# you have not already:
# install.packages("rio", dependencies = TRUE)
library(rio)


### Exercise 1 ###

# Initialize data to NULL
sections <- NULL

# Loop over 471 datasets. Alternatively we could only loop over 1:20, to make
# everything go faster:
for (i in 1:20) {
    # print out the current dataset to keep track of our progress:
    print(i)

    # import the current dataset and use 'paste()' to generate the filenames
    cur <- import(paste("dataset_",i,".csv", sep = ""))

    # 'rbind()' the current data onto the full data.frame
    sections <- rbind(sections,cur)
}

# But what if we did not know the filenames or they did not follow a common
# pattern?

# We could use 'list.files()' to get the names of all files in the current
# working directory, then just use those:
files <- list.files()

# Proceed as we did above, but not using files[i] as the name for each file:
sections <- NULL
for (i in 1:length(files)) {
    print(i)
    cur <- import(files[i])
    sections <- rbind(sections,cur)
}

# Check our answer if using the full 471 datasets:
470800 == nrow(sections) # the correct number of rows.

# Check our answer if using the first 20 datasets:
20000 == nrow(sections) # the correct number of rows.

### Exercise 2 ###

# create a blank vector to hold bill IDs:
Bill_ID <- rep("",nrow(sections))

# Loop over rows and fill in Bill_ID:
for (i in 1:nrow(sections)) {
    # generate a bill ID for each section
    Bill_ID[i] <- paste(sections$session[i],
                        sections$chamber[i],
                        sections$number[i],
                        sep = "-")
}

# Alternatively, we could just do the following, which would be much faster:
Bill_ID <- paste(sections$session,
                 sections$chamber,
                 sections$number,
                 sep = "-")

# Get the unique bills:
unique_bills <- unique(Bill_ID)

# Create a vector to hold the count of sections in each unique bill:
Sections <- rep(0, length(unique_bills))

# Create a copy of sections, the make it have the right number of rows. We will
# then overwrite these row values with the correct ones:
bills <- sections
bills <- bills[1:length(unique_bills),]

# Loop over unique bills (this will take half an hour or so):
for (i in 1:length(unique_bills)) {
    # print out the current dataset to keep track of our progress:
    if (i %% 100 == 0) {
        print(i)
    }

    # Find the rows associated with each unique bill:
    inds <- which(Bill_ID == unique_bills[i])

    # Record the number of sections associated with the current bill
    Sections[i] <- length(inds)

    # Replace the row with the correct data
    bills[i,] <- sections[inds[1],]

}

# Now add on our "Sections" variable
bills <- bills[,-5] # remove the fifth column("section")
bills <- cbind(bills, Sections)

# Check to make sure we have the right number of bills with full dataset:
97428  == nrow(bills)

# Check to make sure we have the right number of bills with first 20:
3309 == nrow(bills)
