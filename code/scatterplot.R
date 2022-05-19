library(ggplot2)
library(arrow)
library(tidyverse)
library(ggthemes)

df <- read_feather("./code/Rdata/2021-22.feather")
ja <- filter(df, df$PLAYER == "Ja Morant")
df2 <- read_feather("./code/Rdata/2010-11.feather")
rose <- filter(df2, df2$PLAYER == "Derrick Rose")

ggplot(df2, aes(x = PTS, y = pctPTS2PT)) +
    theme_fivethirtyeight() +
    theme(
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 25),
        axis.text = element_text(size = 15),
       plot.caption = element_text(size = 15)
    ) +
    geom_point(color = "Black", size = 4) +
    geom_point(data = rose, mapping = aes(x = PTS, y = pctPTS2PT),
                color = "#CE1141", fill = "#CE1141", size = 4) +
    geom_vline(xintercept = mean(df2$PTS), linetype = "dashed") +
    geom_hline(yintercept = mean(df2$pctPTS2PT), linetype = "dashed") +
    labs(title = "2010-11",
        x = "PTS/100pos",
        y = "%PTS scored from 2-pointers") +
    xlim(8, 41) + ylim(11, 92)

ggsave("./images/2010-11PTSvpctPTS2v2.png",
        device = "png", dpi = 800)

ggplot(df, aes(x = PTS, y = pctPTS2PT)) +
    theme_fivethirtyeight() + 
    theme(
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 25),
        axis.text = element_text(size = 15),
        plot.caption = element_text(size = 15)
    ) +
    geom_point(color = "Black", size = 4) +
    geom_point(data = ja, mapping = aes(x = PTS, y = pctPTS2PT),
                color = "#5D76A9", fill = "#5D76A9", size = 4) +
    geom_vline(xintercept = mean(df$PTS), linetype = "dashed") +
    geom_hline(yintercept = mean(df$pctPTS2PT), linetype = "dashed") +
    labs(title = "2021-22",
        x = "PTS/100pos",
        y = "%PTS scored from 2-pointers") +
    xlim(8, 41) + ylim(11, 92)
    
ggsave("./images/2021-22PTSvpctPTS2v2.png",
        device = "png", dpi = 800)

ggplot(df2, aes(x = FGMpctUAST, y = pctPTS2PT)) +
    theme_fivethirtyeight() +
    theme(
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 25),
        axis.text = element_text(size = 15),
        plot.caption = element_text(size = 15)
    ) +
    geom_point(color = "Black", size = 4) +
    geom_point(data = rose, mapping = aes(x = FGMpctUAST, y = pctPTS2PT),
                color = "#CE1141", fill = "#CE1141", size = 4) +
    geom_vline(xintercept = mean(df2$FGMpctUAST), linetype = "dashed") +
    geom_hline(yintercept = mean(df2$pctPTS2PT), linetype = "dashed") +
    labs(title = "2010-11",
        x = "%Unassisted FGM",
        y = "%PTS scored from 2-pointers") +
    xlim(0, 92) + ylim(11, 92)

ggsave("./images/2010-11FGMpctUASTvpctPTS2v2.png",
        device = "png", dpi = 800)

ggplot(df, aes(x = FGMpctUAST, y = pctPTS2PT)) +
    theme_fivethirtyeight() + 
    theme(
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 25),
        axis.text = element_text(size = 15),
        plot.caption = element_text(size = 15)
    ) +
    geom_point(color = "Black", size = 4) +
    geom_point(data = ja, mapping = aes(x = FGMpctUAST, y = pctPTS2PT),
                color = "#5D76A9", fill = "#5D76A9", size = 4) +
    geom_vline(xintercept = mean(df$FGMpctUAST), linetype = "dashed") +
    geom_hline(yintercept = mean(df$pctPTS2PT), linetype = "dashed") +
    labs(title = "2021-22",
        x = "%Unassisted FGM",
        y = "%PTS scored from 2-pointers") +
    xlim(0, 92) + ylim(11, 92)
    
ggsave("./images/2021-22FGMpctUASTvpctPTS2v2.png",
        device = "png", dpi = 800)