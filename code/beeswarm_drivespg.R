library(ggplot2)
library(tidyverse)
library(arrow)
library(ggbeeswarm)
library(ggthemes)
library(ggrepel)
library(gifski)
library(gganimate)

# Load data
df <- read_feather("./code/Rdata/drivespg.feather")
ja <- filter(df, Player == "Ja Morant")

p <- ggplot(data = df, aes(x = X, y = DRIVES, col = BIN)) +
  theme_fivethirtyeight() +
  theme(axis.title.x = element_text()) +
  # gganimate specific bits
  labs(title = "Drives per game during the {closest_state} season",
       y = "Drives per game",
       caption = "Only guards with at least 30 games played\n
       Data from: www.nba.com") +
  transition_states(YEAR, state_length = 2) +
  # Plot
  geom_beeswarm(size = 3, cex = 2, show.legend = FALSE) +
  scale_color_manual(values = c("LOW" = "#cc3300",
                              "MEDIUM" = "#ffcc00",
                              "HIGH" = "#339900")) +
  coord_flip() +
  geom_text_repel(data = ja, aes(x = X, y = DRIVES, label = Player),
                  color = "Black",
                  show.legend = FALSE,
                  point.padding = unit(0.25, "lines"),
                  box.padding = unit(0.25, "lines"),
                  nudge_x = .2)
animate(p, nframes = 50, renderer = gifski_renderer("./images/drivespg.gif"))