# Data Manipulation ----
query <- nyc |>
    filter(year == 2019) |>
    select(fare_amount, passenger_count)
query

class(query)

schema(query)

# Collecting results ----
tic()
query |>
    collect() # execute the query!
toc()

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
toc()

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
    arrange(year, -month) |>
    collect()
toc()

tic()
nyc |>
    distinct(vendor_name) |>
    collect()
toc()

# Mutating columns ----
## Simple mutation ----
tic()
nyc |>
    filter(year == 2019) |>
    mutate(tip_percentage = tip_amount / fare_amount * 100) |>
    select(fare_amount, tip_amount, tip_percentage) |>
    collect()
toc()

## Using across ----
USD_TO_OMR <- 0.39
tic()
nyc |>
    mutate(across(ends_with("amount"),
                  list('omr' = ~.x * USD_TO_OMR))) |>
    select(contains('amount')) |>
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
## What are the counts of rides for each pickup-dropoff combination? ----
nyc_taxi_zones <-
    read_csv_arrow(here::here("data/taxi_zone_lookup.csv")) |>
    select(location_id = LocationID,
           borough = Borough)
nyc_taxi_zones

# borough := a district

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

# solution ----
#
# 91.747 sec elapsed
#
# > borough_counts
# # A tibble: 50 × 3
# pickup_borough dropoff_borough         n
# <chr>          <chr>               <int>
#     1 NA             NA              732357953
# 2 Manhattan      Manhattan       351198872
# 3 Queens         Manhattan        14440705
# 4 Manhattan      Queens           13052517
# 5 Manhattan      Brooklyn         11180867
# 6 Queens         Queens            7440356
# 7 Unknown        Unknown           4491811
# 8 Queens         Brooklyn          3662324
# 9 Brooklyn       Brooklyn          3550480
# 10 Manhattan      Bronx             2071830
# # ℹ 40 more rows
# # ℹ Use `print(n = ...)` to see more rows