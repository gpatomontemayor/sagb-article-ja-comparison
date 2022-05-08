library(ggplot2)
library(tidyverse)
library(ggthemes)
library(arrow)

stats <- read_feather("./code/Rdata/stats.feather")

stats$SEASON <- as.character(stats$SEASON)

create_graph <- function(stat, tit, axis) {
    ggplot(stats, aes(x = SEASON, y = stat, color = PLAYER)) +
        geom_linerange(aes(xmin = SEASON, xmax = SEASON,
                        ymin = 0, ymax = stat),
                        position = position_dodge(width = .2),
                        size = 2) +
        geom_point(size = 7,
        position = position_dodge(width = .2)) +
        theme_fivethirtyeight() +
        theme(axis.title = element_text(size = 30),
            axis.text = element_text(size = 30),
            plot.title = element_text(size = 35),
            legend.text = element_text(size = 30),
            plot.caption = element_text(size = 20),
            panel.grid.major = element_line(size = 1)) +
        scale_color_manual(values = c("Derrick Rose" = "#CE1141",
                                        "Ja Morant" = "#5D76A9")) +
        labs(
            title = paste(tit),
            caption = "Data from nba.com",
            x = "Season", y = str_to_title(axis), color = "") +
        scale_x_discrete(limits = c("1","2","3"))

    ggsave(paste("./images/", str_to_lower(axis), ".png", sep = ""),
            device = "png", dpi = 800)
}

create_graph(stats$TOV, tit = "Turnovers", axis = "Turnovers")
