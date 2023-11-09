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

# 2021 MacBook Pro
# Apple M1 Pro, 10 cores
# 16 GB RAM

# R 4.3.2
# {arrow}: 13.0.0
# {dplyr}: 1.1.3