# Scraping Twitter
# based on a tutorial available: https://github.com/pablobarbera/streamR

# Before you do anything with this tutorial, make sure you have a Twitter
# account. You will need one to get the proper access to download tweets.



### Letting R access the Twitter API ###

# Lets start by downloading the R packages we will need:
install.packages(c("ROAuth","devtools","ggplot2","maps", "streamR"),
                 repos = "http://cran.r-project.org")

# Alternatively we can get the latest version from Pablo's github:
# devtools::install_github("pablobarbera/streamR/streamR", force = TRUE)

# Before you can scrape Twitter, you will need to follow the directions here:
# https://github.com/SMAPPNYU/smappR#b-creating-your-own-twitter-oauth-token
# to create an authorization token which can be used access the Twitter API.

library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

# You will need to fill in these two as suggested in the directions given at the
# webpage above:
consumerKey <- "XXX"
consumerSecret <- "XXX"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

# Now run this line of code and go to the URL it prints out (it may also just
# take you directly to the webpage).
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem",
                                        package = "RCurl"))

# Now save your credentials for future use!
setwd("~/Dropbox/Credentials/")
save(my_oauth, file = "my_oauth.RData")



### Twitter Scraping Example, Part 1 ###

# Now lets walk through a simple example collecting tweets containing the
# terms "Trump" and "POTUS" in the next sixty seconds. This example follows
# along with: https://github.com/pablobarbera/streamR

# Load the streamR library
library(streamR)

# Load in your access credential we created above
setwd("~/Dropbox/Credentials/")
load("my_oauth.Rdata")

# Now set your working directory to the location where you would like to save
# the tweets you are about to collect:
setwd("~/Desktop")

# Here we are going to use the filter function which uses dome sort of criteria
# for determining which tweets should be saved.
filterStream("tweets.json", # name of file that we want to save tweets to.
             track = c("Trump", "POTUS"), # key terms to collect.
             timeout = 60, # amount of time to collect data in seconds.
             oauth = my_oauth) # your token!

# Load in the tweets from the tweets.json file where they were stored and turn
# them into a data.frame:
tweets.df <- parseTweets("tweets.json",
                         simplify = TRUE)

# We can also just collect a random (approximately 1%) sample of all tweets on
# twitter. I suggest only doing this for a short period of time on your
# computer:

# Capture the tweets:
sampleStream("tweetsSample.json",
             timeout = 30,
             oauth = my_oauth,
             verbose = FALSE)

# Load them into a data.frame and take a look:
tweets.df2 <- parseTweets("tweetsSample.json",
                         verbose = FALSE)



### Twitter Scraping Example, Part 2 ###

# Now we can follow Pablo's example and filter on tweets located in the U.S. and
# overlay them on a map.

# start by filtering the stream on location (lat/long)
filterStream("tweets_USA.json", # the name of the file where we download tweets.
             locations = c(-125, 25, -66, 50), # bottom left, then top right (lat long pairs).
             timeout = 120,
             oauth = my_oauth)

# Parse tweets:
tweets_USA <- parseTweets("tweets_USA.json",
                          verbose = FALSE)

# Load libraries necessary for plotting:
library(ggplot2)
library(maps)

# Get the raster data to plot a map of the U.S.A.:
map.data <- map_data("state")

# Get the points we are going to plot:
tweet_locations <- data.frame(x = as.numeric(tweets_USA$place_lon),
                     y = as.numeric(tweets_USA$place_lat))
tweet_locations <- tweet_locations[tweet_locations$y > 0, ]


# Plot the tweet_locations on the map using ggplot2:
map <- ggplot(map.data)
map <- map + geom_map(aes(map_id = region),
                            map = map.data,
                            fill = "white",
                            color = "grey40",
                            size = 0.25)
map <- map + expand_limits(x = map.data$place_long, y = map.data$place_lat)
map <- map + theme(axis.line = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          panel.grid.major = element_blank(),
          plot.background = element_blank(),
          plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines"))
map <- map + geom_point(data = tweet_locations,
               aes(x = x, y = y),
               size = 1,
               alpha = 1/5,
               color = "darkblue")

print(map)
