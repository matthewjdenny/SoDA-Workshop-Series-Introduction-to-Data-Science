##### Generating Publication Quality Graphics #####

# In this script, I will provide several examples and seek to introduce you to
# the kinds of things one should always do to produce really clean plots for
# publication. I cannot possibly hope to cover every situation, but I always
# find myself doing the same sorts of things whenever I make plots for
# publication. This is really where R shines. We will be using the base R
# graphics and ggplot2. The takeaway point here is that I am providing you with
# working example graphs you can tweak and steal code from to try with your own
# data. This is how I got my start plotting, so I hope you find this helpful as
# well!

# Start by installing ggplot2 and gridExtra:
install.packages("ggplot2", dependencies = TRUE)
install.packages("gridExtra", dependencies = TRUE)

# Preliminaries:
rm(list = ls())
library(ggplot2)
library(gridExtra)

# set your working directory (for me, this looks like):
setwd("~/Desktop")
# Lets load in some "data" we will use in this tutorial:
load("LaCour_Data.Rdata")
load("Influence_Data.Rdata")
load("Influence_Data_2.Rdata")


# Here, I am going to go over an example plot, then see how we can improve on
# it. Note that the code I will use below is taken directly from:
# https://stanford.edu/~dbroock/broockman_kalla_aronow_lg_irregularities.pdf
# page 5. This is an interesting paper in and of itself, as the data we are
# using were for a paper that was publsihed in Science, but are acutally fake.

# Start by subsetting the data:
lacour.therm.study1 <- subset(LaCour_Data,
                              wave == 1 & STUDY == "Study 1")$Therm_Level

# Then look at it using a histogram:
hist(lacour.therm.study1,
     breaks = 101,
     xlab = "Feeling Thermometer",
     main = "LaCour (2014) Study 1, Baseline")

# What can we improve?

# One thing we could do would be to color the bars. However the base colors in R
# are not always the prettiest, fortunately, we can create our own! I did this
# using the color palette available on this website:
# https://www.umass.edu/brand/elements/color
# and I use these colors in all of my plots that allow color. To define a color
# we will use the rgb() function. We can see how this works by typing the
# following into our console:
?rgb()

# To convert hex to rgb we can use: http://hex.colorrrs.com/

# Now lets give it a try:
UMASS_BLUE <- rgb(51,51,153,195,maxColorValue = 255)
UMASS_RED <- rgb(153,0,51,195,maxColorValue = 255)
UMASS_GREEN <- rgb(0,102,102,195,maxColorValue = 255)
UMASS_YELLOW <- rgb(255,255,102,255,maxColorValue = 255)
UMASS_ORANGE <- rgb(255,204,51,195,maxColorValue = 255)
UMASS_PURPLE <- rgb(65,39,59,195,maxColorValue = 255)
UMASS_BROWN <- rgb(148,121,93,195,maxColorValue = 255)

# Lets try to fill in some additional parameters. We can start to do this by
# looking at the documentation for 'hist()' by typing in:
?hist()

# Now give a couple of additional arguments a try:
hist(lacour.therm.study1,
     breaks = 101,
     ylab = "Number of Respondents",
     xlab = "Feeling Thermometer",
     main = "LaCour (2014) Study 1, Baseline",
     col = UMASS_BLUE,
     ylim = c(0,2000))

# My preferred way of exporting plots for inclusion in a LaTeX document is as a
# pdf. We can do this as follows:
pdf(file = "Example_Histogram.pdf",
    height = 4, # in inches
    width = 8) # in inches
hist(lacour.therm.study1,
     breaks = 101,
     ylab = "Number of Respondents",
     xlab = "Feeling Thermometer",
     main = "LaCour (2014) Study 1, Baseline",
     col = UMASS_ORANGE,
     ylim = c(0,2000))
dev.off() # ends the plot

# The key here is to get the dimensions correct. Often you will just need to
# play around with them for a while and examine the output.

# Lets try another example from a paper I wrote:
# https://ssrn.com/abstract=2465309

# First, lets try a plot of the number of successful floor amendments
# sponsored by each U.S. Senate committee leader (chair or ranking member) in
# each of 12 sessions of Congress (demeaned within session of Congress). We are
# going to use the "data" data.frame for this part:
plot(x = data$Congress,
     y = data$Floor_Amendments)

# From this plot, it would be very hard to detect any sort of trend in these
# data. Moreover, we might want to compare the trend in these data to other
# related measures of the importance of committee leaders. A standard plot one
# sees in many social science journals is a panel of scatter plots next to
# each other. These scatter plots often also include a trendine, with confidence
# bounds. We can make one of these multipanel plots with the following bit of
# R code. It is not super important that you actually understand what these
# plots mean, but more that you understand how the R code that generates them
# works:

# Here we are going to use 'ggplot()' for the first time. We will be building up
# a plot one element at a time and saving it to the object 'g1'. We will then
# combine several of these objects and plot them side by side. Lets give it a
# try:
g1 <- ggplot(data , # the name of the data.frame we are using
             aes(x = Congress, # name of x variable column
                 y = Floor_Amendments)) + # name of Y variable column
    geom_point() + # includes a point on the plot for each (x,y) observation
    stat_smooth(method = lm) + # includes a regression line with 95% confidence
    # bounds.
    ylab("Successful Floor Amendments") + # the y label for the graph
    xlab("Session of Congress") + # the x label for the graph
    scale_x_continuous(name = "Session of Congress",
                       breaks = 1:12, # where to put x-axis tick marks
                       minor_breaks = waiver(), # no minor tick marks
                       labels = 97:108) # custom labels

# Now we make similar plots (with a different y value) for two other measures:
g2 <- ggplot(data , aes(x = Congress, y = Connectedness)) +
    geom_point() + stat_smooth(method = lm) +
    ylab("Connectedness") +
    xlab("Session of Congress") +
    scale_x_continuous(name = "Session of Congress",
                       breaks = 1:12,
                       minor_breaks = waiver(),
                       labels = 97:108)

g3 <- ggplot(data , aes(x = Congress, y = Influence)) +
    geom_point() + stat_smooth(method = lm) +
    ylab("Influence") +
    xlab("Session of Congress") +
    scale_x_continuous(name = "Session of Congress",
                       breaks = 1:12,
                       minor_breaks = waiver(),
                       labels = 97:108)

# Finally, we can generate the plot and save it to a .pdf:
pdf("Example_Multiple_Plot.pdf",
    width = 12,
    height = 4)

# You can check out '?grid.arrange()' for how this works. We need to use this
# function to arrange ggplot objects as opposed to 'par()' in base R graphics:
grid.arrange(g1, g2, g3, ncol = 3)
dev.off()


# Now lets try a more complicated example where we run a regression for each
# session of Congress then plot the resulting parameter estimates together.

# We are going to work through sessions of congress starting with the 97th. We
# do this first iteration by itself and then complete using a loop.
i <- 97

# Subset the data to observations relevant to the current session of Congress:
cur_data <- data2[which(data2$Congress == i),]

# Fit a linear model:
fit <- lm(formula = "Connectedness ~ Seniority + NOMINATE + NOMINATE_SQ +  In_Majority + Committee_Chair",
          data = cur_data )

# We can look at the output of this model using the 'summary()' function:
summary(fit)

# Create a "session of Congress" variable, which we will add on to the
# data.frame we create to store our regression coefficients:
Session <- rep(i,5)

# Column bind "Session" together with the regression coefficients:
Session_Regression_Coefficients <- cbind(summary(fit)$coefficients[2:6,],
                                         Session)

# Take a look:
print(Session_Regression_Coefficients)

# now we loop over the remaining sessions of Congress.
for (i in 98:108) {
    # Let the user know what iteration we are on
    cat("Currently working on session:",i,"\n")

    # Subset the data to the current session:
    cur_data <- data2[which(data2$Congress == i),]

    # Fit a linear model:
    fit <- lm(formula = "Connectedness ~ Seniority + NOMINATE + NOMINATE_SQ +  In_Majority + Committee_Chair",
              data = cur_data )

    # Add in session variable:
    Session <- rep(i,5)

    # Create the data frame we will add on to the existing
    # Session_Regression_Coefficients data.frame
    addition <- cbind(summary(fit)$coefficients[2:6,],
                      Session)

    # Add on our addition using 'rbind()':
    Session_Regression_Coefficients  <- rbind(Session_Regression_Coefficients ,
                                              addition)
}

# Now, get the row names of "Session_Regression_Coefficients" and use these as
# labels:
Variable <- rownames(Session_Regression_Coefficients)

# Create a data.frame with "Variable" included:
Session_Regression_Coefficients <- data.frame(Session_Regression_Coefficients,
                                              Variable,
                                              stringsAsFactors = F)

# Create confidence interval z-values:
interval1 <- -qnorm((1-0.9)/2)  # 90% multiplier
interval2 <- -qnorm((1-0.95)/2)  # 95% multiplier

# Now it is time to make the plot:
pdf(file = "Connectedness_Regression_Coefficients.pdf",
    width = 18,
    height = 4)
# Plot coefficients faceted by Variable type. This automatically makes a
# different plot for each unique value of the facetting variable:
ggplot(Session_Regression_Coefficients,
       aes(x = Session,
           y = Estimate))  +
    facet_grid(. ~ Variable,
               scales = "free") +
    geom_point(shape = 19,
               color = UMASS_BLUE) + # add in blue points for estimates
    geom_hline(yintercept = 0,
               colour = gray(1/2),
               lty = 2) + # create an intercept line
    geom_linerange(aes(x = Session,
                       ymin = Estimate - Std..Error*interval2,
                       ymax = Estimate + Std..Error*interval2)) + # create 95%
    # Confidence interval bars around our point estimates.
    ylab("Parameter Estimate") +
    xlab("Session of Congress")
dev.off()
