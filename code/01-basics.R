# setup ----
library(dplyr)
library(arrow)
library(tictoc) # useful to time commands

# read data ----

# open multi-file dataset
nyc <- open_dataset(here::here("data/nyc_part"))
nyc

# investigate ----

object.size(nyc)

str(nyc)

schema(nyc)

nyc |> nrow()


# my machine ----

# 2021 MacBook Pro, running Sonoma 14.1
# Apple M1 Pro
# 16 GB RAM

# R 4.3.2
# {arrow}: 13.0.0.1
# {dplyr}: 1.1.3