# setup ----
library(dplyr)
library(arrow)
library(tictoc)

# read data ----
nyc <- open_dataset(here::here("data/nyc_part"))
nyc

# investigate ----

object.size(nyc)

class(nyc)

str(nyc)

schema(nyc)

nyc |> nrow()
