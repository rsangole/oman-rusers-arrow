# Verbs



# Joins



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



library(tictoc)

tic()
borough_counts <- nyc_taxi |>
    left_join(pickup) |>
    left_join(dropoff) |>
    count(pickup_borough, dropoff_borough) |>
    arrange(desc(n)) |>
    collect()
toc()



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


# UDFs


# Write a user-defined function which wraps the stringr function
# str_replace_na(), and use it to replace any NA values in the vendor_name
# column with the string “No vendor” instead. (Test it on the data from 2019 so
# you’re not pulling everything into memory)

register_scalar_function(
    name = "replace_vendor_na",
    function(context, string) {
        stringr::str_replace_na(string, "No vendor")
    },
    in_type = schema(string = string()),
    out_type = string(),
    auto_convert = TRUE
)

vendor_names_fixed <- nyc_taxi |>
    mutate(vendor_name = replace_vendor_na(vendor_name))

# Preview the distinct vendor names to check it's worked
vendor_names_fixed |>
    filter(year == 2019) |> # smaller subset of the data
    distinct(vendor_name) |>
    collect()