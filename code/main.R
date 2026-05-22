#### Řídící skript ####

## Encoding: UTF-8

## Inspirace -- balíčky:
# package na LLM API
# install.packages("ellmer")
# install.packages("remotes")
# remotes::install_github("RE-QDA/requal")
# install.packages("requal",
#     repos = c("https://re-qda.r-universe.dev", "https://cloud.r-project.org"))


# Hlavička ---------------------------------------------------------------

rm(list = ls())

library(tidyverse)
library(readxl)
library(haven)


# Hlavní sekvence --------------------------------------------------------

source("code/d_data.R", encoding = "UTF-8")

source("code/a_results.R", encoding = "UTF-8", echo = TRUE)
