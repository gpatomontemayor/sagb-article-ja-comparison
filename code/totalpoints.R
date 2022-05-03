library(ggplot2)
library(tidyverse)
library(arrow)
library(ggimage)
library(ggthemes)

# Load the data
#df_ai <- read_feather("./code/Rdata/947_cumpts.feather")
#df_west <- read_feather("./code/Rdata/201566_cumpts.feather")
df_drose <- read_feather("./code/Rdata/201565_cumpts.feather")
df_ja <- read_feather("./code/Rdata/1629630_cumpts.feather")

# For the last points
data_ends <- c(as.numeric(df_drose[nrow(df_drose), "PTS"]),
               as.numeric(df_ja[nrow(df_ja), "PTS"])
               #as.numeric(df_west[nrow(df_west), "PTS"]),
               #as.numeric(df_ai[nrow(df_ai), "PTS"])
               )

# Plot
p <- ggplot() +
    # Styling
    theme_fivethirtyeight() +
    theme(axis.title = element_text()) +
    labs(title = "Total Points after First Three Seasons",
         x = "Game number",
         y = "Total Points",
         caption = "Data from: www.basketball-reference.com") +
    scale_y_continuous(sec.axis = sec_axis(~ ., breaks = data_ends)) + 
    # Data from Ja Morant
    geom_step(aes(x = 1:nrow(df_ja), y = df_ja$PTS, color = "Ja Morant"),
              color = "#5D76A9") +
    geom_image(aes(x = nrow(df_ja), y = as.numeric(df_ja[nrow(df_ja), "PTS"]),
                   image = "./images/ja_face.png"), size = .1) +
    # Data from Allen Iverson
    #geom_step(aes(x=1:nrow(df_ai), y=df_ai$PTS, color="Allen Iverson"),
              #color="#006BB6") +
    #geom_image(aes(x=nrow(df_ai), y=as.numeric(df_ai[nrow(df_ai), "PTS"]),
                   #image="./images/ai_face.png"), size=.1) +
    # Data from Derrick Rose
    geom_step(aes(x = 1:nrow(df_drose), y = df_drose$PTS,
                color = "Derrick Rose"),
              color = "#CE1141") +
    geom_image(aes(x = nrow(df_drose),
                   y = as.numeric(df_drose[nrow(df_drose), "PTS"]),
                   image = "./images/drose_face.png"), size = .1) #+
    # Data from Russell Westbrook
    #geom_step(aes(x=1:nrow(df_west), y=df_west$PTS, color="Russell Westbrook"),
              #color="#007AC1") +
    #geom_image(aes(x=nrow(df_west),
                    # y=as.numeric(df_west[nrow(df_west), "PTS"]),
                   # image="./images/russ_face.png"), size=.1)


ggsave("./images/totalpoints.png", plot = p, device = "png", dpi = 800,
        width = 20, height = 22, units = "cm")