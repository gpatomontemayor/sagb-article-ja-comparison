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
                        position = position_dodge(width = .2)) +
        geom_point(size = 5,
        position = position_dodge(width = .2)) +
        theme_fivethirtyeight() +
        theme(axis.title = element_text()) +
        scale_color_manual(values = c("Derrick Rose" = "#CE1141",
                                        "Ja Morant" = "#5D76A9")) +
        labs(
            title = paste("Evolution of",
                            tit,
                            "per 100 posessions",
                            sep = " "),
            caption = "Data from NBA.com",
            x = "Season", y = str_to_title(axis), color = "")

    ggsave(paste("./images/", str_to_lower(axis), ".png", sep = ""),
            device = "png", dpi = 800)
}

create_graph(stats$DefRtg, tit = "Defensive Rating", axis = "DefRtg")
