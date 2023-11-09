# [Oman R Users] Unlocking Big Data in R Using Arrow

This repository contains the materials for the [meetup on "Unlocking Big Data in R Using Arrow"](https://www.meetup.com/oman-r-user/events/297135613/) I presented to Oman R Users on Nov 8 2023.

## Abstract

Explore the nuances of handling large datasets in R through the Arrow package. This session aims to provide an understanding of Arrow's capabilities, detailing its application in real-world scenarios. It's a package that's not only easy to adopt, but one that will drastically improve your capability to handle massive datasets in R.

## Data Sources

You'll need to download the datasets from the sources and place them in the `data` folder to run the code.

### NYC Taxi Data

- [NYC Taxi and Limousine Commission](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

To replicate the dataset locally, run the following code:

```r
library(arrow)
library(dplyr)

local_folder <- here::here("data/nyc_part")

fs::dir_create(local_folder)

open_dataset("s3://voltrondata-labs-datasets/nyc-taxi") |>
    filter(year %in% 2012:2021) |>
    group_by(year, month) |>
    write_dataset(local_folder)
```
### Airlines Data

Create a folder called `airlines` in the `data` folder.

Download the `Combined_Flights_2021` CSV and parquet files from the [Flight Status Prediction](https://www.kaggle.com/datasets/robikscube/flight-delay-dataset-20182022) dataset from Kaggle.

Links:

1. [CSV file](https://www.kaggle.com/datasets/robikscube/flight-delay-dataset-20182022?select=Combined_Flights_2021.csv)
2. [Parquet file](https://www.kaggle.com/datasets/robikscube/flight-delay-dataset-20182022?select=Combined_Flights_2021.parquet)


## Slides

📽️ The slides are created using quarto, in the `presentation.qmd` file. The slide deck is published on [GitHub pages here](https://rsangole.github.io/oman-rusers-arrow/presentation.html).

## Code

The examples shown in my talk are stored in the `code` folder.