## Classification - upsample to balance classes

# Check the class ratio; 
# Under 10:1 it *might* not be essential.
################################################################################
# Suppose we are interested in predicting whether 
# an individual died when climbing Mt. Everest.

# Load packages
library(tidyverse)
library(tidymodels)
library(themis)

# Load dataset
members <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2020/2020-09-22/members.csv') |> 
  filter(peak_name == "Everest") |> 
  mutate(across(where(is.logical), as.factor))

##########################################################
# check the distribution
ggplot(members, aes(died)) +
  geom_bar()

members |>
  count(died)

# What is the ratio?

##########################################################
# What is upsampling?

##########################################################
# Upsample the *training* data

