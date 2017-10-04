#### Data I/O and Packages ####

# In this workshop, we are going to write our school children data to a .csv file
# and then read the data back in to another R object. We are also going to learn
# how to save R objects in R's native binary format (very space efficient).

### Setting Your Working Directory ###

# The easiest way to set your working directory is to go to:
# Session -> Set Working Directory -> Choose Directory... and select the folder
# where you would like to set it. This will look different on each computer, so
# you will need to follow the directions for your computer. For example, if I
# wanted to set my working directory to my "Desktop" folder on my computer, I
# could follow the instructions above, set my working directory to the desktop
# folder, and RStudio would enter the command in my R Console. For me, this
# would look like:
setwd("~/Desktop")

# If I wanted to save some data using the save() function, this is where it
# would go:
my_vec <- 1:1000
save(my_vec, file = "my_vec.RData")

# Your working directory is also the place where R goes to look for data when
# you try to load it in. If I were to now clear my Environment and then try to
# load in the data, we see that it would work. If I were to do the same thing
# but now change my working directory, it would not work:

# Works!
rm(list = ls())
load("my_vec.RData")

# Does not work!
rm(list = ls())

# set my working directory somewhere else:
setwd("~/Dropbox")

# Trying to load in the data fails:
load("my_vec.RData")

# Try setting your working directory to a folder that does not exist:
setwd("~/Desktop/sdkfhskdhfllgkjsddf")


### Working With .csv Files Using Base R ###

# Create some fake data!
student_id <- c(1:10)
grades <- c("A","B","C","A","C","F","D","B","B","A")
class <- c(rep(0,times = 5),rep(1,times = 5))
free_lunch <- rep(TRUE,times = 10)

# Put it in a data.frame
my_data <- data.frame(student_id,
                      grades,
                      class,
                      free_lunch,
                      stringsAsFactors = FALSE)

# Set column and row names
colnames(my_data) <- c("Student_ID", "Grades","Class","Free_Lunch")
rownames(my_data) <- LETTERS[11:20]

# We make use of the 'write.csv()' function here. Make sure you do not write row
# names, this can really mess things up as it adds an additional column and is
# generally confusing:
write.csv(x = my_data,
          file = "school_data.csv",
          row.names = FALSE)

# Now we are going to read the data back in from the .csv file we just created.
# You should make sure that you specify the correct separator (the 'write.csv()'
# function defaults to using comma separation). I also always specify
# 'stringsAsFactors = FALSE' to preserve any genuine string variables I read in.
school_data <- read.csv(file = "school_data.csv",
                        stringsAsFactors = FALSE, # Always!!!
                        sep = ",")


## Other Data Formats ##

# We will need to load a package in order to read in excel data. This will
# extend the usefulness of R so that we can now read in .xlsx files among other
# types.

# First we need to download the 'rio' package, we can either do this manually
# or by using the package manager in base R. You can check this package out by
# visiting the development Github page: https://github.com/leeper/rio. You need
# to make sure you select 'dependencies = TRUE' so that you download the other
# packages that your package depends on, otherwise it will not work! Here is the
# manual way of installing an R package:
install.packages("rio", dependencies = TRUE)

# Now we have to actually load the package so we can use it. We do this using
# the library() command:
library(rio)

# Write our school children data to an .xlsx file:
export(my_data, "school_data.xlsx")

# Now we can read in our data from the excel file:
excel_school_data <- import("school_data.xlsx")

# We can do the same thing for Stata .dta files:

# Write data to a .dta file:
export(my_data, "school_data.dta")

# Then read it back in:
stata_school_data <- import("school_data.dta")



## RData files ##

# Finally we may want to read and write our data to an .RData file that can hold
# everything in our workspace, or just a single variable. This is a very good
# strategy for saving all of your files after a day of working so you can pick
# back up where you left off:

# Save one object:
save(my_data, file = "Object.RData")

# Save just a few objects:
save(list = c("my_data", "school_data"), file = "Two_objects.RData")

# Save your whole working directory
save(list = ls(), file = "MyData.RData")

# Now lets test it out by clearing our whole workspace:
rm(list = ls())

# Now we can load the data back in! It is good practice to set our working
# directory again first (remember to change this to the folder location where
# you downloaded the workshop materials or saved this script file!):
setwd("~/Desktop")

# Load in the two objects
load(file = "Two_objects.RData")

# Load in everything
load(file = "MyData.RData")
