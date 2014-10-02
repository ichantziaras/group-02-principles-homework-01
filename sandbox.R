load('munged/requests.RData')
load('munged/pageviews.RData')

# 1. we start on a Thursday, the 20th of June
# 2. we end on a Saturday, the 24th of August
# ==> NOTE: difficult to do per-month statistics because
# the data is incomplete
# ==> maybe instead, do per day, or per week, or both
# (and for weeks, start on Monday, end on Sunday!)
> max(requests$date_time)
[1] "2013-08-24 04:34:48 UTC"
> max(requests$human_date_time)
[1] "2013-08-24 04:34:48 UTC"
> max(requests$human_date_time)$wday
[1] 6
> min(requests$human_date_time)$wday
[1] 4

nrow(subset(requests, status_code_type == 'client error'))


requests$is_weekend <- subset(requests, human_date_time$wday == 0 | human_date_time$wday == 6)

requests$human_date_time$wday

unique(subset(requests, for_document)$for_extension)

table(subset(requests, for_document)$for_extension)

View(subset(pageviews, for_blog))

5000
#only for a pageviews only html php no robots
#2639 unique IP
#311 for a page
length(unique(requests$from_ip))


length(unique(pageviews$from_ip))

#Unique IP_addresses per country
#Methodology from the pagevies to unque
unique  <- pageviews[which(duplicated(pageviews$from_ip)),]
View(unique)
id <- which(duplicated(pageviews$from_ip))
unique  <- pageviews[-id,]

x <- table(unique$from_country)
tail(sort(x))

