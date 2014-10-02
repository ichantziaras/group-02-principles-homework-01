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
# First of all we plot the evolution of requests (which contain images...). Then I will do the same but I will excude images... Therefore, I will take into account only web pages
frequencies <- rep(NA,max(requests$human_date_time$yday)+1-min(requests$human_date_time$yday))
for (i in min(requests$human_date_time$yday):max(requests$human_date_time$yday)){
  frequencies[i-min(requests$human_date_time$yday)+1] <- length(requests$human_date_time$yday[requests$human_date_time$yday==i])
}
plot(seq(from = min(requests$human_date_time$yday),
     to = max(requests$human_date_time$yday)),
     frequencies, type="l" ,xlab="Time", ylab="Frequencies",
     main = "Evolution of Requests Over Time",col="red",lwd=4, xaxt = "n")
axis(side=1,at=c(min(requests$human_date_time$yday),max(requests$human_date_time$yday)),labels=c("20th June","24th August"))
abline(a = mean(frequencies), b=0, lwd=4, col="blue")
abline(a = median(frequencies), b=0, lwd=4, col="green")
legend(x=166, y=600, col=c("red","blue","green"), lty=c(1,1,1), lwd=c(4,4,4), legend=c("Requests per Day","Mean = 76", "Median = 47"))

# Evolution of visit of pages over time
frequencies <- rep(NA,max(pageviews$human_date_time$yday)+1-min(pageviews$human_date_time$yday))
for (i in min(pageviews$human_date_time$yday):max(pageviews$human_date_time$yday)){
  frequencies[i-min(pageviews$human_date_time$yday)+1] <- length(pageviews$human_date_time$yday[pageviews$human_date_time$yday==i])
}
plot(seq(from = min(pageviews$human_date_time$yday),
         to = max(pageviews$human_date_time$yday)),
     frequencies, type="l", xlab="Time", ylab="Frequencies",
     main = "Evolution of Page Views Over Time",col="red",lwd=4, xaxt = "n", ylim=c(0,24))
axis(side=1,at=c(min(pageviews$human_date_time$yday),max(pageviews$human_date_time$yday)),labels=c("20th June","24th August"))
abline(a = mean(frequencies), b=0, lwd=4, col="blue")
abline(a = median(frequencies), b=0, lwd=4, col="green")
legend(x=200, y=25, col=c("red","blue","green"), lty=c(1,1,1), lwd=c(4,4,4), legend=c("Requests per Day","Mean = 7", "Median = 6"))

# In which months most of the visits are performed? (Should we look within this month?)
plot(factor((requests$human_date_time$mon), labels=c("June*","July", "August*")), main="Number Requests per Month", col="blue")

# Are there more visits in the weekend compared to the week? Check if there are the same number of mondays, tuesdays...
plot(factor(requests$human_date_time$wday,labels=c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")), col="blue", main="Number Requests per Day")
# Values of the bars of the plot above: 395, 559, 574, 426, 1584, 989, 475
plot(factor(pageviews$human_date_time$wday,labels=c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")), col="blue", main="Number Page Visits per Day")
# Values of the bars of the plot above: 50, 56, 58, 44, 97, 67, 50

# THis is the command to calculate the days. There are 10 mondays, tuesdays and wednesdays. There are 9 days of the rest days of the week
x <- rep(0:6,length.out=max(requests$human_date_time$yday)+1-min(requests$human_date_time$yday))
x <- x[-1]
