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
# yes negative numbers?  weird
# will do YeoJohnson because it can handle negatives
# standard log/box-cox is for positive values only

################################################################################
# let's downsample to 25k
set.seed(123)
split_prop <- 25000 / nrow((hotels))
hotels_downsample <- hotels |> 
  initial_split(
    prop = split_prop,
    strata = adr
  )

# extract downsampled data
hotels_small <- hotels_downsample |> training()
# eda dataset
hotels_eda <- hotels_downsample |> testing()

# split the data 
set.seed(9876)
hotels_split <- hotels_small |> 
  initial_split(
    prop = 0.8,
    strata = adr
  )

hotel_train <- hotels_split |> training()
hotel_test  <- hotels_split |> testing()

# get transformation using training set ONLY
recipe_transform <- recipe(adr ~ ., hotel_train) |> 
  step_YeoJohnson(adr)

# get lambda
# we will need this for test data
lambda <- recipe_transform |> 
  prep() |> 
  tidy(1) |> 
  pull(value)

train_transformed <- recipe_transform |> 
  prep() |> 
  bake(new_data = NULL)

# train_transformed |> 
#   select(adr) |> 
#   ggplot(aes(adr)) +
#   geom_density()
# 
# hotel_train |> 
#   select(adr)

# fold the data
set.seed(555)
hotels_fold <- train_transformed |> 
  vfold_cv(
    v = 5,
    repeats = 3,
    strata = adr
  )

# save out training_transformed, testing, folds, and lambda

#################################################################################
# We do our modeling blah blah blah
# now we need to transform our prediction back to the original scale

hotel_test|> 
  select(adr) |>
  mutate(
    # your prediction will be on transformed scale
    adr_transformed = VGAM::yeo.johnson(adr, lambda = lambda),
    # and you will need to invert it back to original scale
    pred_orig = VGAM::yeo.johnson(.pred, lambda = lambda, inverse = TRUE)
  )
  


