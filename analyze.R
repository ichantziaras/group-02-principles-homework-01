load('munged/requests.RData')
load('munged/pageviews.RData')

# not all requests are for pages, most are for assets (images, scripts, stylesheets etc.)
requests_per_page <- nrow(pageviews) / nrow(requests)

# top 5 pages
top5 <- head(sort(table(pageviews$for_path), decreasing = TRUE))

# documents downloaded
table(subset(requests, for_document)$for_extension)