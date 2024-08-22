# Load packages
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(tidyverse)
library(tidycensus)
library(mapgl)
library(plotly)

# Set codes for a couple variables of interest (use tidycensus::load_variables())
income <- "B19013_001"
age <- "B01002_001"

# Extract a data set to use
dat <- 
  get_acs(
    geography = "tract",
    variables = 
      c(
        income, # Median income
        age # Median age
      ),
    state = "WI",
    county = "Marathon",
    year = 2022,
    geometry = TRUE
  )


# Make a plot
rel_plot <-
  dat |>
  
  # Convert to simple tibble
  as_tibble() |>
  
  # Make names
  mutate(
    Tract = str_remove(NAME, ";.+$"),
    Label = 
      case_when(
        variable == age ~ "Age",
        TRUE ~ "Income"
      )
  ) |>
  
  # Send over the columns
  pivot_wider(
    names_from = Label,
    values_from = estimate,
    id_cols = Tract
  ) |>
  
  # Reorder
  arrange(
    Age,
    Income
  ) |>
  
  # Make a plot
  plot_ly(
    x = ~Age,
    y = ~Income,
    size = 2,
    line = list(width = 1, color = "black"),
    type = "scatter",
    mode = "lines+markers",
    text = 
      ~paste0(
        Tract,
        "<br>Median Age: ", round(Age), " years",
        "<br>Median Income: $", round(Income)
      ),
    hovertemplate = "%{text}"
  ) |>
  layout(
    xaxis = list(title = "Median Age (years)"),
    yaxis = list(title = "Median Income ($)", tickformat = "$")
  )