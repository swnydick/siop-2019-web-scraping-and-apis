# unpaywall (requires roadoi to access api)
saved_thing <- roadoi::oadoi_fetch(
  dois      = c("10.1186/s12864-016-2566-9",
                "10.1103/physreve.88.012814"), 
  email     = "fake@gmail.com",
  .progress = "text"
)