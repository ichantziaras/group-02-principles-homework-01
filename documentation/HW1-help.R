#help file
##########

# reading in the data
setwd("h:/") #change the filepath if necessary!
filename <- "all.logs.train1.csv" #change the filename to your file
data <- read.csv(filename, header = TRUE)
str(data) #notice how all variables are coded as factors

# example converting a factor vector to a character vector
data$origin <- as.character(data$origin)
sum(is.na(data$origin)) #check for misread or missing data
table(data$origin == "") # check for missing values in case these are not automatically coded as NA

# time variables

# first, we need convert from factor to a date / time format
data$date <- as.Date(data$date, format = "%d%b%Y")
data$time <- as.POSIXlt(data$time, format = "%I:%M:%S %p")
?as.POSIXlt
head(data$time)
# Note that the date isn't correct now (all days seem to be today)
# So, you'll have to find a way to replace the date part from data$time with the information contained in data$date
# One way to do this is to cut part of the character string from data$time containing only the time
?substr
# This can then be pasted to data$date
?paste
# Note now that you're left with a character vector! In order to convert this back to time class / format, again use as.POSIXtl
# You'll have to change the 'format' argument accordingly!
# Now you should end up with a very convenient time variable!

# to extract useful information or recode this time variable, please consult the website below:
# http://en.wikibooks.org/wiki/R_Programming/Times_and_Dates
