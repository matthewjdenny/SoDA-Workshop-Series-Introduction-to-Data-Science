# Basic Plotting in R
# matthewjdenny@gmail.com

# preliminaries
rm(list = ls())
setwd("~/Desktop")

# packages
# install.packages("ggplot2", dependencies = TRUE)
# # install.packages("scales", dependencies = TRUE)
library(ggplot2)
library(scales)


# we are going to start out by making some fake data to work with:
set.seed(12345)
age <- round(rnorm(n = 1000, mean = 40, sd = 10))
income <- 1200*age + rnorm(n = 1000, mean = 0, sd = 4000)
age_group <- rep("Middle",1000)
age_group[which(age < 25)] <-"Youth"
age_group[which(age > 64)] <-"Senior"
type <- c(rep("A",500),rep("B",500))

# create a data.frame
data <- data.frame(age = age,
                   income = income,
                   age_group = age_group,
                   type = type,
                   stringsAsFactors = FALSE)

# lets start with a simple scatter plot of age against income:
plot(x = data$age,
     y = data$income)


# now lets make it look a bit nicer:
# Check out: https://www.statmethods.net/graphs/index.html
# http://www.endmemo.com/program/R/pchsymbols.php
plot(x = age,
     y = income,
     pch = 3,
     col = "blue",
     xlim = c(0,80),
     ylim = c(0,100000))

# now turn off scientific notation:
options(scipen=999)

plot(x = age,
     y = income,
     pch = 20,
     col = "blue",
     xlim = c(0,80),
     ylim = c(0,100000),
     main = "Age vs. Income",
     xlab = "Subject Age",
     ylab = "Subject Income")


# now lets give a boxplot a try:
boxplot(income~age_group,
        data=data,
        main="Income by Age Group",
        xlab="Age Group",
        ylab="Income",
        col = c("red","blue","green"))

# and a histogram:
hist(data$age,
     breaks = 0:80,
     xlab = "Age",
     main = "Histogram of Subject Age",
     col = "darkblue")


# Now lets do the same thing using ggplot2
p <- ggplot(data = data,
            aes(x = age, y = income))
p + geom_point(size = 2,
               shape = 20,
               col = "darkgreen")

# in ggplot2, we add parameters using the + operator:
p + geom_point(size = 2, shape = 20, col = "darkgreen") +
    xlab("Subject Age") +
    ylab("Subject Income")

# we can also do more complicated things:
p <- ggplot(data = data,aes(x = age,
                            y = income,
                            color = age_group,
                            shape = age_group)) +
    geom_point(size = 2) +
    xlab("Subject Age") +
    ylab("Subject Income") +
    geom_smooth(method = lm)

# These graph opject can be printed using print()
print(p)

# we can also change the y and y axis scales:
ggplot(data = data,aes(x = age, y = income)) +
    geom_point(size = 2, shape = 20, col = "darkgreen") +
    xlab("Subject Age") +
    ylab("Subject Income") +
    scale_y_log10(breaks = c(5000,10000,50000,100000),
                  limits = c(4000,100000),
                  labels = scales::comma) +
    geom_smooth()


# now lets create a boxplot
ggplot(data = data,aes(x = age_group,
                       y = income,
                       color = age_group)) +
    geom_boxplot(outlier.colour = "black",
                 outlier.shape = 8,
                 outlier.size = 4) +
    xlab("Age Group") +
    ylab("Income") +
    theme(legend.title=element_blank())


# and finally, lets create a histogram
ggplot(data=data, aes(age)) +
    geom_histogram(aes(y =..count..),
                   breaks=0:80,
                   col="black",
                   fill="blue",
                   alpha = .3) +
    xlab("Subject Age") +
    ylab("Number of Subjects")

# lets try this with density instead
ggplot(data=data, aes(data$age)) +
    geom_histogram(aes(y =..density..),
                   breaks=0:80,
                   col="black",
                   fill="blue",
                   alpha = .2) +
    xlab("Subject Age") +
    ylab("Number of Subjects") +
    geom_density(col= "orange")


# finally, lets deal with outputting a PDF:
pdf(file = "Example.pdf",
    height = 4,
    width = 6)
ggplot(data=data, aes(data$age)) +
    geom_histogram(aes(y =..density..),
                   breaks=0:80,
                   col="black",
                   fill="blue",
                   alpha = .2) +
    xlab("Subject Age") +
    ylab("Number of Subjects") +
    geom_density(col= "orange")
dev.off()



