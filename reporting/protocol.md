# Protocol analysis approach

## Problem

### 1. Univariate analysis [TODO: give reasons why we're doing these analyses]

- How many unique IP-adresses (locations) made a request? 
- From which countries do they probably originate?
- How many IP-adressess accessed the site more than once? 
- Percentage of direct traffic? ("-" in origin variable) / direct vs. internal vs. referral percentages
- What is the average (mean,median) times an IP address accessed the site? 
- What type of device was mostly used (mobile+tablet/desktop)? 
- How many visits actually succeeded (vs. failure) to enter the page?
- Which pages resulted in errors (e.g. page not found)?
- What were the most requested pages?
- How many requests did the blog get? (Or the percentage...)
- What was the number of request for pages from humans? 
- What was the average (mean/median) object_size in kb?
- How many documents were downloaded (e.g. PDF)?

### 2. Questions for increase over time

- Did the visits increase over time? More visits in April compared to March etc.?
- In which months most of the visits are performed? (Should we look within this month?)
- Are there more visits in the weekend compared to the week? 
- Which day (Monday, Tuesday etc.) is most attractive for visitors?
- Are there more visits in the morning, afternoon compared to the evening?(From the perspective of the server; maybe also perspective of user if we find the time.)

### 3. Choose a variable and see whether it changes over time [TODO: use these to make tentative recommendations]

Potential questions: 

- Let's choose number of 'success rate' over time. In which month/day/hour is succes rate highest? [Off course it is ok if you have other preference.]
- How does country of origin ratios (or totals) evolve over time?
- Evolution of mobile/desktop traffic over time.
- Pages/visit over time (pages/ip/day)

## Methods

How are variables defined (character, numeric, date)? For the univariate analysis we will use percentages, numbers, means (SD) or medians (IQR) from variables, depending on normal distribution. (Should we also describe how we converted everything? I think not. That will be in the .rda file. ).

For secondary analyses we will create a day variable classified in morning (7:00-12:00 ), afternoon (12:00-18h) and evening/night(18h-7h) variable and plot numbers over

For the final analysis we defined succesrate of visiting a page as "succeeded" (yes,no)

[Also for how we constructed the robots, mobile/desktop columns etc.]

### Mathodological caveats

* User agent always starts with Mozilla -- probably misrecorded?
* While 5000 observations sounds like a lot, most of these are actually for assets (images, stylesheets and so on) rather than actual page content. Furthermore, because a single visitor usually visits multiple pages, we are actually analyzing perhaps only a couple hundred visitors over a time period of multiple months. The interpretation of any analysis must be seen in this light.
* For that same reason, we have taken care to specifically identify each request according to whether or not it is a request for a web page. For many kinds of analyses of web traffic, this is a more interesting dataset to work from than the set of all requests regardless of type.
* To identify the origin of a request, we've used the [MaxMinds GeoIP Lite](http://dev.maxmind.com/geoip/legacy/geolite/) database. MaxMinds claims a 14% error rate for city-level identification. Country-level identification (which we use) is likely to be more accurate than that. However, it is necessary to keep into account that geolocation using an IP address is never a hundred percent accurate.

## Results

The MMA website was visited 5000 times by n= different IP addresses. N= , %, which originated mostly from country y(n=,%) and country x(n=,%) and they were all from the same time zone (200). N, % of the IP addresses was used more than once used to visit the website. Most requests were images (n=, %), only (n=, 10%) of the requests were pages. Of the total requests n= (%) actually succeeded to enter the page.

We did (not) see an increase of visits over months (see plot .). Most visits were made in June (n, %). …… etc.

## Conclusion and discussion

Further research: 

- use origin + ip to determine user flows? (landing / exit pages)
