## Classification - downsampling to balance classes

# Check the class ratio; 
# Under 10:1 it *might* not be essential.
################################################################################
# Suppose we are interested in predicting which
# hotel stays include children (vs. do not include children/babies)

# Load packages
library(tidyverse)
library(tidymodels)
library(themis)

# Load dataset
hotels <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2020/2020-02-11/hotels.csv')

# clean dataset
hotel_stays <- hotels |> 
  filter(is_canceled == 0) |> 
  mutate(
    children = case_when(
      children + babies > 0 ~ "children",
      TRUE ~ "none"
    ),
    required_car_parking_spaces = case_when(
      required_car_parking_spaces > 0 ~ "parking",
      TRUE ~ "none"
    )
  ) |> 
  select(-is_canceled, -reservation_status, -babies)

################################################################################
# check the distribution
ggplot(hotel_stays, aes(children)) +
  geom_bar()

hotel_stays |>
  count(children)

# What is the ratio?

##########################################################
# What is downsampling?

##########################################################
# downsample the majority class

