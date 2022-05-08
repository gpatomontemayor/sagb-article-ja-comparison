# Most of the code is from @DSamangy and @Owenlhjphillips

library(tidyverse)
library(ggplot2)
library(arrow)
library(ggthemes)

circle_points <- function(center = c(0, 0), radius = 1, npoints = 360) {
  angles <- seq(0, 2 * pi, length.out = npoints)
  return(data_frame(x = center[1] + radius * cos(angles),
                    y = center[2] + radius * sin(angles)))
}

width <- 50
height <- 94 / 2
key_height <- 19
inner_key_width <- 12
outer_key_width <- 16
backboard_width <- 6
backboard_offset <- 4
neck_length <- 0.5
hoop_radius <- 0.75
hoop_center_y <- backboard_offset + neck_length + hoop_radius
three_point_radius <- 23.75
three_point_side_radius <- 22
three_point_side_height <- 14

court_themes <- list(
  light = list(
    court = "white",
    lines = "#999999",
    text = "#222222",
    made = "#00bfc4",
    missed = "#f8766d",
    hex_border_size = 1,
    hex_color = "#000000"
  ),
  dark = list(
    court = "#000004",
    lines = "#999999",
    text = "#f0f0f0",
    made = "#00bfc4",
    missed = "#f8766d",
    hex_border_size = 0,
    hex_color = "#000000"
  ),
  fivethirtyeight = list(
    court = "white",
    lines = "black",
    text = "#F0F0F0",
    made = "#cc3300",
    missed = "#cc3300",
    hex_border_size = 0,
    hex_color = "#000000"
  )
)


plot_court <- function(court_theme = court_themes$light,
                        use_short_three = FALSE) {
  # To draw the court
  if (use_short_three) {
    three_point_radius <- 22
    three_point_side_height <- 0
  }

  court_points <- data_frame(
    x = c(width / 2, width / 2, -width / 2, -width / 2, width / 2),
    y = c(height, 0, 0, height, height),
    desc = "perimeter"
  )

  court_points <- bind_rows(court_points, data_frame(
    x = c(outer_key_width / 2, outer_key_width / 2,
        -outer_key_width / 2, -outer_key_width / 2),
    y = c(0, key_height, key_height, 0),
    desc = "outer_key"
  ))

  court_points <- bind_rows(court_points, data_frame(
    x = c(-backboard_width / 2, backboard_width / 2),
    y = c(backboard_offset, backboard_offset),
    desc = "backboard"
  ))

  court_points <- bind_rows(court_points, data_frame(
    x = c(0, 0), y = c(backboard_offset, backboard_offset + neck_length),
    desc = "neck"
  ))

  foul_circle <- circle_points(center = c(0, key_height),
                                radius = inner_key_width / 2)

  foul_circle_top <- filter(foul_circle, y > key_height) %>%
    mutate(desc = "foul_circle_top")

  foul_circle_bottom <- filter(foul_circle, y < key_height) %>%
    mutate(
      angle = atan((y - key_height) / x) * 180 / pi,
      angle_group = floor((angle - 5.625) / 11.25),
      desc = paste0("foul_circle_bottom_", angle_group)
    ) %>%
    filter(angle_group %% 2 == 0) %>%
    select(x, y, desc)

  hoop <- circle_points(center = c(0, hoop_center_y), radius = hoop_radius) %>%
    mutate(desc = "hoop")

  restricted <- circle_points(center = c(0, hoop_center_y), radius = 4) %>%
    filter(y >= hoop_center_y) %>%
    mutate(desc = "restricted")

  three_point_circle <- circle_points(center = c(0, hoop_center_y),
                                        radius = three_point_radius) %>%
    filter(y >= three_point_side_height, y >= hoop_center_y)

  three_point_line <- data_frame(
    x = c(three_point_side_radius, three_point_side_radius,
        three_point_circle$x, -three_point_side_radius,
        -three_point_side_radius),
    y = c(0, three_point_side_height, three_point_circle$y,
        three_point_side_height, 0),
    desc = "three_point_line"
  )

  court_points <- bind_rows(
    court_points,
    foul_circle_top,
    foul_circle_bottom,
    hoop,
    restricted,
    three_point_line
  )


  court_points <- court_points

  ggplot() +
    geom_path(
      data = court_points,
      aes(x = x, y = y, group = desc),
      color = court_theme$lines
    ) +
    coord_fixed(ylim = c(0, 45), xlim = c(-25, 25)) +
    theme(
      plot.background = element_rect(fill = "white", color = "white"),
      panel.background = element_rect(fill = court_theme$court,
                                      color = court_theme$court),
      panel.grid = element_blank(),
      panel.border = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.background = element_rect(fill = court_theme$court,
                                      color = court_theme$court),
      legend.margin = margin(-1, 0, 0, 0, unit = "lines"),
      legend.position = "bottom",
      legend.key = element_blank(),
      legend.text = element_text(size = rel(1.0))
    )
}

shotchart <- function(pid) {
  # Wrapper to create shot charts
  players <- data.frame(pids = c(1629630, 201565, 201566, 947),
                          names = c("Ja Morant", "Derrick Rose",
                          "Russell Westbrook", "Allen Iverson"))
  name <- filter(players, players$pids == pid)$names
  df <- read_feather(paste("./code/Rdata/", as.character(pid),
                           "_allshots.feather", sep = ""))

  df$loc_x <- as.numeric(as.character(df$LOC_X))
  df$loc_y <- as.numeric(as.character(df$LOC_Y))

  df <- df %>% filter(LOC_Y < 400) %>%
        mutate(loc_x = as.numeric(as.character(loc_x)) / 10,
          loc_y = as.numeric(as.character(loc_y)) / 10 + hoop_center_y)



  p <- plot_court(court_theme = court_themes$fivethirtyeight) +
    theme_fivethirtyeight() +
    geom_point(data = df,
              mapping = aes(x = loc_x, y = loc_y, color = EVENT_TYPE,
                          fill = EVENT_TYPE), alpha = .2) +
    scale_fill_manual(values = c("#99cc33", "#ff9966"),
                      breaks = c("Made Shot", "Missed Shot")) +
    scale_color_manual(values = c("#339900", "#cc3300"),
                      breaks = c("Made Shot", "Missed Shot")) +
    scale_x_continuous(limits = c(-25, 25)) +
    scale_y_continuous(limits = c(0, 45)) +
    theme(legend.title = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid.major = element_blank(),
          legend.text = element_text(size = 15),
          plot.title = element_text(size = 25),
          plot.subtitle = element_text(size = 15)
    ) +
    labs(title = name,
        subtitle = "Shots from first three seasons",
        caption = "Data from nba.com")

  ggsave(paste("./images/shotchart_", as.character(pid), ".png", sep = ""),
        plot = p, device = "png", dpi = 800, width = 20, height = 22,
        units = "cm")
}

shotchart(pid = 1629630)
