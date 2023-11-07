# CSV v Parquet file format ----

# Num Rows: 6.3M Rows

## CSV
## 2.21 GB
tic()
open_csv_dataset(sources = "data/airlines/Combined_Flights_2021.csv") |>
    count(DestState) |>
    collect()
toc()

## Parquet
## 243 MB (10%!)
tic()
open_dataset(sources = "data/airlines/Combined_Flights_2021.parquet") |>
    count(DestState) |>
    collect()
toc()


tic()
open_csv_dataset(sources = "data/airlines/Combined_Flights_2021.csv") |>
    group_by(DestState) |>
    summarise(mean(Distance)) |>
    collect()
toc()


tic()
open_dataset(sources = "data/airlines/Combined_Flights_2021.parquet") |>
    group_by(DestState) |>
    summarise(mean(Distance)) |>
    collect()
toc()

# partitioning ----

years <- nyc |> distinct(year) |> collect() |> pull()
years

# for(.y in years){
#     nyc |>
#         filter(year == .y) |>
#         group_by(year, month, vendor_name) |>
#         write_dataset("data/nyc_part_vendor")
# }

nyc_vend <- open_dataset("data/nyc_part_vendor/")

## Examples where a partition won't matter/make things worse ----
# 1....
tic()
nyc |>
    group_by(year, month, vendor_name) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    collect()
toc()

tic()
nyc_vend |>
    group_by(year, month, vendor_name) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    collect()
toc()

# 2...
tic()
nyc |>
    filter(rate_code == 'Newark') |>
    count(passenger_count) |>
    collect()
toc()

tic()
nyc_vend |>
    filter(rate_code == 'Newark') |>
    count(passenger_count) |>
    collect()
toc()

## Examples where a partition will matter ----
# 1...
tic()
nyc |>
    filter(vendor_name == "CMT") |>
    group_by(year, month, vendor_name) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    collect()
toc()

tic()
nyc_vend |>
    filter(vendor_name == "CMT") |>
    group_by(year, month, vendor_name) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    collect()
toc()

# 2...
tic()
nyc |>
    filter(vendor_name == 'VTS') |>
    group_by(year) |>
    summarize(mean(tip_amount)) |>
    collect()
toc()

tic()
nyc_vend |>
    filter(vendor_name == 'VTS') |>
    group_by(year) |>
    summarize(mean(tip_amount)) |>
    collect()
toc()