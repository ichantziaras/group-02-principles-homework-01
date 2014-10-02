library('tools')
library('httr')
library('lubridate')
library('plyr')
source('./utils.R')

# define global constants
PAGE_EXTENSIONS <- c('htm', 'html', 'php')
DOCUMENT_EXTENSIONS <- c('pdf', 'doc', 'docx', 'xls', 'xlsx')
STATUS_CODE_TYPES <- list(
  '1' = 'provisional', 
  '2' = 'success', 
  '3' = 'redirect', 
  '4' = 'client error', 
  '5' = 'server error'
  )

# load data
requests <- read.csv("raw/all.logs.train2.csv", header = TRUE)

# rename some columns to better reflect their nature
requests <- rename(requests, c(
  "file_name" = "for_uri", 
  "ip" = "from_ip", 
  "user_agent" = "from_user_agent"
  ))

# use the IP address to determine the country from which
# a visit originates (this might take a minute or two, 
# which is why we cache it)
.cache <- 'munged/geolocated.RData'
if (file.exists(.cache)) {
  load(.cache)
} else {
  requests$from_ip <- as.character(requests$from_ip)
  requests$from_country <- sapply(requests$from_ip, geolocate)
  save(requests, file = .cache)
}

# convert timezones to ISO format
requests$timezone <- paste('+0', requests$timezone, sep='')
# merge date, time and timezone and convert into proper
# datetime objects from characters
.datetime <- paste(requests$date, requests$time, requests$timezone)
requests$date_time <- dmy_hms(.datetime)
requests$human_date_time <- as.POSIXlt(requests$date_time)

# now that we've parsed dates and times, we can sort our requests
# (stdlib R code: `requests[order(with(requests, date_time)), ]`)
requests <- arrange(requests, date_time)

# week of the year (1-52)
requests$week_of_year <- week(requests$date_time)
# denote if a request was made during the weekend
requests$is_weekend <- requests$human_date_time$wday == 0 | requests$human_date_time$wday == 6

# the first and last weeks do not have data for each day of the week, 
# making certain kinds of analyses unfair
# 
# we won't remove this data, but we'll designate each data point from 
# these weeks as a "tail" (this has nothing to do with the tails of a 
# statistical distribution, of course)
.counts <- count(requests, c('week_of_year', 'human_date_time$wday'))
days_measured_per_week <- aggregate(human_date_time.wday ~ week_of_year, .counts, length)
days_measured_per_week <- rename(days_measured_per_week, list('human_date_time.wday' = 'days_measured'))
incomplete_weeks <- subset(days_measured_per_week, days_measured < 7)$week_of_year
requests$is_tail <- requests$week_of_year %in% incomplete_weeks

# categorize status codes by type (success, redirect, client error etc.)
.status_code_types <- substr(as.character(requests$status_code), 0, 1)
requests$status_code_type <- factor(.status_code_types, 
  levels=names(STATUS_CODE_TYPES), labels=STATUS_CODE_TYPES)

# extract file path from requested url, getting rid of querystring arguments etc.
requests$for_path <- sapply(requests$for_uri, function (uri) parse_url(uri)$path)
# categorize requests by type
requests$for_extension <- as.factor(file_ext(requests$for_path))
requests$for_page <- requests$for_extension %in% PAGE_EXTENSIONS
requests$for_document <- requests$for_extension %in% DOCUMENT_EXTENSIONS
requests$for_blog <- grepl('/Blog', requests$for_path)

# figure out mobile traffic from user agent
requests$from_mobile <- grepl('mobile', requests$from_user_agent, ignore.case = TRUE)

# figure out whether the request was made from a known crawler or bot
requests$from_robot <- sapply(requests$from_user_agent, is_robot)

# what was the previous page that was visited (categorized origin)?
requests$referral_type <- as.factor(sapply(requests$origin, categorize_referrer))

# pageviews are defined as those requests that are for a 
# page and that were not made by a robot or crawler
# (alternative syntax: `requests[requests$for_page & !requests$from_robot, ]`)
pageviews <- subset(requests, for_page & !from_robot)

# save our munged and annotated log data
# (see analyze.R for the actual analysis)
save(requests, file = 'munged/requests.Rdata')
save(pageviews, file = 'munged/pageviews.Rdata')
