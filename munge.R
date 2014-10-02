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
requests$date_time = dmy_hms(.datetime)
requests$human_date_time = as.POSIXlt(requests$date_time)

# categorize status codes by type (success, redirect, client error etc.)
.status_code_types = substr(as.character(requests$status_code), 0, 1)
requests$status_code_type = factor(.status_code_types, 
  levels=names(STATUS_CODE_TYPES), labels=STATUS_CODE_TYPES)

# extract file path from requested url, getting rid of querystring arguments etc.
requests$for_path <- sapply(requests$for_uri, function (uri) parse_url(uri)$path)
# categorize requests by type
requests$for_extension <- as.factor(file_ext(requests$for_path))
requests$for_page <- ifelse(requests$for_extension %in% PAGE_EXTENSIONS, TRUE, FALSE)
requests$for_document <- ifelse(requests$for_extension %in% DOCUMENT_EXTENSIONS, TRUE, FALSE)
requests$for_blog <- grepl('/Blog', requests$for_path)

# figure out mobile traffic from user agent
requests$from_mobile <- grepl('mobile', requests$from_user_agent, ignore.case = TRUE)

# figure out whether the request was made from a known crawler or bot
requests$from_robot = sapply(requests$from_user_agent, is_robot)

# pageviews are defined as those requests that are for a 
# page and that were not made by a robot or crawler
# (alternative syntax: `requests[requests$for_page & !requests$from_robot, ]`)
pageviews <- subset(requests, for_page & !from_robot)

# save our munged and annotated log data
# (see analyze.R for the actual analysis)
save(requests, file = 'munged/requests.Rdata')
save(pageviews, file = 'munged/pageviews.Rdata')
