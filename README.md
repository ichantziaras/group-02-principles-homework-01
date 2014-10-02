# Analyzing webserver log data (Principles of Statistics, Homework 1, Group 2)

## Contributing

1. Please download and install [Git](http://git-scm.com/downloads), or alternatively use the GUI application [GitHub for Mac](https://mac.github.com/) or [GitHub for Windows](https://windows.github.com/).
2. Next, create an account on [GitHub](https://github.com/join).
3. Once registered, tell @stdbrouw to add you to the @mastat organization.
4. Clone the repository, either in the desktop application you just downloaded or by typing `git clone https://github.com/mastat/group-02-principles-homework-01.git` on the command-line.

## Getting started

Load `principles-homework-01.Rproj` in RStudio, or just change your working directory to the directory containing this README, then run `source('./install.R')` in an R console to install the necessary packages.

## Project structure

* data munging happens in `munge.R`
* the resulting data is written to `munged/requests.RData` and `munged/pageviews.RData`
* data is analyzed in `analyze.R`
* utility functions that belong nowhere else are in `utils.R`

## Manifest

Data is first cleaned and munged, only then analyzed.

Here's explanations of a subset of all columns in the cleaned data: 

Column name      | Type             | Description
-----------------|------------------|-------------
timezone         | character vector | the timezone in ISO format (+0200 for every data point)
status_code      | integer          | the HTTP status code
status_code_type | factor           | the type of status code (success, client error, redirect etc.)
object_size      | integer          | object size in bytes, untouched
origin           | character vector | the page from which our user was referred
referral_type    | factor           | whether the referral counts as internal, external, search, social and so on
date             | character vector | the original date, untouched
time             | character vector | the original time, untouched
date_time        | POSIXct          | the date and time as a UNIX timestamp (parsed from date, time and timezone)
human_date_time  | POSIXlt          | the date and time as an R list
week_of_year     | integer          | the week of the year, 1-52
is_weekend       | logical          | whether the day of the request is a Saturday or a Sunday
is_tail          | logical          | whether the request was made in the first or last week of our sample
for_uri          | character vector | the uniform resource identifier (the requested path)
for_path         | character vector | the path to the requested uri (without ?qs or #anchors)
for_extension    | character vector | the file extension, without leading dot, e.g. jpg, gif
for_page         | logical          | whether the request is for a page (html or php)
for_document     | logical          | whether the request is for a document (doc, xls etc.)
for_blog         | logical          | whether the request is for a page on the blog
from_user_agent  | character vector | the browser or other tool that issued the request
from_ip          | character vector | the IP address in dotted decimal notation, e.g. 192.168.2.1
from_country     | factor           | the country from which the request originates, found by using a GeoIP database
from_robot       | logical          | whether the request was made by a crawler
from_mobile      | logical          | whether the traffic originates from a mobile browser, extracted from from_user_agent

For ease of analysis, we have chosen not to normalize the data, that is, to retain everything in a single table and not split the data into separate tables that describe requests, pages and users. However, we have tried to make the distinction between these different kinds of variables clear with the following naming scheme: 

prefix | meaning
-------|---------
for_   | page data, derived from uri
from_  | user data, derived from ip and user_agent
is_    | logical data (unless for_ or from_)
*      | request data
