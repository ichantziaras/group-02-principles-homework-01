load('munged/requests.RData')
load('munged/pageviews.RData')

# not all requests are for pages, most are for assets (images, scripts, stylesheets etc.)
requests_per_page <- nrow(pageviews) / nrow(requests)

# top 5 pages
top5 <- head(sort(table(pageviews$for_path), decreasing = TRUE))

# documents downloaded
table(subset(requests, for_document)$for_extension)

# Plot the number of observations per month
plot(factor((requests$human_date_time$mon), labels=c("June","July", "August")), main="Number Downloads per Month")

# Plot the number of observations per day for JUNE
# TODO: labels should start on SUNDAY
plot(factor(requests$human_date_time$wday,labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))[requests$human_date_time$mon == 5],main="Number Downloads per Day in May")

# Plot the number of observations per day for JULY
plot(factor(requests$human_date_time$wday,labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))[requests$human_date_time$mon == 6],main="Number Downloads per Day in June")

# Plot the number of observations per day for AUGUST
plot(factor(requests$human_date_time$wday,labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))[requests$human_date_time$mon == 7],main="Number Downloads per Day in July")

# Check tht the sum of observtions of all histograms is 5000
length(which(requests$human_date_time$mon==5))+length(which(requests$human_date_time$mon==6))+length(which(requests$human_date_time$mon==7))

