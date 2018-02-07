#### Converting Between Long and Wide Format Data ####
#
#    "Spreading" and "Gathering" data
#
# Some preliminaries:
rm(list = ls())

# Set your working directory:
setwd("~/Desktop")


# We will need the tidyr package to convert from long to wide format:
install.packages("tidyr",dependencies = TRUE)

# load in the package
library(tidyr)

# The two fundamental operations in tidyr are "spread" and "gather" 
#
#  "spread" (= "cast", "unfold", "pivot", "long -> wide" in other contexts)
# 
#   Use when data for what you view as one observation is contained in multiple rows
#
#  Consider "table2" (included with tidyr) - data on TB cases from the WHO
table2
# # A tibble: 12 x 4
#       country  year       type      count
#         <chr> <int>      <chr>      <int>
#  1 Afghanistan  1999      cases        745
#  2 Afghanistan  1999 population   19987071
#  3 Afghanistan  2000      cases       2666
#  4 Afghanistan  2000 population   20595360
#  5      Brazil  1999      cases      37737
#  6      Brazil  1999 population  172006362
#  7      Brazil  2000      cases      80488
#  8      Brazil  2000 population  174504898
#  9       China  1999      cases     212258
# 10       China  1999 population 1272915272
# 11       China  2000      cases     213766
# 12       China  2000 population 1280428583
#
#  we want to spread these data, putting a country-year in one row
#       we need a "key": the variable that will become the new column names
#       we need a "value": the variable that holds the values to be spread
#
table2.wide <- tidyr::spread(data = table2,
                             key = "type",
                             value = "count")
table2.wide
# A tibble: 6 x 4
#       country  year  cases population
# *       <chr> <int>  <int>      <int>
# 1 Afghanistan  1999    745   19987071
# 2 Afghanistan  2000   2666   20595360
# 3      Brazil  1999  37737  172006362
# 4      Brazil  2000  80488  174504898
# 5       China  1999 212258 1272915272
# 6       China  2000 213766 1280428583
#
#  Or ....
#  "gather" (= "melt", "fold", "unpivot", "wide -> long" in other contexts)
#      Use, for example, when columns are values not variables.
#
#  Consider "table4a", and say again we'd rather have country-year observations:
table4a
#
# A tibble: 3 x 3
#       country `1999` `2000`
# *      <chr>  <int>  <int>
# 1 Afghanistan    745   2666
# 2      Brazil  37737  80488
# 3       China 212258 213766
# 
#  `1999` is a *value* of a variable, not a variable
#
#   for gather, we need key, value, and the names of columns to be "gathered":
table4a.long <- tidyr::gather( data = table4a,
                               key = "year",
                               value = "cases",
                               `1999`:`2000`)
table4a.long
# A tibble: 6 x 3
#       country  year  cases
#         <chr> <chr>  <int>
# 1 Afghanistan  1999    745
# 2      Brazil  1999  37737
# 3       China  1999 212258
# 4 Afghanistan  2000   2666
# 5      Brazil  2000  80488
# 6       China  2000 213766


# Now let's look at Matt's bills data example:

# Load in the example data in long format:
load("Long_Wide_Data.RData")

### Converting Long Data to Wide Data ###

# These data are about the Congressional bills and how long each section is ("terms")
#
#   Note that bills have different numbers of sections
summary(long_data$Section)
#
#   
# We use the spread function to convert long data to wide format:
wide_data <- tidyr::spread(data = long_data, # the dataset we want to convert
                           key = Section, # the new column names
                           value = Terms) # the stuff that gets put in the wide columns

# These column names aren't very helpful, lets try to make them better:
long_data$Section <- paste("Section",long_data$Section,sep = "_")

# Let's make the wide data again:
wide_data <- tidyr::spread(data = long_data,
                           key = Section,
                           value = Terms)

# The column names are still kind of messed up (bad ordering), so let's fix them.
# To do so, we need to put leading zeros before the 1 and 2 digit numbers. We
# can write a more general function to do this for any similar situation, which
# I do, below:
format_var_names <- function(numbers,
                             prefix = "Section") {
    # turn numbers into characters
    numbers <- as.character(numbers)
    # get the maximum number of digits in the numbers
    max_digits <- max(nchar(numbers))
    # loop over each number and add leading zeros where necessary
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
    numbers <- paste(prefix,numbers,sep = "_")
    # return the correct numbers
    return(numbers)
}

# Reload in data:
load("Long_Wide_Data.RData")

# These column names aren't very helpful, let's try to make them better:
long_data$Section <- format_var_names(long_data$Section)

# Let's make the wide data again:
wide_data <- tidyr::spread(data = long_data,
                           key = Section,
                           value = Terms)

# Note that the "wide" data here are pretty inefficient
#   Most of the entries for the higher section numbers are missing "NA"
#   In fact, since only one bill has 816 sections, the column #Section_816"
#   has only one non-missing entry:
summary(wide_data$Section_816)
#
#  Overall, there are more than 100x as many missing entries as non missing:
sum(is.na(wide_data))
sum(!is.na(wide_data))



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




