require(htmltab)

# Before raw scrping, let's try something inbetween an api and writing out own crawler
# Explain HTML tab simply downloads the page's html and looks for <table> div
# use inspect element here as it's a nice easy example to show a) how to use it and b) how to look through HTML
# table, tr, td class = wikitable

# This page has a bunch of nice looking tables and wiki HTML is pretty clean to start with
url <- "https://en.wikipedia.org/wiki/Forbes_Global_2000"

# target by industry sector
# key takeaway: url + specify which table
by_sector <- htmltab(url, which = 3)
head(by_sector)

# Now segway into when there is no API (or you're too cheap to pay for one) and
# the data aren't in nice tables. 

## ADVANCED ##

# function to scrape all tables
get_html_tables <- function(url){
  
  # empty table index and start index
  tables <- list()
  i      <- 1
  
  repeat{
    
    # try to pull a table, return NULL if beyond index
    tab <- tryCatch(expr  = htmltab(url, which = i),
                    error = function(e) NULL)
    
    # - if NULL (we've errored, return)
    # - otherwise, add table to list
    if(!length(tab)){
      break;
    } else{
      tables[[i]] <- tab
      i           <- i + 1
    }
  }
  
  return(tables)
}
