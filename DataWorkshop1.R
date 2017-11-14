# INSTALLING PACKAGES
#   Extends functionality of R
#   Adds additional functions, data structures, etc. 
#   Only have to run these commands once then 
#   the packages are stored forever on your computer
install.packages("data.table") # Additional data structure
install.packages("curl") # Downloads data from online
install.packages("foreign") # Additional downloading support

# LOADING PACAKGES 
#   Must be done each time you open an R session
#   Essentially pulls packages from your computer's memory
#   so you can use them
library(data.table)
library(curl)
library(foreign)

# A function is a 

# BASIC OPERATIONS AND VECTORS
#   R is "vectorized"
#   Most data structures are built from vectors
#   Most functions operate on every element of 
#   vector(s) simultaneously (We avoid for-loops)
#   c(...) combines elements into vectors
v <- c(1,0,1,2,3,4)
w <- c(1,1,2,3,4,4)

# A vector can only contain 1 kind of data 
numeric <- c(10, 20, 100) # numeric
character <- c("use", "quotes") # character
boolean <- c(TRUE, FALSE, FALSE) # boolean


# Basic Arithmetic Operations occur element-wise
v + w 
v * w
v / w
v ^ 2

# Logical operations occur element wise as well
v == w # Elementwise equality
v != w # Inequality
v <= w # Less than
v >= w # Greater than
v == 4 | w == 4 # OR operator 
v == 4 & w == 4 # And Operator 

# SUBSETTING VECTORS 
#  Index Subsetting 
#   Refer to elements of vector by their 
#   position in the vector (starting at 1)
v[3]
v[2:4]
v[c(1,3,5)]

#  Logical Subsetting
#   Extract elements where some logical 
#   statement is true e.g values > 2
v > 2 
v[v > 2]
v[v != 1]

#  Naming vectors 
#   Sometimes we want to associate each
#   element of a vector with a name
names(v) <- c("Nile", "Steph", "PPI", "Prakash", "Hadley", "Wickam")

#   Now we can index the vector by element name as well
v[c("Nile", "Wickam")]

# IMPORTING DATA
  # We can download data directly from the internet into R
  # getURL is a function which makes https websites accessible
  # (R can't normally download files directly from https)
fertility.data <- getURL('https://raw.githubusercontent.com/bpiv400/PPISGDataSet/master/fertility1.txt')
fertility.data <- read.csv(text = fertility.data)
 
# Manipulating and Viewing Data
  # By default, R loads tables as data.frame objects 
  # These are similar to what you would think of as a table, 
  # But they're inefficient and difficult to work with, so 
  # we convert them to a bettr data structure -- data.table
class(fertility.data)
fertility.data <- setDT(fertility.data)
class(fertility.data)

# Quick and dirty ways to learn about your data
head(fertility.data) # Look at the first few entries
tail(fertility.data) # Look at the last few entries
View(fertility.data) # View the entire data.table in a separate pane
summary(fertility.data) # Output summary statistics 

ncol(fertility.data) # Number of columns 
colnames(fertility.data) # Column Names
nrow(fertility.data) 
rownames(fertility.data)

education <- fertility.data$educ #Grab a column and save it as a vector
education <- fertility.data[["educ"]] # Same
hist(education) # Makes a histogram (we'll learn more about visualizations later

# Subsetting by row and column
#   Data.table provides intuitive syntax for subsetting, 
#   very similar to vector subsetting
#   data.table[i, j] (First index does rows, second does columns)
#   May leave either blank
fertility.data[15:20, ]
fertility.data[ , 1:12]
fertility.data[15:20, 1:12]

# Logical subsetting and subsetting by name work too
fertility.data[black == 1, ]
fertility.data[black == 1, year] # Don't need to use quotes
fertility.data[black == 1, c("black", "age")] # unless you're grabbing multiple columns
# Put a negative sign in front to remove multiple columns at once
fertility.data[age > 24, -c("year", "educ", "meduc")]

# Thus far we have made temporary changes to fertility.data. If we want to permanently 
# remove a column:
fertility.data[ , educ := NULL] # := is the assignment operator
# We can use it to make new features too
fertility.data[, educ2 := educ ^ 2]

# We can also sort by values in rows
fertility.data[order(educ), ] # Ascending
fertility.data[order(-educ), ] # Descending
fertility.data[order(-educ, -age), ] # Sorts by the first, then the second when the first has equal values

# Calculate functions over groups (e.g. mean age by education group) 
fertility.data[, .(avg_age = mean(age)), by = educ] 
fertility.data[, .(avg_age = mean(age)), by = .(educ, black)] 
# The period before the parentheses tells R to look for the end of the 
# parentheses before evaluating that chunk


# Not very useful output, but we can sort it
fertility.data[, .(avg_age = mean(age)), keyby = .(educ, black)]
# General Syntax: 
# data.table[i, j, by] 
# i gives rows to subset
# j gives something to be calculated (a function, column, or set of columns), 
# by gives group over which calculation should be performed

## Visualization basics 
# plot(x, y, ...) allows you to create basic plots, Arguments:
# x: vector of x coordinates
# y: vector of y coordinates
# type: p (point), l (line), b (both), h (histogram), 
# main: title of the plot
# xlab, ylab: x and y labels
plot(x = fertility.data$age, y = fertility.data$kids)

plot(x = fertility.data$age, y = fertility.data$kids, type = "p", 
main = "Scatterplot of Age versus Number of Kids", 
xlab = "Mother Age", ylab = "Number of Kids", pch = 20)
# Many other graphical parameters and other packages 
# exist to customize your charts which we'll introduce next time

# Other plots: 
 # hist(data) : histogram 
 # boxplot(y ~ group, data)

# Adds a line to the plot
abline(a = 3, b = .05)

# Linear regression (Linear model)
# lm(y ~ x1 + x2 + x3, data, ...)
# output saved as a "linear model object"
kids.lm <- lm(kids ~ age, data = fertility.data)
abline(kids.lm)

# the output has lots of interesting properties
summary(kids.lm)
plot(residuals.lm(kids.lm), pch = 20)

# Questions? We'll move to independent excercises now! 

# clean our environment
rm(list = ls())
# Download the dataset found here
url <- "https://raw.githubusercontent.com/bpiv400/PPISGDataSet/master/CPS85.txt"

# 1. Load the dataset and store it as a data.table. What variables do you have?
# 2. Plot a histogram of age (explore the graphical parameter arguments if 
# you want to make it pretty)
# 3. Plot a boxplot of logwage grouped by union. What do these plots represent?
# What would you conclude?
# 4. Calculate rate of marriage for nonwhite and white (use by) 
# 5. Calculate mean experience for southerner's (use row and column subsetting)
# 6. Plot a scatterplot of logwage versus exper for people older than 25
# 7. Regress wage on experience and plot the line of best fit over your scatterplot