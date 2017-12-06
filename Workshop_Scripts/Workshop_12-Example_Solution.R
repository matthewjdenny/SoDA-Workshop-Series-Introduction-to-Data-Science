#### Homework 1: Solution ####


# Set your working directory to the "Data" folder associated with this
# assignment:
setwd("~/Desktop")

# Load in the data we will be using:
load("Workshop_12-Synthetic_Tweets.RData")



### Exercise 1 ###

# Variable to store tweet count:
POTUS_Tweets_Count <- 0

# Loop over all tweets
for (i in 1:nrow(synthetic_tweets)) {
    # If "POTUS: is contained in the text field for the current tweet:
    if (grepl("POTUS", synthetic_tweets$text[i], ignore.case = TRUE)) {
        POTUS_Tweets_Count <- POTUS_Tweets_Count + 1
    }
}

# Make a nice little 'cat()' statment to tell ourselves the answer:
cat(POTUS_Tweets_Count,"out of",nrow(synthetic_tweets),
    "tweets contain the term POTUS.\n")

# You should get:
POTUS_Tweets_Count == 221


### Exercise 2 ###

# Variable to store tweet count:
Trump_Comey_Tweets_Count <- 0

# Loop over all tweets
for (i in 1:nrow(synthetic_tweets)) {
    # If "Trump" is contained in the text field for the current tweet:
    if (grepl("Trump", synthetic_tweets$text[i], ignore.case = TRUE)) {
        if (grepl("Comey", synthetic_tweets$text[i], ignore.case = TRUE)) {
            Trump_Comey_Tweets_Count <- Trump_Comey_Tweets_Count + 1
        }
    }
}

# Make a nice little 'cat()' statment to tell ourselves the answer:
cat(Trump_Comey_Tweets_Count,"out of",nrow(synthetic_tweets),
    "tweets contain the term POTUS.\n")

# You should get:
Trump_Comey_Tweets_Count == 567


### Exercise 3 ###

# Define our function:
find_users <- function(statuses,
                       followers,
                       favourites,
                       tweet_data) {
    # Initialize variable to store users
    users <- NULL

    # Loop over tweets
    for (i in 1:nrow(tweet_data)) {
        # If statement (combining multiple conditions):
        if (tweet_data$statuses_count[i] == statuses &
            tweet_data$followers_count[i] == followers &
            tweet_data$favourites_count[i] == favourites) {

            # Add this user to the list:
            users <- c(users, tweet_data$screen_name[i])
        }
    }

    # Get the unique users:
    users <- unique(users)

    # Return our answer:
    return(users)
}

# Run our function:
user <- find_users(statuses = 62585,
                   followers = 287180,
                   favourites = 173,
                   tweet_data = synthetic_tweets)

# Check our answer:
user == "@USER_5246"




### Exercise 4 ###

# First, I am going to illustrate this with a function using only 'for()' loops
# and 'if()' statements:
get_average_followers <- function(key_term,
                                  tweets) {
    # Hold the usernames associated with the tweets containing the key term
    users <- NULL

    # First we find all tweets that contain the term:
    for (i in 1:nrow(tweets)) {
        if (grepl(key_term, tweets$text[i], ignore.case = TRUE)) {
            users <- c(users,tweets$screen_name[i])
        }
    }

    # Get the unique users
    users <- unique(users)

    # Now go through and find the first time that user pops up in the dataset.
    # Then record the number of followers. Do this for each unique user:
    followers <- rep(0, length(users))

    # Loop over each unique user:
    for (i in 1:length(users)) {
        # Use the 'which()' function to find the first tweet by that user
        index <- which(tweets$screen_name == users[i])[1] # add the [1] to get
        # the first row index that matches the condition.

        followers[i] <- tweets$followers_count[index]
    }

    # Now return the desired values:
    to_return <- c(length(users),
                   mean(followers))

    return(to_return)
}

# Lets try it out:
results <- get_average_followers("fake news",
                                 synthetic_tweets)

# Check our work
results[1] == 55 # number of unique users
round(results[2],3) == 3895.436 # average number of followers (rounded to 3
# significant digits)





