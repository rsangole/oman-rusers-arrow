# (Slide review)

# Pivoting ----
library(tidyr)

# [A] Problem ----
nyc |>
    group_by(rate_code) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    head() |>
    collect()

nyc |>
    group_by(rate_code) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    pivot_wider(names_from = 'rate_code', values_from = 'max_trip_dist')

# [B] Solution ----
library(duckdb)
nyc |>
    group_by(rate_code) |>
    summarise(max_trip_dist = max(trip_distance)) |>
    to_duckdb() |>
    pivot_wider(names_from = 'rate_code', values_from = 'max_trip_dist') |>
    to_arrow() |>
    collect()

# Mutate On Group By ----

# [A] Problem ----
nyc |>
    filter(year > 2020) |>
    select(year, contains('datetime'), total_amount) |>
    group_by(year) |>
    mutate(yearly_totals = sum(total_amount))


# [B] Solution ----
tic()
nyc |>
    filter(year > 2020) |>
    select(year, contains('amount')) |>
    group_by(year) |>
    to_duckdb() |>
    mutate(yearly_total_amt = sum(total_amount)) |>
    to_arrow() |>
    collect()
toc()

# Sql Query ----

nyc |>
    to_duckdb() |>
    filter(year %in% c(2018, 2020)) |>
    select(year, contains('datetime'), contains('rate'), contains('amount')) |>
    group_by(year) |>
    mutate(yearly_total_amt = sum(total_amount)) |>
    ungroup() |>
    mutate(tip_pc = tip_amount / total_amount,
           duration = dropoff_datetime - pickup_datetime) |>
    show_query()
