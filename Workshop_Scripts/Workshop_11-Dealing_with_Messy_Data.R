#### Dealing with Messy Data ####

# Preliminaries
rm(list = ls())
setwd("~/Desktop")

# Read in the data
library(rio)
Messy_Data <- import("Workshop_11-Messy_Data.csv")

# Okay, lets start by looking at these data. These are some of the results of a
# web-based experiment I ran, that have been corrupted by me, to serve as an
# example. I am going to walk you through the process I would go through to
# clean these data before attempting to analyze them.

# The first thing we should notice is that the 'Amount_Paid' variable is of type
# "chr", when it looks like it should be all numbers, and thus numeric. This is
# one of the most common errors I run into, and means that somewhere in data
# collection, something other than a number was inserted. Lets address this
# first. Since there is a limited range of possibilities for values, we can
# start by taking the unique of this column to try to identify the issue:
unique(Messy_Data$Amount_Paid)

# We see there is an "error" and "NaN" value. Lets ignore the NaN for now (we
# will remove it next), and simply get rid of the observation(s) for which we
# have an "error":
to_remove <- which(Messy_Data$Amount_Paid == "error")
Messy_Data <- Messy_Data[-to_remove,]

# Now recode the column as numeric
Messy_Data$Amount_Paid <- as.numeric(Messy_Data$Amount_Paid)

# In general, we should always check for NaN (not a number) values in any of the
# numeric variables in data we read in. The same goes for NA values (which we
# may want to keep in some situations, such as if NA was a legitimate answer),
# and NULL values (where we generally want to remove observations that contain
# them since they tend to signal an issue). We can check for all of these using
# a which statement. To make it easier to use, lets wrap it in a function:

check_for_bad_numbers <- function (column) {
    # check for bad number types using builtin functions
    bad_numbers <- which(is.nan(column) | is.na(column) | is.null(column))
    return(bad_numbers)
}

# Lets find and remove these rows:
to_remove <- check_for_bad_numbers(Messy_Data$Amount_Paid)

# Make sure there was at least one bad row:
if (length(to_remove) > 0) {
    Messy_Data <- Messy_Data[-to_remove,]
}

# Lets do the same thing for 'Allocation'
to_remove <- check_for_bad_numbers(Messy_Data$Allocation)
if (length(to_remove) > 0) {
    Messy_Data <- Messy_Data[-to_remove,]
}

# Another step I would take would be to remove all observations where
# 'Left_Early == "yes"':
to_remove <- which(Messy_Data$Left_Early == "yes")
if (length(to_remove) > 0) {
    Messy_Data <- Messy_Data[-to_remove,]
}

# The next issue we could run into is that several columns get condensed into
# one. This seems to be the case with the 'Payment_Group' column. We can split
# this column apart using the "stringr::str_split command.

# If you did not already download the stringr package, do so now with:
# install.packages("stringr", dependencies = TRUE)
library(stringr)

# Create a data.frame to store the numbers when they have been split apart:
addition <- data.frame(Group_Member_1 = rep(0, nrow(Messy_Data)),
                       Group_Member_2 = rep(0, nrow(Messy_Data)),
                       Group_Member_3 = rep(0, nrow(Messy_Data)),
                       Group_Member_4 = rep(0, nrow(Messy_Data)))

# Now we will want to split up the data based on the Group variable, since the
# Baseline group does not record some columns.
for (i in 1:nrow(Messy_Data)) {

    # Split the string on ", " to get numbers
    temp <- stringr::str_split(Messy_Data$Payment_Group[i],", ")[[1]]
    # They are still strings, so convert them to numbers
    temp <- as.numeric(temp)
    # Add to addition
    addition[i,] <- temp
}

# Now remove the Payment_Group column and add on the 4 new columns:
Messy_Data <- Messy_Data[,-9]
# We use the cbind() command to stick together two dataframes by columns:
Messy_Data <- cbind(Messy_Data,addition)

# After this, I would split up this dataset into two, one for the "Baseline"
# condition, and one for the rest. This is because the "Baseline" condition
# does not record any information in the Previous_Allocations and
# Avg_Previous_Allocations columns. We can then remove these columns from the
# "Baseline" dataset:
baseline_rows <- which(Messy_Data$Group == "Baseline")

# Extract the baseline rows:
Baseline <- Messy_Data[baseline_rows,]

# Remove the two extraneous columns:
Baseline <- Baseline[,-c(4,5)]

# Now extract the non-baseline rows:
Treatments <- Messy_Data[-baseline_rows,]

# Using the summary function is a great idea!
summary(Treatments$Amount_Paid)

# Or try the unique function for text variables:
unique(Treatments$Group)

# The last step I would take, like the first, would be to simply look at the
# data! If we see anything else out of place, then we need to fix it. Using the
# unique() function is often the easiest way to look for weird stuff. The
# last step would just be to save our two clean datasets!
# save(list = c("Baseline","Treatments"), file = "Clean_Data.RData")



