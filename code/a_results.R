#### Skript na produkci výsledků ####

## Encoding: UTF-8

# Kultura ----------------------------------------------------------------

# Funkce na grafy
do_graph <- function(
  data = tko,
  varY = "KRAJ",
  varX = "K.2",
  title_prefix = "Original"
) {
  tg <- tibble(var1 = data[[varY]], var2 = data[[varX]])

  fig_title <- paste0(title_prefix, ": ", attr(tg$var2, "label"))
  fig_name <- paste(varX, title_prefix, sep = "_")

  tx <- tg |>
    mutate(across(where(is.factor), as.character)) |>
    count(var1, var2) |>
    drop_na() |>
    group_by(var1) |>
    mutate(p = round(n / sum(n) * 100, 1))

  g <- tx |>
    arrange(var1, var2) |>
    ggplot() +
    aes(y = var1, x = p, fill = var2, label = round(p)) +
    geom_col(position = position_fill(reverse = T)) +
    geom_text(position = position_fill(vjust = 0.5, reverse = T)) +
    scale_fill_viridis_d() +
    scale_x_continuous(labels = function(x) x * 100) +
    labs(
      y = "",
      x = "%",
      title = fig_title
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      legend.title = element_blank()
    )

  ggsave(
    plot = g,
    file = paste0("figs/", fig_name, ".png"),
    width = 3200,
    height = 900,
    unit = "px"
  )

  g
}

# Original grafy
walk(
  list("K.2", "K.4", "K.9", "K.11", "K.27", "K.33c"), 
  ~do_graph(title_prefix = "Original", data = tko, varX = .x))

walk(
    list("K.2", "K.4", "K.9", "K.11", "K.27", "K.33c"), 
    ~do_graph(title_prefix = "Synthetic", data = tks, varX = .x))



# Zachycení stejných názvů/ proměných ------------------------------------

names(tpo)[names(tpo) %in% names(tps)]



# Regrese PIAAC ----------------------------------------------------------

xtps <- tps |>
  select(ICTWORKC2, ICTHOMEC2, WRITWORKC2, WRITHOMEC2, NUMWORKC2, NUMHOMEC2)
xtpo <- tpo |>
  select(ICTWORKC2, ICTHOMEC2, WRITWORKC2, WRITHOMEC2, NUMWORKC2, NUMHOMEC2) |>
  mutate(across(where(is.factor), ~ as.character(.x) |> as.numeric()))

lm(ICTWORKC2 ~ WRITWORKC2 + WRITHOMEC2 + NUMWORKC2 + NUMHOMEC2, data = xtps) |>
  summary()
lm(ICTWORKC2 ~ WRITWORKC2 + WRITHOMEC2 + NUMWORKC2 + NUMHOMEC2, data = xtpo) |>
  summary()


lm(ICTHOMEC2 ~ WRITWORKC2 + WRITHOMEC2 + NUMWORKC2 + NUMHOMEC2, data = xtps) |>
  summary()
lm(ICTHOMEC2 ~ WRITWORKC2 + WRITHOMEC2 + NUMWORKC2 + NUMHOMEC2, data = xtpo) |>
  summary()
