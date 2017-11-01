#### Text Processing in R ####

# Lets start with some preliminaries:
rm(list = ls())
setwd("~/Desktop")

# We are going to be using the stringr package for the first part of this
# tutorial:
install.packages("stringr", dependencies = TRUE)
library(stringr)



### Basic Commands for Cleaning Text ###

# Lets start with an example string:
my_string <- "Example STRING, with numbers (12, 15 and also 10.2)?!"

# One common thing we will want to do with strings is lowercase them:
lower_string <- tolower(my_string)

# We can also combine strings using the paste() command:
second_string <- "Wow, two sentences."
my_string <- paste(my_string,second_string,sep = " ")

# We can also split up strings on a particular character sequence:
my_string_vector <- stringr::str_split(my_string, "!")[[1]]

# Another useful tool is to be able to find which strings in a vector contain
# a particular character or sequence of characters:
grep("\\?",my_string_vector)

# Closely related to the grep() function is the grepl() function, which returns
# a logical for whether a string contains a character or sequence of characters:
grepl("\\?",my_string_vector[1])

# Moving on to manipulating strings, the str_replace_all function can be used to
# replace all instances of a given string, with an alternative string:
stringr::str_replace_all(my_string, "e","___")

# It is also possible to pull out all substrings matiching a given string
# argument. You will notice here that the "[0-9]+" argument does not look like
# the arguments we have seen so far. That is because it is a regular expression,
# something we will cover below:
stringr::str_extract_all(my_string,"[0-9]+")[[1]]



### Basics of Regular Expressions ###

# There is far more to know abotu regular expressions than I could hope to cover
# in this lecture. I am only going to give you a taste for these incredibly
# powerful tools, you will have to learn more abotu them yourself:

# Lets start with some example text:

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

# To go back to the last example in the previous section:
stringr::str_extract_all(text,"[0-9]+")[[1]]
# This line of code will extract all contiguous sequences of numbers of length
# one or greater.

# Lets try to get dollar amounts.
stringr::str_extract_all(text,"[\\$,0-9]+")[[1]]

# One thing we have to note is that there are a number of special characters in
# regular expressions that need to be escaped: Thes include [ ] { } ( ) " ' $ ^
# & * ? . - + These should all be escaped with a \\ as in \\$ if you want to
# literally match them.

# But what if we only want strings of length two or greater?
stringr::str_extract_all(text,"[\\$,0-9]{2,}")[[1]]

# We can also do this with text:
stringr::str_extract_all(text,"[a-zA-Z]+")[[1]]

# Lets try to get numbers enclosed in parentheses:
stringr::str_extract_all(text,"\\([0-9]\\)")[[1]]

# We can also use conditionals in regular expressions:
stringr::str_extract_all(text,"a(nd|re)")[[1]]

# If we only want to match strings that start with a particular set of
# characters:
text_split <- stringr::str_split(text,"\\n")[[1]]

# Now math on string boundaries where ^ is the start of a string/line, and $
# is the end of a string/line.
stringr::str_extract_all(text_split,"^\\(.*")

# Need to wrap this in an unlist() statement if we want a character vector:
unlist(stringr::str_extract_all(text_split,"^\\(.*"))



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

# The common goal of most text preprocessing is to generate a document-term
# matrix, where each row represents a document, and each column represents  the
# count of a vocabulary term in the current document.
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = TRUE,
                                 stem = FALSE,
                                 remove_punct = TRUE,
                                 remove = stopwords("english"),
                                 ngrams = 1)

# lets take a look at some vocabulary terms:
colnames(doc_term_matrix)[1:100]
ncol(doc_term_matrix)

# We can also change the settings:
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = FALSE,
                                 stem = TRUE,
                                 remove_punct = FALSE,
                                 remove = stopwords("english"),
                                 ngrams = 1)

colnames(doc_term_matrix)[1:100]
ncol(doc_term_matrix)

# Or try adding longer n-grams
doc_term_matrix <- quanteda::dfm(corp,
                                 tolower = TRUE,
                                 stem = FALSE,
                                 remove_punct = TRUE,
                                 ngrams = 1)

colnames(doc_term_matrix)[1:100]
ncol(doc_term_matrix)

