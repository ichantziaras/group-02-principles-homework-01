# use `source('./install.R')` to install these dependencies

dependencies = c(
  'httr',      # analyzing URLs and making HTTP requests
  'lubridate', # easy-to-use datetime handling
  'plyr'       # reshaping and renaming
  )

install.packages(dependencies)