#### Converting Between Long and Wide Format Data ####

# Some preliminaries:
rm(list = ls())

# Set your working directory:
setwd("~/Desktop")

# Load in the example data in long format:
load("Long_Wide_Data.RData")

# We will need the tidyr package to convert from long to wide format:
install.packages("tidyr",dependencies = TRUE)

# load in the package
library(tidyr)

### Converting Long Data to Wide Data ###

# We use the spread function to convert long data to wide format:
wide_data <- tidyr::spread(data = long_data, # the dataset we want to convert
                           key = Section, # the new column names
                           value = Terms) # the stuff that gets put in the wide columns

# These column names aren't very helpful, lets try to make them better:
long_data$Section <- paste("Section",long_data$Section,sep = "_")

# Lets make the wide data again:
wide_data <- tidyr::spread(data = long_data,
                           key = Section,
                           value = Terms)

# The column names are still knid of messed up (bad ordering), so lets fix them.
# To do so, we need to put leading zeros before the 1 and 2 digit numbers. We
# can write a more general function to do this for any similar situation, which
# I do, below:
format_var_names <- function(numbers,
                             prefix = "Section") {
    # turn nubmers into characters
    numbers <- as.character(numbers)
    # get the maximum number of digits in the numbers
    max_digits <- max(nchar(numbers))
    # loop over each nubmer and add leading zeros where necessary
    for (i in 1:length(numbers)) {
        # get the number of characters (digits) in the current number
        nc <- nchar(numbers[i])
        # create a string with the right number of zeros to tack on the front
        # of this string
        add_zeros <- paste0(rep("0",max_digits - nc), collapse = "")
        # tack on the zeros in front (where necessary), and assign back to the
        # appropriate slot in numbers
        if (length(add_zeros) > 0) {
            numbers[i] <- paste(add_zeros, numbers[i], sep = "")
        }
    }

    # now paste together the prefix and the numbers
    numbers <- paste("Section",numbers,sep = "_")
    # return the correct numbers
    return(numbers)
}

# Reload in data:
load("Long_Wide_Data.RData")

# These column names aren't very helpful, lets try to make them better:
long_data$Section <- format_var_names(long_data$Section)

# Lets make the wide data again:
wide_data <- tidyr::spread(data = long_data,
                           key = Section,
                           value = Terms)


### Converting Wide Data to Long Data ###

long_data_2 <- tidyr::gather(data = wide_data, # The wide dataset.
                             key = Section, # The name of the new key column.
                             value = Terms, # The name for the new values column.
                             Section_001:Section_816) # The columns to be converted to long format.

# now we need to remove all of the observations containing an NA in the 'Terms'
# column:
to_remove <- which(is.na(long_data_2$Terms))
long_data_2 <- long_data_2[-to_remove,]

# We can also sort by Bill name, to get back to something that looks like our
# original dataset:
long_data_2 <- long_data_2[order(long_data_2$Bill),]

