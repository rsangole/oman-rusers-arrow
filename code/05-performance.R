# (Slide review)

# CSV v Parquet file format ----

# Airlines Dataset, Flights in 2021: 6.3M Rows

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
toc() #30x faster!


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
toc() #30x faster!

# partitioning ----

# to create the vendor partitioned dataset... ----
# years <- nyc |> distinct(year) |> collect() |> pull()
# years
# for(.y in years){
#     nyc |>
#         filter(year == .y) |>
#         group_by(year, month, vendor_name) |>
#         write_dataset("data/nyc_part_vendor")
# }

# connect to vendor partitioned data ----
nyc_vend <- open_dataset("data/nyc_part_vendor/")

## Example where a partition won't matter/make things worse ----
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

## Example where a partition will matter ----
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
toc() # 2x gain


## {head to recap}