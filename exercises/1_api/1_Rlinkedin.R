require(Rlinkedin)
require(magrittr)

# Have people use their own credentials
# Give explanation of oAuth access objects/ when to create one vs not
auth <- inOAuth(application_name = "kf_test_app",
                consumer_key     = "86kpnnar06yg08",
                consumer_secret  = "8bGjuxcvennKiE8V")


# get own info
my_data <- getProfile(auth)

# make them examine it
str(my_data)

# Pull into dataframe
# explain magrittr pipes
my_data %<>% as.data.frame()

# Paywall - segway into brute force web scraping
bens <- searchPeople(token      = auth,
                     keywords   = NULL,
                     first_name = "ben",
                     last_name  = "wiseman")

# unpaywall (requires roadoi to access api)
# (SIMPLE)
saved_thing <- roadoi::oadoi_fetch(
  dois      = c("10.1186/s12864-016-2566-9",
                "10.1103/physreve.88.012814"), 
  email     = "fake@gmail.com",
  .progress = "text"
)

