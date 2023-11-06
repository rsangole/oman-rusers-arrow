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




# pivot
library(duckdb)

nyc_taxi |>
    group_by(vendor_name) |>
    summarise(max_fare = max(fare_amount)) |>
    to_duckdb() |> # send data to duckdb
    pivot_longer(!vendor_name, names_to = "metric") |>
    to_arrow() |> # return data back to arrow
    collect()

