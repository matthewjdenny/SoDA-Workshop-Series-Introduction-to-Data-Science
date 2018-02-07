#### Looping and Conditional Statements ####

### For Loops ###

# 'for()' loops are a way to automate performing tasks by telling R how many
# times we want to do something. Along with conditional statments and comparison
# operators, loops are more powerful than you can immagine. Pretty much
# everything on your computer can be boiled down to a combinations of loops and
# conditionals.

# Here is an example 'for()' loop, with its English translation:
# for (           i in           1:10){
# for each number i in the range 1:10

# Lets try and example using a for() loop -- first lets create a vector:
my_vector <- c(20:30)
# Take a look at tis contents:
cat(my_vector)

# Notice how the value of i changes when we are inside the loop
i <- 76
# Loop over each index (position) in the vector at replace it with its square
# root:
for (i in 1:length(my_vector)) {
    cat(i,"\n")
    my_vector[i] <- sqrt(my_vector[i])
}

# Display the result:
cat(my_vector)

# Now lets try adding numbers together using a 'for()' loop:
my_num <- 0

for (i in 1:100) {
    my_num <- my_num + i
    cat("Current Iteration:",i,"my_num value:",my_num,"\n")
}



### If/Else Statements ###

# If/else statements give your computer a "brain", they let it see if somethng
# is the case, and dependent on that answer, your computer can then take some
# desired action.

# English translation of an if statement:
# if (some condition is met) {
#      do something
# }

# Lets try an example to check and see if our number is less than 20:
my_number <- 19

if (my_number < 20) {
    cat("My number is less than 20 \n")
}

# Now we try an example where the condition is not satisfied:
my_number <- 22

if (my_number < 20) {
    cat("My number is less than 20 \n")
}

# You can also add in an 'else' statement to do something only if the condition
# is not met:
if (my_number < 20) {
    cat("My number is less than 20 \n")
} else {
    cat("My number is at least 20 \n")
}



### Conditionals in Loops ###

# A more complex example using an 'if()' statement inside of a 'for()' loop:
my_vector <- c(20:30)

for (i in 1:length(my_vector)) {
    cat("Current Index:",i,"Value:",my_vector[i],"\n")

    if (my_vector[i] == 25) {
        cat("The square root is 5! \n")
    }
}

# Another example with and If/Else statement:
my_vector <- c(20:30)

for (i in 1:length(my_vector)) {
    cat("Current Index:",i,"Value:",my_vector[i],"\n")

    if (my_vector[i] == 25) {
        print("I am 25!")
    } else {
        print("I am not 25!")
    }
}



### Nested Looping, An Example with Real Data ###

# Lets read in some data (first make sure your working idrectory is set to the
# folder where the data are stored):
setwd("~/Desktop")
load("Looping_Conditionals_Example_Data.RData")

# In this example, we are going to work with a dataset of metadata on all bills
# introduced in the United States Congress between 2011-2012. It contains
# indicators of the number of cosponsors, the month the bill was introduced, the
# chamber it was introduced in (House or Senate), the topic code (see reference
# list below), and the party of the sponsor.

# Let's say we wanted to look at a subset of all bills that were introduced in
# the House that were about any of the first ten topics, and then take the sum
# of the number of bills introduced by each party that passed the house. This
# would give us an extremely crude measure of how effective each party was on
# these issues.

# Topic codes:
# 1. Macroeconomics
# 2. Civil Rights, Minority Issues, and Civil Liberties
# 3. Health
# 4. Agriculture
# 5. Labor and Employment
# 6. Education
# 7. Environment
# 8. Energy
# 9. Immigration
# 10. Transportation
# 12. Law, Crime, and Family Issues
# 13. Social Welfare
# 14. Community Development and Housing Issues
# 15. Banking, Finance, and Domestic Commerce
# 16. Defense
# 17. Space, Science, Technology and Communications
# 18. Foreign Trade
# 19. International Affairs and Foreign Aid
# 20. Government Operations

# Let's start by subsetting our data -- we only want HR bills with a topic code
# less than or equal to 10:
reduced_data <- data[which(data$Bill_Type == "HR" & data$Topic_Code <= 10),]

# Now we allocate a blank matrix to hold the statistics we plan to calculate. It
# should have two columns (Democrat and Republican), and 10 rows (one for each
# topic):
party_topic_statistics <- matrix(0,
                                 nrow = 10,
                                 ncol = 2)

colnames(party_topic_statistics) <- c("Democrat","Republican")
rownames(party_topic_statistics) <- c("Macroeconomics", "Civil Rights", "Health",
                                      "Agriculture", "Labor", "Education",
                                      "Environment", "Energy", "Immigration",
                                      "Transportation")

# At the highest level, we need to loop over topics:
for (i in 1:10) {

    # Now for each topic we loop over parties:
    for (j in 1:2) {

        # Set the variable we are going to lookup against for party ID:
        if (j == 1) {
            party <- 100 # Code for a Democrat sponsored bill
        } else {
            party <- 200 # Code for a Republican sponsored bill
        }

        # Subset our data down to the current party/topic combination:
        current_data <- reduced_data[which(reduced_data$Sponsor_Party == party &
                                           reduced_data$Topic_Code == i),]

        # Check to make sure that there are more than zero observations for the
        # current party/topic combination:
        if (nrow(current_data) > 0) {
            # Now subset to those bills that passed the House:
            passed_house <- current_data[which(current_data$Passed_House == 1),]

            # Find the number of rows in the reduced dataset:
            party_topic_statistics[i,j] <- nrow(passed_house)
        }
    }
}

# Take a look!
party_topic_statistics



