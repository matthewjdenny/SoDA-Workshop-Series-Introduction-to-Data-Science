#### Text Processing in R ####

# Let's start with some preliminaries:
rm(list = ls())
setwd("~/Desktop")

# We are going to be using the stringr package for the first part of this
# tutorial:
install.packages("stringr", dependencies = TRUE)
library(stringr)



### Basic Commands for Cleaning Text ###

# Let's start with an example string:
my_string <- "Example STRING, with numbers (12, 15 and also 10.2)?!"
my_string

# One common thing we will want to do with strings is lowercase them:
lower_string <- tolower(my_string)
lower_string

# We can also combine strings using the paste() command:
second_string <- "Wow, two sentences."
my_string <- paste(my_string,second_string,sep = " ")
my_string

# We can also split up strings on a particular character sequence:
my_string_vector <- stringr::str_split(my_string, "!")[[1]]
my_string_vector

# Another useful tool is to be able to find which strings in a vector contain
# a particular character or sequence of characters:
#
# As with many languages this command is called "grep"
#    "Globally search for Regular Expression and Print"
#
# Regular expressions describe a string pattern
#     This could just be a string of characters
grep("two",my_string_vector)

# Some characters have special meanings in regular expressions
#       To search for the question mark "?", you need to "escape" it
grep("\\?",my_string_vector)

# Closely related to the grep() function is the grepl() function, which returns
# a logical for whether a string contains a character or sequence of characters:
grepl("\\?",my_string_vector[1])

# Moving on to manipulating strings, the str_replace_all function can be used to
# replace all instances of a given string, with an alternative string:
stringr::str_replace_all(my_string, "e","___")

# It is also possible to pull out all substrings matching a given string
# argument.
stringr::str_extract_all(my_string, "en")[[1]] # both from "sentences"

# This gets much more useful when you can generalize the patterns
# You will notice here that the "[0-9]+" argument does not look like
# the arguments we have seen so far. It's a "regular expression."
#   The square brackets define a set of possibilities.
#   The "0-9" says the possibilities are any digit from 0 to 9.
#   The "+" means "one or more of the just-named thing"
stringr::str_extract_all(my_string,"[0-9]+")[[1]]

# 0-9 isn't the only range you can look for:
stringr::str_extract_all(my_string,"[a-zA-Z]+")[[1]] #  letters

# Some common classes of characters are predefined.
#   Instead of 0-9, we can just say "\\d" for digits
stringr::str_extract_all(my_string,"\\d+")[[1]]

# Or try:
stringr::str_extract_all(my_string,"\\w+")[[1]] # "word" characters


# Let's start with some example text:
text <- "SEC. 101. FISCAL YEAR 2017.
(a) In General.--There are authorized to be appropriated to NASA
for fiscal year 2017 $19,508,000,000, as follows:
(1) For Exploration, $4,330,000,000.
(2) For Space Operations, $5,023,000,000.
(3) For Science, $5,500,000,000.
(4) For Aeronautics, $640,000,000.
(5) For Space Technology, $686,000,000.
(6) For Education, $115,000,000.
(7) For Safety, Security, and Mission Services,
$2,788,600,000.
(8) For Construction and Environmental Compliance and
Restoration, $388,000,000.
(9) For Inspector General, $37,400,000.
(b) Exception.--In addition to the amounts authorized to be
appropriated for each account under subsection (a), there are
authorized to be appropriated additional funds for each such account,
but only if the authorized amounts for all such accounts are fully
provided for in annual appropriation Acts, consistent with the
discretionary spending limits in section 251(c) of the Balanced Budget
and Emergency Deficit Control Act of 1985."

# Wait ... that's just one variable holding one string? Yep.
text
# All those "\n"s there indicate new lines.

# To go back to the last example in the previous section:
stringr::str_extract_all(text,"[0-9]+")[[1]]
# This line of code will extract all contiguous sequences of numbers of length
# one or greater.

# Let's try to get dollar amounts.
stringr::str_extract_all(text,"\\$[,0-9]+")[[1]] # must start with $
# That says "give me everything that
#     Starts with a "$" (which needs to be escaped: "\\")
#     Followed by one or more commas or digits 0 to 9.

# Almost ... don't like that extra comma on the first number
stringr::str_extract_all(text,"\\$[,0-9]+[0-9]")[[1]]
# That asks for
#     Starts with a "$"
#     Followed by any number of commas and numbers
#     And ends with a number

# One thing we have to note is that there are a number of special characters in
# regular expressions that need to be escaped: These include [ ] { } ( ) " ' $ ^
# & * ? . - + These should all be escaped with a \\ as in \\$ if you want to
# literally match them.

# How about numbers of $1 billion or more
stringr::str_extract_all(text,"\\$[,0-9]{12,}[0-9]")[[1]]
# That asks for
#     Starts with a "$"
#     Followed by 12 OR MORE commas and numbers
#     And ends with a number

# Let's try to get numbers enclosed in parentheses:
stringr::str_extract_all(text,"\\([0-9]\\)")[[1]]

# We can also use "|" to mean "or" in regular expressions:
stringr::str_extract_all(text,"a(nd|re)")[[1]]

# If we only want to match lines that start with a particular set of
# characters ...
# First let's split it into lines:
text_split <- stringr::str_split(text,"\\n")[[1]]
text_split

# Now match on string boundaries where 
#   "^" is the start of a string/line, and 
#    ("$" is the end of a string/line.)
stringr::str_extract_all(text_split,"^\\(.*")

# That returned a list, and we'd probably rather have a vector
# Need to wrap this in an unlist() statement:
unlist(stringr::str_extract_all(text_split,"^\\(.*"))

# Let's try to put everything we've learned together
#   and make a little dataset out of the items (1) to (9)
#   with dollar amounts and what they're for
#
# So, let's see what we have in that last command ..
#    We have some extra lines ... "(a)" and "(b)"
#    And we're missing the $ numbers from items (7) and (8)
#   which are on the next lines.
#
#  So, let's get rid of the newlines:
one_line <- stringr::str_replace_all(text,"\\n"," ")[[1]]
one_line

# and find all the matches from (number) to a period
#      the "?" means be "lazy" -- match as few as possible
#     usually "greedy"
item_strings <- stringr::str_extract_all(one_line,"\\(\\d\\).+?\\.")[[1]]
item_strings

# Can use str_match and parentheses to identify the stuff you want
for_strings <- stringr::str_match(item_strings,"For (.+), \\$")
for_strings
# We want the second column there
for_strings <- for_strings[,2]
for_strings

money_strings <- stringr::str_match(item_strings,"\\$([,\\d]+)")[,2]
money_strings
# Let's get rid of the punctuation
money_strings <- stringr::str_replace_all(money_strings,"[\\$,]","")
money_strings
# Turn them into numbers
money <- as.numeric(money_strings)
money

# Now let's make it data:
appropriations_data <- data.frame(for_strings,money)
appropriations_data


### Tokenizing Text ###

# Function to clean and tokenize a string
Tokenize_String <- function(string){
    # Lowercase
    temp <- tolower(string)
    #' Remove everything that is not a number or letter (may want to keep more
    #' stuff in your actual analyses).
    temp <- stringr::str_replace_all(temp,"[^a-z0-9\\s]", " ")
    # Shrink down to just one white space
    temp <- stringr::str_replace_all(temp,"[\\s]+", " ")
    # Split it
    temp <- stringr::str_split(temp, " ")[[1]]
    # Get rid of trailing "" if necessary
    indices <- which(temp == "")
    if (length(indices) > 0) {
        temp <- temp[-indices]
    }
    return(temp)
}

sentence <- "The term 'data science' (originally used interchangeably with 'datalogy') has existed for over thirty years and was used initially as a substitute for computer science by Peter Naur in 1960."
clean_sentence <- Tokenize_String(sentence)
print(clean_sentence)


## Text Processing with Quanteda ##

# We are going to use the Quanteda R package in this section. First we need to
# install it:
install.packages("quanteda", dependencies = TRUE)
library(quanteda)

# Lets load in some example data:
corp <- quanteda::data_corpus_inaugural

summary(corp)

# Let's look at one document (Washington's first inaugural)
texts(data_corpus_inaugural)[1]

# Let's look at the contexts in which a couple of words have been used
#  kwic = "key words in context"

options(width=120)
kwic(data_corpus_inaugural, "humble", window=4)

kwic(data_corpus_inaugural, "tombstones", window=4)
options(width=80)

# The common goal of most text preprocessing is to generate a document-term
# matrix, where each row represents a document, and each column represents the
# count of a vocabulary term in the current document.
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = TRUE,
                                 stem = FALSE,
                                 remove_punct = TRUE,
                                 remove = stopwords("english"),
                                 ngrams = 1)

# let's take a look at some vocabulary terms:
# What kind of object is doc_term_matrix? 
class(doc_term_matrix)

# How big is it? How sparse is it?
doc_term_matrix

# Let's look inside it a bit:
doc_term_matrix[1:5,1:5]

# What are the most frequent terms?
topfeatures(doc_term_matrix,40)

# Besides "tombstones," what other words were never used in an inaugural before Trump?
unique_to_trump <- as.vector(colSums(doc_term_matrix) == doc_term_matrix["2017-Trump",])
colnames(doc_term_matrix)[unique_to_trump]

# Wordclouds are an abomination, but ...
set.seed(100)
textplot_wordcloud(doc_term_matrix, min.freq = 100, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

set.seed(100)
textplot_wordcloud(doc_term_matrix["2017-Trump",], min.freq = 3, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

# We can also change the settings:
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = FALSE,
                                 stem = TRUE,
                                 remove_punct = FALSE,
                                 remove = stopwords("english"),
                                 ngrams = 1)

# How big is it now? How sparse is it now?
doc_term_matrix

# What are the most frequent terms?
topfeatures(doc_term_matrix,40)

# Or try adding longer n-grams
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = TRUE,
                                 stem = FALSE,
                                 remove_punct = TRUE,
                                 remove = stopwords("english"),
                                 ngrams = 2)

# How big is it now? How sparse is it now?
doc_term_matrix

# What are the most frequent terms?
topfeatures(doc_term_matrix,40)

