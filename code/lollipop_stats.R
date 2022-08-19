library(ggplot2)
library(tidyverse)
library(ggthemes)
library(arrow)

# Load data for stats
stats <- read_feather("./code/Rdata/stats.feather")

# Use numeric as character for categorical variables
stats$SEASON <- as.character(stats$SEASON)

# Wrapper function to create plots
create_graph <- function(stat, tit, axis) {
    ggplot(stats, aes(x = SEASON, y = stat, color = PLAYER)) +
        # Geoms
        geom_linerange(aes(xmin = SEASON, xmax = SEASON,
                        ymin = 0, ymax = stat),
                        position = position_dodge(width = .2),
                        size = 1) +
        geom_point(size = 5,
        position = position_dodge(width = .2)) +
        # Theme specific
        theme_fivethirtyeight() +
        theme(axis.title = element_text(size = 20),
            axis.text = element_text(size = 20),
            plot.title = element_text(size = 25),
            legend.text = element_text(size = 20),
            plot.caption = element_text(size = 20)) +
        # Coloring with default team colors
        scale_color_manual(values = c("Derrick Rose" = "#CE1141",
                                        "Ja Morant" = "#5D76A9")) +
        # Caption labels
        labs(
            title = paste(tit),
            caption = "Data from nba.com",
            x = "Season", y = str_to_title(axis), color = "") +
        scale_x_discrete(limits = c("1", "2", "3"))

    ggsave(paste("./images/", str_to_lower(axis), ".png", sep = ""),
            device = "png", dpi = 800)
}

create_graph(stats$TOV, tit = "Turnovers", axis = "Turnovers")
