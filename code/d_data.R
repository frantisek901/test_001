#### Skript pro základní načtení dat ####

## Encoding: UTF-8

# Kultura ----------------------------------------------------------------

tko <- read_sav(
    "data/kult_orig/Kult2012_3kraje_UstVysZli_CSDA_pub_nove_bez_jmen.sav") |>
  as_factor() 
  

tks <- read_csv(
    "data/kult_synth/Diffusion_synthetic_n10000.csv"
)
