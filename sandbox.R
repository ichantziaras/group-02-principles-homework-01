load('munged/requests.RData')
load('munged/pageviews.RData')

# 1. we start on a Thursday, the 20th of June
# 2. we end on a Saturday, the 24th of August
# ==> NOTE: difficult to do per-month statistics because
# the data is incomplete
# ==> maybe instead, do per day, or per week, or both
# (and for weeks, start on Monday, end on Sunday!)
max(requests$date_time)
# "2013-08-24 04:34:48 UTC"
max(requests$human_date_time)
# "2013-08-24 04:34:48 UTC"
max(requests$human_date_time)$wday
# 6
min(requests$human_date_time)$wday
# 4

# how many client errors (mostly 404s)?
nrow(subset(requests, status_code_type == 'client error'))

unique(subset(requests, for_document)$for_extension)
table(subset(requests, for_document)$for_extension)

View(subset(pageviews, for_blog))


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


unique(pageviews$from_ip)

# how many requests from robots?
nrow(subset(requests, from_robot))

# unique ips per country (informally: visits per country, 
# as opposed to pages per country)
.counts <- count(pageviews, c('from_country', 'from_ip'))
uniques <- aggregate(from_ip ~ from_country, .counts, length)
# sanity check
length(unique(pageviews$from_ip)) == sum(uniques$from_ip)

# where does our requests peak come from?
peak <- subset(requests, date == '1aug2014')
# turns out it's this blog post: 
# http://www.mma.ugent.be/predictive_analytics/customer_intelligence/Blog/Entries/2013/7/26_Open_Source,_Big_Data_and_more_at_OSCON_in_Portland,_OR.html
