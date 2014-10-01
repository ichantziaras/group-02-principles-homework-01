# Analyzing webserver log data (Principles of Statistics, Homework 1, Group 2)

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
date_time        | POSIXct          | the date and time as a UNIX timestamp (parsed from date, time and timezone)
human_date_time  | POSIXlt          | the date and time as an R list
for_uri          | character vector | the uniform resource identifier (the requested path)
for_path         | character vector | the path to the requested uri (without ?qs or #anchors)
for_extension    | character vector | the file extension, without leading dot, e.g. jpg, gif
for_page         | logical          | whether the request is for a page (html or php)
for_document     | logical          | whether the request is for a document (doc, xls etc.)
for_blog         | logical          | whether the request is for a page on the blog
from_ip          | character vector | the IP address in dotted decimal notation, e.g. 192.168.2.1
from_country     | factor           | the country from which the request originates, found by cross-referencing with a GeoIP database
from_robot       | logical          | whether the request was made by a crawler
from_mobile      | logical          | whether the traffic originates from a mobile browser, found by analyzing user_agent information

For ease of analysis, we have chosen not to normalize the data, that is, to retain everything in a single table and not split the data into separate tables that describe requests, pages and users. However, we have tried to make the distinction between these different kinds of variables clear with the following naming scheme: 

prefix | meaning
-------|---------
for_   | page data, derived from uri
from_  | user data, derived from ip and user_agent
*      | request data
