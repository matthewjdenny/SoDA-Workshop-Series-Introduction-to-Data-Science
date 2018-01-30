###### Introduction to Web Scraping #####

# Preliminaries
rm(list = ls())
# Set your working directory to some place you can find
setwd("~/Desktop")

# First we will need to install the packages we plan to use for this exercise (
# if they are not already installed on your computer).
# install.packages("httr", dependencies = TRUE)
# install.packages("stringr", dependencies = TRUE)

# httr is a package for downloading html
library(httr)
# A package for manipulating strings
library(stringr)

# Lets start by downloading an example web page:
url <- "http://www.mjdenny.com/Rcpp_Intro.html"

# We start by using the httr package to download the source html
page <- httr::GET(url)

# As we can see, this produces a great deal of information
str(page)

# To get at the actual content of the page, we use the content() function:
page_content <- httr::content(page, "text")

# Now lets print it out
cat(page_content)

# and write it to a file for easier viewing
write.table(x = page_content,
            col.names = FALSE,
            row.names = FALSE,
            quote = FALSE,
            file = "Example_1.html")

# lets try a more complicated example page for a peice of legislation in the
# U.S. Congress
url <- "https://www.congress.gov/bill/103rd-congress/senate-bill/486/text"

# we start by using the httr package to download the source html
page <- httr::GET(url)

# as we can see, this produces a great deal of information
str(page)

# to get at the actaul content of the page, we use the content() function
page_content <- httr::content(page, "text")

# now lets print it out
cat(page_content)

# and write it to a file for easier viewing
write.table(x = page_content,
            col.names = FALSE,
            row.names = FALSE,
            quote = FALSE,
            file = "Example_2.html")



### Web Scraping Example, Part 1 ###

url <- "https://scholar.google.com/scholar?hl=en&q=https://scholar.google.com/scholar?hl=en&q=laurel+smith-doerr"

# we start by using the httr package to download the source html
page <- httr::GET(url)

# as we can see, this produces a great deal of information
str(page)

# to get at the actaul content of the page, we use the content() function
page_content <- httr::content(page, "text")

# now lets print it out
cat(page_content)

# and write it to a file for easier viewing
write.table(x = page_content,
            col.names = FALSE,
            row.names = FALSE,
            quote = FALSE,
            file = "Example_3.html")

# now lets think about what we might like to extract from this page?

# lets look inside the function
string <- "Laurel Smith-Doerr"
return_source <- FALSE

# Write a function to go get the number of results that pop up for a given name
# in google scholar.
get_google_scholar_results <- function(string,
                                       return_source = FALSE){

    # print out the input name
    cat(string, "\n")

    # make the input name all lowercase
    string <- tolower(string)

    # split the string on spaces
    str <- stringr::str_split(string," ")[[1]]

    # combine the resulting parts of the string with + signs so "Matt Denny"
    # will end up as "matt+denny" which is what Google Scholar wants as input
    str <- paste0(str,collapse = "+")

    # add the name (which is now in the correct format) to the search querry and
    # we have our web address.
    str <- paste("https://scholar.google.com/scholar?hl=en&q=",str,sep = "")

    # downloads the web page source code
    page <- httr::GET(str)
    page <- httr::content(page, "text")

    ### Web Scraping Example, Part 2 ###



    # search for the 'Scholar</a><div id="gs_ab_md">' string which occurs
    # uniquely right before google Scholar tells you how many results your
    # querry returned
    num_results <- str_split(page,'<div id=\\"gs_ab_md\\"><div class=\\"gs_ab_mdw\\">')[[1]][2]

    # split the resulting string on the fist time you see a "(" as this will
    # signify the end of the text string telling you how many results were
    # returned.
    num_results <- str_split(num_results,'\\(')[[1]][1]

    # Print out the number of results returned by Google Scholar
    cat("Querry returned", tolower(num_results), "\n")

    # Look to see if the "User profiles" string is present -- grepl will return
    # true if the specified text ("User profiles") is contained in the web page
    # source.
    if (grepl("User profiles",page)) {

        # split the web page source (which is all one string) on the "Cited by "
        # string and then take the second chunk of the resulting vector of
        # substrings (so we can get at the number right after the first mention
        # of "Cited by ")
        num_cites <- str_split(page,"Cited by ")[[1]][2]

        # now we want the number before the < symbol in the resulting string
        # (which will be the number of cites)
        num_cites <- str_split(num_cites,"<")[[1]][1]

        # now let the user know how many we found
        cat("Number of Cites:",num_cites,"\n")
    } else {
        # If we could not find the "User profiles" string, then the person
        # probably does not have a profile on Google Scholar and we should let
        # the user know this is the case
        cat("This user may not have a Google Scholar profile \n")
    }

    # If we specified the option at the top that we wanted to return the HTML
    # source, then return it, otherwise don't.
    if (return_source) {
        return(page)
    }
}

#now lets have some fun...
get_google_scholar_results("Joya Misra")

get_google_scholar_results("Laurel Smith-Doerr")

get_google_scholar_results("Nilanjana Dasgupta")

page_source <- get_google_scholar_results("Gary Becker",return_source = TRUE)
