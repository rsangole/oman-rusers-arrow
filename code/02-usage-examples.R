# Data Manipulation ----
query <- nyc |>
    filter(year == 2019) |>
    select(fare_amount, passenger_count)
query

class(query)

schema(query)

# Collecting results ----
query |>
    collect()

# Example of head() ----
nyc |>
    filter(year == 2019) |>
    select(fare_amount, passenger_count) |>
    head() |>
    collect()

# Filter using multiple conditions ----
tic()
nyc |>
    filter(
        str_ends(vendor_name, "S"),
        year %in% c(2020, 2021), 
        month == 9) |>
    collect()
toc()xw

# Selecting columns by name ----
nyc |>
    select(
        contains('pickup'),
        ends_with('amount')
    )

# Selecting columns by type ----
nyc |> 
    select(
        where(is.character)
    )

# Distinct ----
tic()
nyc |>
    distinct(year, month) |>
    arrange(year, month) |>
    collect()
toc()

# Mutating columns ----
tic()
nyc |>
    filter(year == 2019) |>
    mutate(tip_percentage = tip_amount / fare_amount * 100) |>
    select(fare_amount, tip_amount, tip_percentage) |>
    head() |>
    collect()
toc()

# Grouping & Aggregation ----

## What's the average fare for each month? ----
tic()
nyc |>
    group_by(month) |>
    summarize(
        mean_fare = mean(fare_amount, na.rm = TRUE)
    ) |>
    arrange(month) |>
    collect()
toc()

## What percentage of taxi rides each year had more than 1 passenger? ----
tic()
nyc |>
    filter(year %in% 2017:2021) |>
    group_by(year) |>
    summarize(
        all_trips = n(),
        shared_trips = sum(passenger_count > 1, na.rm = TRUE)
    ) |>
    mutate(pct_shared = shared_trips / all_trips * 100) |>
    collect()
toc()

## What's the most common rate code for each year? ----
tic()
nyc |>
    group_by(year) |>
    count(rate_code) |>
    collect()
toc()

# Joins ----

nyc_taxi_zones <-
    read_csv_arrow(here::here("data/taxi_zone_lookup.csv")) |>
    select(location_id = LocationID,
           borough = Borough)
nyc_taxi_zones

nyc_taxi_zones_arrow <- arrow_table(
    nyc_taxi_zones,
    schema = schema(location_id = int64(), borough = utf8())
)

pickup <- nyc_taxi_zones_arrow |>
    select(pickup_location_id = location_id,
           pickup_borough = borough)

dropoff <- nyc_taxi_zones_arrow |>
    select(dropoff_location_id = location_id,
           dropoff_borough = borough)

tic()
borough_counts <- nyc |>
    left_join(pickup) |>
    left_join(dropoff) |>
    count(pickup_borough, dropoff_borough) |>
    arrange(desc(n)) |>
    collect()
toc()
borough_counts
























# DuckDB
## Window Functions

fare_by_year |>
    group_by(year) |>
    to_duckdb() |>
    mutate(mean_fare = mean(fare_amount)) |>
    to_arrow() |>
    arrange(desc(fare_amount)) |>
    head() |>
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



# functions within arrow
nyc_taxi |>
    mutate(vendor_name = na_if(vendor_name, "CMT")) |>
    head() |>
    collect()

