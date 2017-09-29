#### Basic R Programming ####


### Part 1: Variables, Comments, and Math ###

## Commenting ##

# Commenting: wherever you insert a '#', everything that comes after it will be
# ignored when entered into the R console. This means you can leave notes to
# yourself about what each line of code does, or 'comment out' lines of code you
# are no longer using. I make extensive use of comments in all of my code. You
# should too!


## Basic Math ##

# Addition:
129 + 3483

# Subtraction:
23693 - 4536

# Multiplication:
23 * 45

# Division:
51/3

# Exponents:
2^4

# Logarithms (base e):
log(100)


## Creating Variables ##

# Assign a value to a variable (remember to use no spaces or symbols other than
# . or _ in your variable name):
my_value <- 24

# Create a vector using the concatenation operator 'c()'. This is our first
# example of a variable that can hold multiple values:
my_vector <- c(5,34,76,13)

# Entering the variable into your console shows you its contents:
my_vector

# We can also us the ':' operator to give us all numbers in a range (in this
# case between 1 and 10):
my_vector <- 1:10

# We can technically also use the '=' operator to assign values to variables,
# but this is typically considered bad form, because it is easy to confuse with
# the '==' operator. For now, lets stick to using '<-':
my_vector = 1:10

# We can index (get) elements of a vector by giving the position (as a positive
# integer) of the element in the vector. Note that all indexing in R starts from
# 1 and not zero, as in some other programming languages.
my_vector[5]


## Removing Variables, Setting Working Directory ##

# Clearing your workspace: this removes all data and variables current in your
# 'R Environment'. As you will see, when you create variables they will continue
# to be available to you for the rest of your R session once you have made them,
# unless you remove them from memory. The line of code below will remove
# everything from memory. This can be useful if you want to rerun several
# different scripts without closing R after using each one.
rm(list = ls())

# Set your working directory -- This is where R goes to look for files and save
# stuff by default. You will need to do this for each computer you run your
# script file on. In RStudio, you can go to 'Session' -> 'Set Working Directory'
# -> 'Choose Directory', and select a folder from a drop down menu. For me, this
# looks like:
setwd("~/Desktop")



### Part 2: Comparison Operators ###

## The Basic Operators ##

5 < 6 # 5 is less than 6: returns TRUE
5 > 6 # 5 is not greater than 6: returns FALSE
5 == 5 # 5 is equal to 5: returns TRUE
5 != 6 # 5 is not equal to 6: returns TRUE
5 <= 5 # 5 is less than or equal to 5: returns TRUE


## Comparisons with Variables ##

# R will also do its best to make two quantities comparable, even if one is a
# string and the other is a number:
5345 == "5345"

# However if we assign a value to a variable, then it will compare the value
# in the variable, not the name of the variable. This is also the first time
# we have seen variables. They have have any name composed of letters, '.' and,
# '_'. Variables can store lots of stuff --as we will see in future tutorials.
# In this example, we are assigning the number 5 to the variable 'i' using the
# assignment operator '<-':
i <- 5

i == "i" # 5 is not equal to "i": returns FALSE

# Now we assign a string ("i") to the variable 'i':
i = "i"

i == "i" # "i" is equal to "i": returns TRUE



### Part 3: Printing ###

## The print() and cat() Functions ##

# Lets start by defining a vector:
my_vector <- c(5,34,76,13)

# We can look at what is in this variable by simply entering it into the
# console:
my_vector

# In addition to entering the variable name into the R console, we can also take
# a look at what is stored in a variable by using either the 'print()' or
# 'cat()' functions, which are built right into R:
print(my_vector)
cat(my_vector)


## cat() vs. print() ##

# The 'cat()' function will print things without "" marks around them, which
# often looks nicer, but it also does not skip to a new line if you call it
# multiple times inside of a function (something we will get to soon), or a
# loop. Lets try out both:
print("Hello World")
cat("Hello World")

# Now we can try them inside bracketts to see how 'cat()' does not break lines:
{
    cat("Hello")
    cat("World")
}

{
    print("Hello")
    print("World")
}

# So we have to manually break lines with 'cat()' using the "\n" (newline)
# symbol:
{
    cat("Hello\n")
    cat("World")
}


## The 'paste()' Function, and Generating Informative Messages ##

# The 'paste()' function takes as many string, number or variable arguments as
# you want and sticks them all together using a user specified separator:

# Lets define a variable to hold the number of fingers we have:
fingers <- 14

# Now lets print out how many fingers we have:
print(paste("Hello,", "I have", fingers, "fingers", sep = " "))

# Now lets separate with dashes just for fun:
print(paste("Hello,", "I have", fingers, "fingers", sep = "-----"))

# We can also try the same thing with 'cat()':
cat(paste("Hello,", "I have", fingers, "fingers", sep = " "))

# However, with 'cat()', we can just skip the paste part and it will print the
# stuff directly:
cat("Hello,", "I have", fingers, "Fingers", sep = " ")

# If we want 'cat()' to break lines while it is printing, we can also include
# the "\n" symbol at the end (or anywhere, for that matter):
cat("My Grocery List:\n", "1 dozen eggs\n",
    "1 loaf of bread\n 1 bottle of orange juice\n",
    "1 pint mass mocha", sep = " ")



### Using the help() Function ###

help(print)
help(sum)
?length

# Lets try out length() and sum():
my_vector <- c(1,2,3,4,5)
length(my_vector)
sum(my_vector)

# Lets try taking log() in base 2 or 10:
?log
log2(64)
log10(1000)