load('munged/requests.RData')
load('munged/pageviews.RData')

# not all requests are for pages, most are for assets (images, scripts, stylesheets etc.)
requests_per_page <- nrow(pageviews) / nrow(requests)

# top 5 pages
top5 <- head(sort(table(pageviews$for_path), decreasing = TRUE))

# documents downloaded
table(subset(requests, for_document)$for_extension)

# Questions to answer
# Did the visits increase over time? More visits in April compared to March etc.?
frequencies <- rep(NA,max(requests$human_date_time$yday)+1-min(requests$human_date_time$yday))
for (i in min(requests$human_date_time$yday):max(requests$human_date_time$yday)){
  frequencies[i-min(requests$human_date_time$yday)+1] <- length(requests$human_date_time$yday[requests$human_date_time$yday==i])
}
frequencies
plot(seq(from = min(requests$human_date_time$yday),
     to = max(requests$human_date_time$yday)),
     frequencies, type="l" ,xlab="Time", ylab="Frequencies",
     main = "Evolution of Requests Over Time",col="red",lwd=4, xaxt = "n")
axis(side=1,at=c(min(requests$human_date_time$yday),max(requests$human_date_time$yday)),labels=c("20th June","24th August"))
abline(a = mean(frequencies), b=0, lwd=4, col="blue")
abline(a = median(frequencies), b=0, lwd=4, col="green")
legend(x=166, y=600, col=c("red","blue","green"), lty=c(1,1,1), lwd=c(4,4,4), legend=c("Requests per Day","Mean = 76", "Median = 47"))

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
