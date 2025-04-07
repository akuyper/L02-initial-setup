# Regression: Downsample large data
# And learn to transform the outcome variable

################################################################################
# Suppose we are interested in predicting the
# average daily rate of a hotel stay

# load packages
library(tidyverse)
library(tidymodels)
library(themis)

# Load dataset
hotels <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2020/2020-02-11/hotels.csv')

################################################################################
# check the distribution 
# adr = average daily rate
ggplot(hotels, aes(adr)) +
  geom_density()

range(hotels$adr)

################################################################################
# let's downsample to 25k



# fold the data

# save out training_transformed, testing, folds, and lambda

#################################################################################
# We do our modeling blah blah blah
# now we need to transform our prediction back to the original scale

