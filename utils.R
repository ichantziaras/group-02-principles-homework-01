# this code includes GeoLite data created by MaxMind, 
# available from http://www.maxmind.com

.geoip <- read.csv("raw/GeoIPCountryWhois.csv", 
  col.names=c('ip_from', 'ip_to', 'ip_int_from', 'ip_int_to', 'country_code', 'country'))

# a function that makes it easier to do GeoIP lookups, by 
# converting a dotted decimal ip into an integer
ip_to_integer <- function(address) {
  segments <- strsplit(address, "\\.")
  octets <- strtoi(unlist(segments))
  return(
    16777216 * octets[1] + 
    65536 * octets[2] +
    256 * octets[3] +
    octets[4]
  )
}

# this is not terribly efficient, but works well
# for smaller datasets
geolocate <- function(ip) {
  i <- ip_to_integer(ip)
  match <- subset(.geoip, ip_int_from <= i & ip_int_to >= i)
  return(match$country)
}

# determine whether a user_agent represents a robot or a real human being
KNOWN_ROBOTS <- c('msnbot', 'googlebot', 'java', 'apache', 'crawler')

is_robot <- function(user_agent) {
  matches <- sapply(KNOWN_ROBOTS, function(robot) grepl(robot, user_agent))
  return(any(matches))
}

categorize_referrer <- function (referrer) {
  if (grepl('^-$', referrer)) {
    'direct'
  } else if (grepl('mma\\.ugent\\.be', referrer)) {
    'internal'
  } else if (grepl('ugent\\.be', referrer)) {
    # different subdomain, same domain
    'local'
  } else if (grepl('plus\\.google|facebook|twitter', referrer)) {
    'social'
  } else if (grepl('google|yahoo|bing', referrer)) {
    'search'
  } else {
    'external'
  }
}