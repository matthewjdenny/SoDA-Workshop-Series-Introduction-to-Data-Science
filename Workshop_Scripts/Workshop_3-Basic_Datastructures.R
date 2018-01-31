#### Five Basic R Datastructures ####

rm(list = ls())

### Values and Vectors ###

# Assign a value to a variable (remember to use no spaces or symbols other than
# . or _ in your variable name):
my_value <- 24 # number
my_value <- "dog" # character
my_value <- FALSE # boolean

# Create a vector using the concatenation operator 'c()'. This is our first
# example of a variable that can hold multiple values:
my_vector <- c(5,34,76,13)
my_vector <- c("Sophie","Cali","Maisy")

# Entering the variable into your console shows you its contents:
my_vector

# We can also us the ':' operator to give us all numbers in a range (in this
# case between 1 and 10):
my_vector <- 1:10

# another useful tool is the rep() function, which allows us to repeat a
# specified value a given number of times in a vector:
repeated_values <- rep(23, times = 50)

# We can index (get) elements of a vector by giving the position (as a positive
# integer) of the element in the vector. Note that all indexing in R starts from
# 1 and not zero, as in some other programming languages.
my_vector[5]

# Another very useful function, 'length()' tells us the number of elements in a
# vector or list object (don't worry, we haven't gotten to lists yet):
length(my_vector)



 ### Matrices ###

# We can also create a matrix (can only hold one kind of data -- usually
# numbers) by using the 'matrix()' function:
my_matrix <- matrix(data = 1:10, # what gets stored in the matrix
                    ncol = 5, # the number of columns
                    nrow = 20, # the number of rows
                    byrow = TRUE) # how the input should be added to the matrix.

# We can index the elements of matrices in a variety of ways:
my_matrix[1,] # rows come before the comma [row,colum]
my_matrix[,5] # columns come after
my_matrix[3,3]

# We can create new variables out of pieces of matrices:
val <- my_matrix[3,3]
val <- my_matrix[,3]

# There are some helpful functions we can use to learn more about a particular
# matrix:
sum(my_matrix) # the sum of the elements in the matrix.
nrow(my_matrix) # the number of rows in the matrix
ncol(my_matrix) # the number of columns in the matrix



### Data Frames ###

# Lets make some fake data!
student_id <- c(1:10)
grades <- c("A","B","C","A","C","F","D","B","B","A")
class <- c(rep(0,times = 5),rep(1,times = 5))
free_lunch <- rep(TRUE,times = 10)


# Now we can put the vectors we created above together to make a 'data.frame',
# one of the most commonly used data types in R. Data frames very useful because
# they can hold multiple types of values (e.g. text and numbers), and because
# columns are easy to index by name using the '$' operator (see below). They
# are also the most common input for most statistical packages and methods in R.
# Make sure to use the 'stringsAsFactors = FALSE' argument so that we do not
# turn our letter grades into factor variables (a kind of categorical variable
# that R likes). This is just generally true (ALWAYS DO THIS). Factor variables
# are like the dinosaurs from Jurassic Park, they refuse to die out.
my_data <- data.frame(student_id,
                      grades,
                      class,
                      free_lunch,
                      stringsAsFactors = FALSE)

# We can set column names if we like:
colnames(my_data) <- c("Student_ID", "Grades","Class","Free_Lunch")

# We can also set row names
rownames(my_data) <- LETTERS[11:20]

# Indexing works the same as for matrices, but with a twist:
my_data[,1]
my_data[2,4]
my_data$Student_ID # $ indexing for columns
my_data$Grades[3] # Treating $ indexed columns as vectors


### List Data Structures ###

# To create an empty list, object, we actually use the 'vector()' function.
my_list <- vector(mode = "list", length = 10)

# We can also create a list from objects. Note that we can name each entry in a
# list just as we would with a data.frame:
my_list <- list(num = 10,
                animal = "dog",
                vec = c(1:10),
                dat = my_data)

# We can also create an empty list and then populate it using the $ operator
my_list <- list()

# Now lets add stuff to our list!
my_list$num = 10
my_list$dat = my_data
my_list$cool_car = "Honda Civic"

# We can also glue lists onto the end of other lists using the 'append()'
# function
my_list <- append(my_list, list(list(27,14,"cat")))

# Lets look at the contents of our list:
print(my_list)

# And extract one of the elements using [[]] indexing:
my_second_data_frame <- my_list[[4]]
my_list$dat


### Subsetting ###

# The most basic form of subsetting is extracting a group of elements from a
# vector. This is best illustrated by example:
my_vector <- 1:10
my_vector[3:5] # extract the 3rd to 5th elements
new_vector <- my_vector[3:5] # assign them to a new vector
my_vector[c(1,2,9)] # extract the 1st, 2nd, and 9th elements in a vector:

# We can also use the c() function to take arbitrary subsets of a matrix:
my_matrix[c(1:3,5),c(2,4)]

# With lists, we need to be careful about the difference between [[]] and []
new_list <- my_list[1] # returns a list
new_value <-  my_list[[1]] # returns the ting we stored in the list

# Need to use single bracketts to subset a list
new_list <- my_list[1:2]


## Intelligent Subsetting ##

# The 'which()' function lets us identify observations that meet a certain
# criteria. This example also introduces the '$' operator which lets us access a
# variable in a data frame by name:
which(my_data$Grades == "A")

# Now we can create a new dataset that only includes A or B students by saving
# the indexes of the A and B students and then using them to extract a subset of
# the full data:
A_students <- which(my_data$Grades == "A")
B_students <- which(my_data$Grades == "B")
students_for_reduced_dataset <- c(A_students, B_students)

# We now use the vector to index only the rows we want, and extract them, saving
# them to a new object. Note that we index by [row,column], and if we leave one
# of these fields blank, then we take the entire row (or column).
reduced_data <- my_data[students_for_reduced_dataset,]

