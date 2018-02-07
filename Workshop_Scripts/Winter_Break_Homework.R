###### Cleaning and Combining Datasets: Assignment 2 #####

# NOTE: This assignment is relatively computationally intensive, and will take
# 30-60 minutes to run on a reasonably modern laptop, or a bit longer on an
# older computer. One of the reasons I am having you work on a larger dataset
# is to get used to things taking a bit of time to complete. If you do not have
# the time, or are working on a very slow computer, I suggest only working with
# the first 20-50 files associated with this exercise (there are 471 total).
# You will learn the same content, it will just run faster on your computer.

### Preliminaries ###
rm(list = ls())

# Set your working directory to the folder containing 471 .csv files. For me,
# this looks like:
setwd("~/Desktop/Multi_Datasets")

# You will want to make use of the following package, which you can download if
# you have not already:
# install.packages("rio", dependencies = TRUE)
library(rio)

# This assignment is a bit more open ended. If you go and look at the working
# directory, you will find 471 .csv files. You will need to read these in and
# combine them. They record some information about bills introduced in the U.S.
# Congress over a 22 year period (1993-2014). Each bill is broken down into
# sections, so there are multiple observations for each bill. Here is an
# explanation of what each variable is:

# $session -- The session of Congress in which the bill was introduced.
# $chamber -- HR = House of Representatives, S = Senate.
# $number -- The number assigned to the bill in that session of Congress.
# $type -- IH = Introduced in House, IS = Introduced in Senate.
# $section -- The index of each section.
# $Cosponsr -- The number of Cosponsors for each bill.
# $IntrDate -- The date the bill was introduced.
# $Title -- The title of the bill.
# $NameFull -- The full name of the legislator who introduced the bill.
# $major_topic_label -- The topic of the bill.
# $party_name -- The party of the legislator that introduced the bill.




### Exercise 1 ###

# Use a 'for()' loop to read in the data and combine them into a single
# data.frame. How many rows does this data frame have?

# Some hints:
# 1. Create a growing data.frame that starts out as NULL
# 2. Use the 'import()' function from the rio package.
# 3. If you only want to work with the first 20 datasets, then just loop over
# 1:20.



### Exercise 2 ###

# Create a new dataset that collapses the original dataset over bill sections so
# there is only one entry per unique bill. Add a field to this collapsed dataset
# called "Sections" that records the total number of sections associated with
# that bill. Removed the "section" variable from the data.frame as it is no
# longer necessary. How many rows are in this data.frame? Does the sum of the
# "Sections" variable in your new data.frame equal the number of rows in the old
# data.frame (with one entry per section)?

# Some hints:
# 1. You will need to assign a unique identifier to each bill. To do this, I
# suggest creating a text variable for each row where you 'paste()' together the
# $session, $chamber, and $number fields to make a $Bill_ID variable.
# 2. Use the 'unique()' function and then the 'which()' function inside of a
# 'for()' loop. You can either build up a data.frame, remove rows, or
# pre-allocate a dataframe and fill it. This last option will be much faster, but
# try it out for yourself.
# 3. Create a separate vector called "Sections". How long should it be? Then
# 'cbind()' it on to the reduced data.frame at the end.

# NOTE: This will take a while. My example code runs in 15 minutes or so. There
# are faster ways to solve this problem, but for now, just take a break and grab
# a bite to eat or go for a walk while your code runs.




### Exercise 3 ###

# Now collapse your data even further. Create a new dataset with one row for
# each unique legislator (e.g. 'unique(data$NameFull)'). This dataset should
# have the following fields:

# $Name -- the name of the legislator (from the $NameFull field)
# $Total_Bills -- The total number of bills introduced by that legislator
# $Total_Sections -- The total number of sections in bills they introduced.
# $Average_Sections -- The average number of sections in bills they introduced.
# $Earliest_Bill -- The session their first bill was introduced.
# $Most_Common_Topic -- The most common topic for bills they introduced. If
# there is a tie, take the first one, alphabetically.

# Some hints:
# 1. Loop over unique legislators, create a one-row dataframe for each one,
# then 'rbind()' them together.

















