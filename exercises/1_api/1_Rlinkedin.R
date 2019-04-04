require(Rlinkedin)
require(magrittr)

# Have people use their own credentials
# Give explanation of oAuth access objects/ when to create one vs not

client_id     <- "86uxrl12ju03xl"
client_secret <- "cXD7SlUKVZPGuIum"

auth <- inOAuth(application_name = "fairly_arbitrary_name",
                consumer_key     = client_id,
                consumer_secret  = client_secret)


# get own info
debug(getProfile)
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
