#### Řídící skript ####

## Encoding: UTF-8

# Hlavička ---------------------------------------------------------------

rm(list = ls())

library(tidyverse)
library(readxl)
library(haven)


# Hlavní sekvence --------------------------------------------------------

source("code/d_data.R", encoding = "UTF-8")

source("code/a_results.R", encoding = "UTF-8", echo = TRUE)
