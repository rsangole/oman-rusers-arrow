# Using Custom Functions within arrow ----

## User Defined Function
## Clean up strings ----
register_scalar_function(

    # What should we call the function?
    name = "clean_me",

    # Define the function
    # context must be the first argument
    fun = function(context, var){
        stringr::str_to_lower(var) |>
            stringr::str_replace_all(" ", "_")
    },

    # Schemas of input and output
    in_type = schema(var = utf8()),
    out_type = utf8(),

    # Required to use in a dplyr pipeline
    auto_convert = TRUE
)

## Solution ----
tic()
nyc |>
    filter(year == 2019, month == 1) |>
    mutate(clean_rate_code = clean_me(rate_code)) |>
    select(contains('rate_code')) |>
    collect()
toc()