# Remember to explain that rvest is more-or-less just a wrapper for xml2
require(rvest) #can do in xml2, but need to be able to get xpath selector, may be difficult
require(magrittr)
# Make the bastards become dependent on KFI packages in long game
require(roperators)
require(data.table)

# Get them to pull up site to scrape reviews from
# It will help if they have chrome open with log in to glassdoor
search_url <- "https://www.glassdoor.com/Reviews/Korn-Ferry-Reviews-E5644.htm"

# Pull html as xml - set options to allow a lot of data to be pulled
site_html  <- read_html(search_url,
                        options = c("RECOVER",
                                    "HUGE",
                                    "NODICT"),
                        verbose = TRUE)

# Verify xml exists
class(site_html)


# FIND STRUCTURE ---------------------------------------------------------------
# now, looking at inspect element, we see reviews are of class .empReview
# do this step-wise to demo how it was derrived

# Ratings
ratings <- site_html %>%
           html_nodes(".hreview .rating .value-title") %>%
           html_attr(name = "title") %>%
           int()

# headings
site_html %>%
  html_nodes(".hreview .h2 .summary") %>%
  html_text()

# job titles
site_html %>%
  html_nodes(".hreview .author .authorJobTitle") %>%
  html_text()

# Look at text
pros <- site_html %>%
        html_nodes(".hreview .pros")
cons <- site_html %>%
        html_nodes(".hreview .cons")
# possible issue here - if something is blank, we get only 8 objects
adv  <- site_html %>% 
        html_nodes(".hreview .adviceMgmt")      


# Show messier structures
reccomends <- site_html %>% html_nodes(".hreview .recommends")
reccomends[[1]] %>% html_nodes(".cell") %>% html_text()

# Let's try to get everything in a table =======================================

# 1) make a convienence function
html_node_to_text <- function(html, css){
  out <- html_nodes(html, css) %>% html_text()
  #return empty string if missing
  if(length(out) == 0) out <- ""
  return(out)
}

# 2) Need to know many pages to scrape
# So... get number of total reviews from site
n_reviews <- html_node_to_text(site_html, ".eiCell.cell.reviews.active .num.h2")
n_reviews
# okay, a little cleaning up
n_reviews <- int(n_reviews %-% " ")

# now, how many reviews per page? 
n_pages <- ceiling(n_reviews/length(ratings))

# 3) Now make a vector of all page URLS
url_pages <- c(search_url %-% ".htm" %+% "_P" %+% (1:n_pages) %+% ".htm")

# 4)  Make a function to get all reviews
# get data from all reviews on page IN ORDER
get_reviews <- function(url){
  
  rev_nodes <- read_html(url,
                         options = c("RECOVER", "HUGE", "NODICT"),
                         verbose = TRUE) %>% 
               html_nodes(".hreview")
  
  # now grab attributes
  out            <- list()
  out$rating     <- sapply(rev_nodes, function(x){
                                                   html_nodes(x, ".rating .value-title") %>%
                                                   html_attr(name = "title")
                                                  })
  out$titles     <- sapply(rev_nodes, html_node_to_text, ".h2 .summary")
  out$authors    <- sapply(rev_nodes, html_node_to_text, ".author .minor .authorJobTitle")
  out$location   <- sapply(rev_nodes, html_node_to_text, ".author .minor .authorLocation")
  # dates are a little funny because of an empty date field on the page
  out$date       <- sapply(rev_nodes, function(x){
                                                   html_nodes(x, ".date") %>%
                                                   html_attr("datetime") %>%
                                                   extract(!is.na(.))
                                                  })
  out$tenure     <- sapply(rev_nodes, html_node_to_text, ".tightBot.mainText")
  out$recommends <- sapply(rev_nodes, html_node_to_text, ".recommends")
  out$pros       <- sapply(rev_nodes, html_node_to_text, ".pros")
  out$cons       <- sapply(rev_nodes, html_node_to_text, ".cons")
  out$adv_mgmt   <- sapply(rev_nodes, html_node_to_text, ".adviceMgmt")

  return(out)
}

# 5) Pull the data Now, make a list of reviews from all pages
all_reviews <- list()
for(this_page in seq_along(url_pages)){
  all_reviews[[this_page]] <- get_reviews(url_pages[this_page])
  Sys.sleep(1) # make sure the site's server doesn't think you're trying to DDOS them
}

# 6) Save it
saveRDS(all_reviews, "all_kf_reviews_4.rds")

# 7) Make it into a data table.
# waht are we working with?
str(all_reviews[[1]])

# Put into a nice data table
dt_review <- do.call(rbind, lapply(all_reviews, as.data.table))
sapply(dt_review, class) 
# why are there lists?
tail(dt_review$pros)
tail(dt_review$title) 
# translations!!

# So, let's go and take the English ones!
for(j in seq_along(colnames(dt_review))){
  if(class(dt_review[[j]]) == "list"){
    dt_review[[j]] %<>% sapply(function(x) x[length(x)]) %>% unlist()
  }
}
sapply(dt_review, class) # works
tail(dt_review$pros) 

# SAVE as flat file
write.csv(dt_review, 
          "glassdoor_kf_reviews.csv",
          row.names = FALSE)

# Then you can do stuff like:
dt_review[, .(avg_rating = mean(int(rating)),
              n_reviews  = .N),
          by = location] %>%
  .[n_reviews > 10] %>%
  .[order(avg_rating)]

dt_review[, .(avg_rating = mean(int(rating)),
              n_reviews  = .N),
          by = authors] %>%
  .[n_reviews > 10] %>%
  .[order(avg_rating)]
