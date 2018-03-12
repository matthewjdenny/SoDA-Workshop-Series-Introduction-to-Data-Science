### Example: Web Scraping Congressional Bills ###


rm(list = ls())
# load the necessary libararies
# install.packages("httr", dependencies = TRUE)
library(stringr)
library(httr)

# Set your working directory. For me, this looks like:
setwd("~/Desktop")

# Load in the bill urls -- you may need to set your working directory or alter
# the path below
load("Workshop_16-Bill_URLs.RData")



#' Start by correcting the bill URLs:
bill_urls_fixed <- rep("",100)
for (i in 1:100) {
    bill_urls_fixed[i] <- stringr::str_replace(Bill_URLs[i],"http://beta","https://www")
    bill_urls_fixed[i] <- paste(bill_urls_fixed[i],"/text?format=txt",sep = "" )
}


# Define function to scrape page:
scrape_page <- function(url){

    # Print out the input name:
    cat(url, "\n")

    # Make the input name all lowercase:
    url <- tolower(url)

    # Downloads the web page source code:
    page <- httr::GET(url)
    page <- httr::content(page, "text")

    # Split on newlines:
    page <- str_split(page,'\n')[[1]]

    # Start of bill text:
    start <- grep("112th CONGRESS",page)[1]

    # End of bill text:
    end <- grep("&lt;all&gt;",page)

    # This is a way of ensuring that we actually found a beginning and end of the
    # text. If we did not (because these webpages are messy), then we want to only
    # return "", an empty string:
    if (length(end) > 0 & length(start) > 0) {
        # Get just the text:
        cat("Line where text starts:",start,"\n")
        cat("Line where text ends:",end,"\n")
        # check to see if either start or end is NA, and if so return "":
        if (!is.na(start) & !is.na(end)) {
            # Check to make sure that start is less than end, and that they are
            # both greater than zero:
            if (start < end & start > 0 & end > 0) {
                # Extract out the lines of bill text:
                bill_text <- page[start:(end - 1)]
            } else {
                bill_text <- ""
            }
        } else {
            bill_text <- ""
        }
    } else {
        bill_text <- ""
    }

    # Save to a named list object:
    to_return <- list(page = page, text = bill_text)

    # return the list:
    return(to_return)
}

#' Scrape the data:
bill_data <- vector(mode = "list",length = 100)
for (i in 1:100) {
    cat("Currently scraping bill:",i,"of",100,"\n")
    # Make sure to sleep between iterations
    Sys.sleep(round(runif(n = 1, min = 3, max = 9)))
    # Scrape the data and store it in a list:
    bill_data[[i]] <- scrape_page( url = bill_urls_fixed[i])
}

#' Saving everything in an .RData object can be good practice to make sure you
#' do not lose your work:
save(bill_data, file = "Scraped_Data.RData")

# Define the function clean an individual string:
Clean_String <- function(string) {
    # Lowercase:
    temp <- tolower(string)
    # Remove everything that is not a number or letter:
    temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ")
    # Shrink down to just one white space:
    temp <- stringr::str_replace_all(temp,"[\\s]+", " ")
    # Split it:
    temp <- stringr::str_split(temp, " ")[[1]]
    # Get rid of trailing "" if necessary:
    indexes <- which(temp == "")
    if (length(indexes) > 0) {
        temp <- temp[-indexes]
    }
    return(temp)
}

#' Define our function clean an entire block of text:
Clean_Text_Block <- function(text){
    # Check to make sure that the text is of al teast length 1:
    if (length(text) > 0) {
        # Get rid of blank lines:
        indexes <- which(text == "")
        if (length(indexes) > 0) {
            text <- text[-indexes]
        }

        # this could now result in text with nothing left, so we again check
        # its length:
        if (length(text) > 0) {
            # Loop through the lines in the text and use the c() function to
            clean_text <- NULL # Initialize to NULL, then when you append onto this
            # object the first entry disappears. Try it!
            for (i in 1:length(text)) {
                # Add them to a growing vector:
                clean_text <- c(clean_text, Clean_String(text[i]))
            }

            # Now determine the total number of tokens:
            num_tok <- length(clean_text)

            # And the number of unique tokens:
            num_uniq <- length(unique(clean_text))

            # finally store everything in a list object:
            to_return <- list(num_tokens = num_tok,
                              unique_tokens = num_uniq,
                              text = clean_text)
        } else {
            # If there was no text, then tell the user:
            cat("There was no text in this bill! \n")
            to_return <- list(num_tokens = 0,
                              unique_tokens = 0,
                              text = "")
        }
    } else {
        # If there was no text, then tell the user:
        cat("There was no text in this bill! \n")
        to_return <- list(num_tokens = 0,
                          unique_tokens = 0,
                          text = "")
    }

    return(to_return)
}

# Loop over the text of all bills and clean each bill:
clean_bill_text <- vector(mode = "list",length = 100)
for (i in 1:100) {
    cat("Currently cleaning bill:",i,"of",100,"\n")
    clean_bill_text[[i]] <- Clean_Text_Block(bill_data[[i]]$text)
}


# Now we can calculate the total_token_count and the total_unique_words:
total_token_count <- 0
all_tokens <- NULL
for (i in 1:100) {
    cat("Currently working on bill:",i,"of",100,"\n")
    # Keep appending the tokens to a giant vector:
    all_tokens <- c(all_tokens, clean_bill_text[[i]]$text)
    total_token_count <- total_token_count + clean_bill_text[[i]]$num_tokens
}

# Finally we get the number of unique words:
unique_words <- unique(all_tokens)
total_unique_words <- length(unique_words)
cat("There were a total of",total_token_count,"tokens used in all documents and the number of unique words is:",total_unique_words," \n" )

# Check your work:
total_unique_words == 6708
total_token_count == 221442
