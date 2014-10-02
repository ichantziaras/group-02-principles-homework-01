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

nrow(subset(requests, status_code_type == 'client error'))


requests$is_weekend <- subset(requests, human_date_time$wday == 0 | human_date_time$wday == 6)

requests$human_date_time$wday

unique(subset(requests, for_document)$for_extension)

table(subset(requests, for_document)$for_extension)

View(subset(pageviews, for_blog))

unique(pageviews$from_ip)

# how many requests from robots?
nrow(subset(requests, from_robot))
