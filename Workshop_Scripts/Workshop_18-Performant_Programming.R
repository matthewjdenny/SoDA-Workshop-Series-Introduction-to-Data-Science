#### Performant Programming in R ####


### Efficient Programming ###

# Always clean out your environment and set your working directory:
rm(list = ls())
setwd("~/Desktop")

# Lets look at how much slower things get when we use growing data
# structures than when we use pre-allocation:

# In this example, I am going to construct a vector of length 100,000 one
# element at a time. The first way will use a growing data structure, the second
# will use a pre-allocated one. Note that we are also going to use the
# system.time function here to time how long it takes. If you want to time
# something that spans multiple lines, use {} inside of the () so that it knows
# you are timing multiple lines of code:

# First, lets try a growing data structure:
system.time({
    vect <- NULL
    for (i in 1:100000) {
        vect <- c(vect,i)
    }
})

# Now, lets try a pre-allocated data structure:
system.time({
    vect <- rep(0, 100000)
    for (i in 1:100000) {
        vect[i] <- i
    }
})


# Now we are going to cover the speedup from using the builtin functions in R
# vs. hand-coding your own implementation.

# Lets start by creating an example vector of length 100,000,000 to use in the
# example below:
vect <- 1:100000000

# First, we are going to take the sum of this vector using a for() loop:
system.time({
    # Initialize a "total" variable to 0:
    total <- 0
    # Increment the total with a for loop:
    for (i in 1:length(vect)) {
        total <- total + vect[i]
    }
    print(total)
})

# Sum over the same vector using the built in sum() function in R, which is
# coded in C:
system.time({
    # Note that becasue this vector is so large, we have to use
    # sum(as.numeric()) or we will get an error message:
    total <- sum(as.numeric(vect))
    print(total)
})

# For our next example, lets consider the case where we want to build a
# sociomatrix. We have a two column matrix as input. The first column records
# the index of the sender, the second column records the index of the recipient.
# We are going to form a sociomatrix (a matrix recording the number of times
# each actor sent something to each other actor), in the naive way, and then in
# a much faster way.

# Set the number of messages and actors:
messages <- 1000000
actors <- 5000

# Create some fake message data (sender recipient pairs):
fake_data <- data.frame(sender = round(runif(messages, min = 1, max = actors)),
                        recipient = round(runif(messages, min = 1, max = actors)))

# Now create a balnk sociomatrix in which to store our results
sociomatrix_1 <- matrix(0,
                        nrow = actors,
                        ncol = actors)

# First, we are going to try the slow way using a for() loop:
system.time({
    for (i in 1:messages) {
        sociomatrix_1[fake_data$sender[i],fake_data$recipient[i]] <-
            sociomatrix_1[fake_data$sender[i],fake_data$recipient[i]] + 1
    }
})

# Now, we are going to try the fast way using the table() function:
system.time({
    sociomatrix_2 <- as.matrix(as.data.frame.matrix(table(fake_data)))
})

# We can also test to see if we get the same result, using the all.equal()
# function. Note that before using this function, I turn each matrix into a
# numeric vector. This makes comparison easier.
all.equal(as.numeric(sociomatrix_1) , as.numeric(sociomatrix_2))


# For our final example, we are going to generate a very sparse two column
# dataset:

# Set the seed for replicability
set.seed(1234)
# Set the number of observations we want to work with:
numobs <- 10000000
# Observations we want to check:
vec <- rep(0,numobs)
# Only select 100 to check:
vec[sample(1:numobs,100)] <- 1
# Combine the two columns into a data.frame:
data <- cbind(1:numobs,
              vec)

# Sum only over the entries in the first column where the second column is equal
# to 1, using a for() loop:
system.time({
    total <- 0
    for (i in 1:numobs) {
        # Use a conditional to give ourselves periodic updates on our progress:
        if (i %% 1000000 == 0) {
            print(i)
        }
        # Only increment the sum if the condition is met
        if (data[i,2] == 1) {
            total <- total + data[i,1]
        }
    }
    print(total)
})

# Now we can instead sum over the subset of observations where the second column
# is equal to 1 using the subset function (coded in C). In many ways, this works
# just like using the which function to get the row indices, then subsetting the
# data manually with those indices:
system.time({
    # dat <- subset(data, data[,2] == 1)
    dat <- data[which(data[,2] == 1),]
    total <- sum(dat[,1])
    print(total)
})
# So much faster!!!


# Lets try an example. The goal here is to add a marker to each row
# indicating the number of identical bill_ids to the bill id for
# that row. Lets start by loading in the data
load("Workshop_18_Example_Data.RData")

# We can take advantage of these data being sorted to use the match function:
starts <- match(unique(data$bill_id),data$bill_id)

# now we do some clever math to get the ending index:
ends <- c(starts[2:length(starts)] -1, nrow(data))

# now for each unique bill, we get the count of sections:
num_secs <- c(starts[2:length(starts)],nrow(data)) - starts

# create a vector to store the results
number_of_sections <- rep(0,nrow(data))

# loop through and set the section count for each section:
for (i in 1:length(starts)) {
    if (i %% 1000 == 0) {
        print(i)
    }
    number_of_sections[starts[i]:ends[i]] <- num_secs[i]
}

# append to data.frame
data$number_of_sections <- number_of_sections

### Handling Big Data ###

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


