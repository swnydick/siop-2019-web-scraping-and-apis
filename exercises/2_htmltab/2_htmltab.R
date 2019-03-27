require(htmltab)
require(magrittr)

# Before raw scraping, let's try something inbetween an api and writing out own
# crawler. HTML tab simply downloads the page's html and looks for <table> div.
# Can use inspect element here as it's a nice easy example to show
#  a) how to use it and
#  b) how to look through HTML
# Look for: table, tr, td class = wikitable

# This page has a bunch of nice looking tables and wiki HTML is pretty clean to start with
url      <- "https://en.wikipedia.org/wiki/Forbes_Global_2000"
url_file <- "exercises/2_htmltab/forbes_global_2000.html"

# You can easily download the file to be in the appropriate directory
download.file(url      = url,
              destfile = url_file)

# There are 7 table tags sets
#  1. 2018 list
#  2. By country
#  3. By industry sector
#  4. 2017 list
#  5. 2016 list
#  6-7? They're hidden and NOT class = wikitable
#       (Forbes magazine lists)

# target by industry sector
# key takeaway: url + specify which table
#  - can also specify Xpath if you know what that is
#  - 
forbes_200_by_sector <- htmltab(doc   = url,
                                which = 3)
head(forbes_200_by_sector)

# this can also work with the downloaded file
head(htmltab(doc = url_file, which = 3))

# What to do when there is no API and the data aren't in nice tables?

## ADVANCED ##

# You can wrap the htmltab table to extract all tables on a page ...
#  - if which is beyond the number of tables on a page, it errors
#     * wrap in tryCatch - if error, sent to NULL
#  - cycle through all i's, and add all tables to list, break if error

# function to scrape all tables
get_html_tables <- function(url,
                            ...){
  
  # empty table index and start index
  tables <- list()
  i      <- 1
  
  repeat{
    
    # try to pull a table, return NULL if beyond index
    tab <- tryCatch(
      expr  = htmltab(doc   = url,
                      which = i,
                      ...),
      error = function(e) NULL
    )
    
    # - if NULL (we've errored, return)
    # - otherwise, add table to list
    if(!length(tab)){
      break;
    } else{
      tables[[i]] <- tab
      i           <- i + 1
    } # END ifelse STATEMENT
  } # END repeat LOOP
  
  # return all the tables
  return(tables)
} # END get_html_tables FUNCTION

# run on wikipedia page and get all tables
forbes_200_all <- get_html_tables(url)
