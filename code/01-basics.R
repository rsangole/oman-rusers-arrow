# setup ----

library(dplyr)
library(dbplyr)
library(arrow)
library(duckdb)

# read data ----
nyc <- open_dataset(here::here("data/nyc_part"))
nyc

object.size(nyc)

str(nyc)




nyc |>
    filter(year %in% 2017:2021) |>
    group_by(year) |>
    summarize(
        all_trips = n(),
        shared_trips = sum(passenger_count > 1, na.rm = TRUE)
    ) |>
    mutate(pct_shared = shared_trips / all_trips * 100)

library(tictoc)
tic()
nyc |>
    group_by(year) |>
    to_duckdb() |>
    count(rate_code) |>
    # show_query()
    collect()
toc()

tic()
nyc |>
    group_by(year) |>
    # to_duckdb() |>
    count(rate_code) |>
    # show_query()
    collect()
toc()


# head(), select(), filter(), and collect() to preview results
#
nyc |>
    # to_duckdb() |>
    filter(year == 2020) |>
    mutate(fare_pounds = fare_amount * 0.79) |>
    select(fare_amount, fare_pounds) |>
    # head() |>
    # show_query() |>
    collect()



taxis_gbp <- nyc_taxi |>
    mutate(across(ends_with("amount"), list(pounds = ~ .x * 0.79)))

taxis_gbp


taxis_gbp |>
    select(contains("amount")) |>
    head() |>
    collect()




# The arrow package contains methods for 37 dplyr table functions, many of which
# are "verbs" that do transformations to one or more tables. The package also
# has mappings of 211 R functions to the corresponding functions in the Arrow
# compute library

# slice
long_rides_2021 <- nyc_taxi |>
    filter(year == 2021 & trip_distance > 100) |>
    select(pickup_datetime, year, trip_distance)

long_rides_2021 |>
    slice(1:3)


long_rides_2021 |>
    slice_max(n = 3, order_by = trip_distance, with_ties = FALSE) |>
    collect()



# pivot
library(duckdb)

nyc_taxi |>
    group_by(vendor_name) |>
    summarise(max_fare = max(fare_amount)) |>
    to_duckdb() |> # send data to duckdb
    pivot_longer(!vendor_name, names_to = "metric") |>
    to_arrow() |> # return data back to arrow
    collect()



# functions within arrow
nyc_taxi |>
    mutate(vendor_name = na_if(vendor_name, "CMT")) |>
    head() |>
    collect()

nyc_taxi |>
    filter(str_ends(vendor_name, "S"), year == 2020, month == 9) |>
    collect()
