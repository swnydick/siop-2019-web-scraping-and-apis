# I. SETUP API -----------------------------------------------------------------
# 1. click on developer.twitter.com
#    - sign up for twitter if you haven't
#    - I used API Test
#      - password abcdef123456
#    - after sign up, RECLICK on developer.twitter.com
#    - add phone number and email (if haven't in previous step)
# 2. apply for account and request access for personal use
#    - named Account "API Test"
#    - indicate country of operation
#    - describe the purposes of the application and check no for government agency
#       - put that it was for education
#       - indicated everything was in aggregate
#    - click on email!
# 3. create an app
#    - click on "Create an app"
#    - click on the "Create an app" button (in blue)
#    - put information:
#        - App name:
#           - "SIOP App"
#        - Application description: 
#           - "App for SIOP demonstration"
#        - Website URL (e.g.,):
#           - https://twitter.com/apitest123 
#        - Callback URL:
#           - http://127.0.0.1:1410
#        - Give description (essentially academic)
# 4. click on keys and tokens
#    - copy Consumer API keys (API key and API secret key)
keys            <- c("wDlJPoKnmrrGqAwBOSkQi8OEN", 
                     "CigGW4ni1RolABnq7Fuq2doDz")
secrets         <- c("ONsG3G1qLAuaDFnZlXIIsK9T3v9rESDOo0cl5ECZvAiOqW3eu0", 
                     "lgMgFreaI26XyizXC6kfHjtZxIofaxpkVulMcDPNeJEKXYdri0")

consumer_key    <- "wDlJPoKnmrrGqAwBOSkQi8OEN"
consumer_secret <- "ONsG3G1qLAuaDFnZlXIIsK9T3v9rESDOo0cl5ECZvAiOqW3eu0"

random_index    <- sample(seq_along(keys), size = 1)
consumer_key    <- keys[random_index]
consumer_secret <- secrets[random_index]

#    - create access token and access token secret
access_token    <- Sys.getenv("TWITTER_TOKEN")
access_secret   <- Sys.getenv("TWITTER_SECRET")

if(nchar(access_token) == 0){
  access_token  <- NULL
}
if(nchar(access_secret) == 0){
  access_secret <- NULL
}

# II. USE API AND PLOT ---------------------------------------------------------

# load required packages:
# - rtweet is to access the api
# - ggplot2 is to plot from the API (rtweet has some plotting functions as well)
# - ggthemes to add fun themes to plots
library(rtweet)
library(ggplot2)
library(ggthemes)
library(dplyr)

# create access token
# - OAuth 1.0 tokens (although you can use OAuth 2.0)
#    - if access_token/access_secret exists, will generate a new token
#    - otherwise, will ask for validation by opening a web-browser
# - definitions:
#    * consumer_key:    API key associated with the application (identifying the client)
#    * consumer_secret: client password to authenticate with server
#    * access_token:    issued to client once authentication succeeds
#    * access_secret:   sent with the access_token as a password
token <- create_token(
  consumer_key    = consumer_key,    # for the app
  consumer_secret = consumer_secret, # for the app
  access_token    = access_token,    # for the user
  access_secret   = access_secret,   # for the user
  set_renv        = TRUE             # update environment variables
)

# For many APIs, you can get an access_token/access_secret for the person who
# set up the application. Other users need to validate themselves via the normal
# website login to get an access token/secret to indicate what they are allowed
# to do in the API.

# search
# - q is "query"
#   - multiple words will be searched as "OR"
#   - words surrounded by \" ... \" will be searched as "AND"
#   - can use hashtags, words, etc.
# - indlude_rts is whether or not to include retweets
# - token is the token you got before (should be saved as well)
tweets <- search_tweets(
  q           = "#SIOP19",
  include_rts = FALSE,
  token       = token
)

# plot tweets
# - ts_plot is a function to make a tweet time series
#   - by can use standard time codes ("12 hours" "2 days")
#     - will aggregate by "by"
# - other stuff is ggplot
g      <- ts_plot(tweets,
                  by = "days",
                  tz = "America/New_York") +
          theme_excel_new(base_size   = 12,
                          base_family = "sans") +
          labs(title    = "Frequency of #SIOP2019 tweets from past 7 days",
               caption  = "Source: Data collected from Twitter's API")

# III. OTHER FUNCTIONS ---------------------------------------------------------

# - get_friends (get Ids of accounts followed by a user) - gets userid
# - lookup_users - takes id and turns it into user information
siop_friends_id <- get_friends(users = "SIOPtweets",
                               token = token)
siop_friends_dt <- lookup_users(users = siop_friends_id$user_id,
                                token = token)

# - take screenshot of tweets
#   * install suggested packages
#     - magick, webshot
#   * install phantomjs if not installed:
#     - webshot::install_phantomjs()
# - generate shot
tweet_shot(
  statusid_or_url = filter(tweets,
                           screen_name == "SIOPtweets") %>%
                    slice(n()) %>%
                    "[["("status_id")
)

# can also ...
# * stream_tweets
# * get_followers --> lookup_users (using user_id)
# * get_retweets
# * search_users

# finally if you are curious as to how much more stuff you can do ...
View(rate_limit(token = token))

