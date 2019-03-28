# I. LOAD EVERYTHING -----------------------------------------------------------

# rvest is just a wrapper for xml2
# - need to be able to get xpath selector, which may be difficult
require(rvest)
require(magrittr)
require(roperators)
require(data.table)
require(stringr)
library(dplyr)

# Get them to pull up site to scrape reviews from
# It will help if they have chrome open with log in to glassdoor

# - some examples of URLs we can use
# - go to Glassdoor and search
search_url <- "https://www.glassdoor.com/Reviews/Korn-Ferry-Reviews-E5644.htm"
search_url <- "https://www.glassdoor.com/Reviews/Facebook-Reviews-E40772.htm"
search_url <- "https://www.glassdoor.com/Reviews/Google-Reviews-E9079.htm"
search_url <- "https://www.glassdoor.com/Reviews/LinkedIn-Reviews-E34865.htm"

# Pull html as xml - set options to allow a lot of data to be pulled
# - options are a set of parsing options
#    - RECOVER: if there's an error, it will recover
#    - HUGE:    remove limits on searching
#    - NODICT:  do not reuse the context dictionary
site_html  <- read_html(search_url,
                        options = c("RECOVER",
                                    "HUGE",
                                    "NODICT"),
                        verbose = TRUE)

# Verify xml exists (html is sort of somewhat xml)
class(site_html)

# II. FIND STRUCTURE -----------------------------------------------------------

# - is in the class? use "." - so class="rating" --> ".rating"
# - is in the id? use "#" - so id="this-thing"   --> "#this-thing"

# looking at inspect element, we see reviews are of class empReview
# ... iterating:
#   - hreview seems like it's the whole review
#   - rating seems like it's the actual rating
#   - value-title seems like it's the actual title
#   - use the "."
#   - nest with spaces ... we want ".value-title" in ".rating" in ".hreview"

# ratings
# - this gets the (up to) TEN reviews on the page that we linked
site_html %>%
  html_nodes(".hreview .rating .value-title") %>%
  html_attr(name = "title") %>%
  int()

# headings (same process)
site_html %>%
  html_nodes(".hreview .h2 .summary") %>%
  html_text()

# job titles (same process ... but seems to be doubled)
site_html %>%
  html_nodes(".hreview .author .authorJobTitle") %>%
  html_text()

# look at text (pros and cons)
site_html %>%
  html_nodes(".hreview .pros") %>%
  html_text()
site_html %>%
  html_nodes(".hreview .cons") %>%
  html_text()

# look at text (advice to management)
# ISSUE - this doesn't appear for everyone - if blank will be missing
# (might need to parse person by person?)
site_html %>% 
  html_nodes(".hreview .adviceMgmt") %>%
  html_text()

# show messier structures
recommends <- site_html %>%
              html_nodes(".hreview .recommends")
recommends[[1]] %>%
  html_nodes(".cell") %>%
  html_text()

# III. FUNCTIONS ---------------------------------------------------------------

# how do we scrape everything off this webpage and put it into a table?

#   1. Utility Functions -------------------------------------------------------

# A. function to pull out text nodes of object
html_node_to_text <- function(...){
  
  # pull out all nodes that match a path/css string and pull OUT text
  out <- html_nodes(...) %>%
         html_text()
  
  # - if text exists, return it (with extra stuff trimmed off)
  # - otherwise, return an empty string
  if(length(out) == 0){
    return("")
  } else{
    return(str_trim(out))
  }
}

# B. function to get all glassdoor ratings attributes
get_all_glassdoor <- function(site_html,
                              return_text = TRUE,
                              ...){
  
  # whether we want to return text or the full set of nodes
  if(return_text){
    parse_fun <- html_node_to_text
    simplify  <- TRUE
  } else{
    parse_fun <- html_nodes
    simplify  <- FALSE
  }
  
  # parse all nodes within a review class
  out <- html_nodes(site_html,
                    css = ".hreview") %>%
         lapply(parse_fun, ...)
  
  # return a vector if all elements of out are of length 1
  if(simplify && all(sapply(out, length) == 1)){
    return(unlist(out))
  } else{
    return(out)
  }
} 

#   2. Helper Functions --------------------------------------------------------

# A. helper function to get number of reviews
get_glassdoor_counts <- function(site_html){
  
  # determine total number of reviews from site (using CSS selectors)
  # - set of classes        "eiCell cell reviews active"
  # - nested set of classes "num h2"
  html_node_to_text(site_html,
                    css = ".eiFilter .noPadLt .padTopSm") %>%
  str_remove_all(pattern = "[,\\.]") %>%
  str_extract(pattern = "[0-9]+") %>%
  int()
}

# B. helper function to get ratings
get_glassdoor_ratings <- function(site_html){
  
  # same code as before
  # - pull out value-title WITHIN the rating class
  # - the text attribute is the rating
  # - convert to an integer
  get_all_glassdoor(site_html,
                    css         = ".rating .value-title",
                    return_text = FALSE) %>%
  sapply(html_attr, name = "title") %>%
  int()
}

# C. helper function to get dates from ratings
get_glassdoor_dates <- function(site_html){
  
  # dates are a little funny because of an empty date field on the page
  # - pull out anything with a datetime attribute
  # - remove "missing" dates
  get_all_glassdoor(site_html,
                    css         = ".date",
                    return_text = FALSE) %>%
  sapply(. %>% html_attr("datetime") %>% "["(!is.na(.)))
}

# CD function to pull out URL pages based on number of pages to scrape
#    - each html gives only a few ratings (10?)
#    - we need to scrape all 985 (or so)!
get_glassdoor_pages <- function(search_url,
                                base_site_html = NULL){
  
  # determine the base site html if it's missing
  if(is.null(base_site_html)){
    base_site_html <- read_html(search_url,
                                options = c("RECOVER",
                                            "HUGE",
                                            "NODICT"),
                                verbose = TRUE)
  } # END if STATEMENT
  
  # pull out the number of reviews and ratings using previous functions
  # - the total number of reviews on all pages (using previous function)
  # - the number of ratings on a single page (pull out ratings and take length)
  n_reviews_all  <- get_glassdoor_counts(base_site_html)
  n_reviews_page <- length(get_glassdoor_ratings(base_site_html))
  
  # the number of pages is simply the number of reviews divided by ratings per page
  n_pages        <- ceiling(n_reviews_all / n_reviews_page)
  
  # put everything together to get all of the pages
  search_url %-% ".htm" %+% "_P" %+% seq_len(n_pages) %+% ".htm"
}

#   3. Wrapper Functions -------------------------------------------------------

# A. function to pull out all ratings on a single page
get_glassdoor_reviews_one <- function(url){
  
  # read the url and pulling out hreview tag
  site_html <- read_html(url,
                         options = c("RECOVER",
                                     "HUGE",
                                     "NODICT"),
                         verbose = TRUE)
  
  # grabbing all attributes
  out <- list(
    rating      = get_glassdoor_ratings(site_html),
    titles      = get_all_glassdoor(site_html, css = ".h2 .summary"),
    authors     = get_all_glassdoor(site_html, css = ".author .minor .authorJobTitle"),
    location    = get_all_glassdoor(site_html, css = ".author .minor .authorLocation"),
    
    # dates are a bit funny (see above)
    date        = get_glassdoor_dates(site_html),
    tenure      = get_all_glassdoor(site_html, css = ".tightBot.mainText"),
    recommends  = get_all_glassdoor(site_html, css = ".recommends"),
    pros        = get_all_glassdoor(site_html, css = ".pros"),
    cons        = get_all_glassdoor(site_html, css = ".cons"),
    mgmt_advice = get_all_glassdoor(site_html, css = ".adviceMgmt")
  )

  return(as.data.table(out))
}

# B. function to pull out all glassdoor ratings across all pages
get_glassdoor_reviews_all <- function(search_url,
                                      max_pages = NULL,
                                      sleep     = 1){
  
  # pull out all URLs using get glassdoor pages
  html <- read_html(search_url,
                    options = c("RECOVER", "HUGE", "NODICT"),
                    verbose = TRUE)
  urls <- get_glassdoor_pages(search_url, html)
  
  if(is.null(max_pages) || is.na(max_pages)){
    max_pages <- Inf
  }
  
  # getting the minimum of max pages AND the urls (pages to take)
  num_pages <- min(x = length(urls),
                   y = max_pages)
  urls      <- urls[seq_len(num_pages)]
  
  # across all of the urls
  # - try to get reviews for that page
  # - sleep a set time (so we don't overload the system
  # - if error, print error and return nothing
  out <- lapply(
    X   = urls,
    FUN = function(url){
      tryCatch(
        expr  = {
          out <- get_glassdoor_reviews_one(url)
          Sys.sleep(sleep)
          return(out)
        },
        error = function(e){
          warning(e)
          return(NULL)
        }
      )
    }
  )
  
  # bind everything together into a data table
  rbindlist(out)
}

#   3. Analysis ----------------------------------------------------------------

# pulling everything out and making into a data.table
all_reviews <- get_glassdoor_reviews_all(search_url = search_url,
                                         max_pages  = 10,
                                         sleep      = .2)

# what is the class of all of the columns
sapply(all_reviews, class)

# why are there lists
tail(all_reviews$pros)
tail(all_reviews$cons)
tail(all_reviews$titles)

# it seems like translations ... english always seems to be last

# turn list columns into vector columns
for(j in seq_along(all_reviews)){
  if(is.list(all_reviews[[j]])){
    all_reviews[[j]] <- sapply(all_reviews[[j]], FUN = tail, n = 1)
  }
}

# seems to work
tail(all_reviews$pros)
tail(all_reviews$cons)
tail(all_reviews$titles)

# then you can aggregate and restructure

# - take mean of ratings and count of ratings
# - aggregate by location
# - filter to locations with at least 10 reviews
# - order by ratings

# ... using data.table language
all_reviews[
  j  = .(avg_rating = mean(rating),
         n_reviews  = .N),
  by = location
][
  i  = n_reviews > 10
][
  i  = order(avg_rating)
]

# ... using dplyr language
all_reviews %>%
  group_by(location) %>%
  summarize(avg_rating = mean(rating),
            n_reviews  = n()) %>%
  filter(n_reviews > 10) %>%
  arrange(avg_rating)

# - take mean of ratings and count of ratings
# - aggregate by author
# - filter to locations with at least 10 reviews
# - order by ratings

# ... using data.table language
all_reviews[
  j  = .(avg_rating = mean(rating),
         n_reviews  = .N),
  by = authors
][
  i  = n_reviews > 10
][
  i  = order(avg_rating)
]

# ... using dplyr language
all_reviews %>%
  group_by(authors) %>%
  summarize(avg_rating = mean(rating),
            n_reviews  = n()) %>%
  filter(n_reviews > 10) %>%
  arrange(avg_rating)
