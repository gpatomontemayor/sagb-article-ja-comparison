library(tidyverse)
library(gt)
library(webshot)

# Data collected into a dataframe
ja <- c("2019", "2", "Grizzlies", "6’3’’  - 1.91 m",
        "174lb - 79 Kg", "6’7’’ - 2 m", "44’’ - 1.12 m")
drose <- c("2008", "1", "Bulls", "6’2” - 1.88 m",
            "200lb - 91kg", "6’8’’ - 2.03 m", "40’’ - 1.01 m")
row_names <- c("Draft Class", "Draft Pick", "Team", "Height", "Weight",
                "Wingspan", "Vertical")
df <- data.frame(row_names, drose, ja)

# Theme from gt_themes
gt_theme_538 <- function(data, ...) {
  data %>%
  opt_all_caps()  %>%
  opt_table_font(
    font = list(
      google_font("Chivo"),
      default_fonts()
    )
  ) %>%
    tab_style(
      style = cell_borders(
        sides = "bottom", color = "transparent", weight = px(2)
      ),
      locations = cells_body(
        columns = TRUE,
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(data$`_data`)
      )
    )  %>% 
  tab_options(
    column_labels.background.color = "white",
    table.border.top.width = px(3),
    table.border.top.color = "transparent",
    table.border.bottom.color = "transparent",
    table.border.bottom.width = px(3),
    column_labels.border.top.width = px(3),
    column_labels.border.top.color = "transparent",
    column_labels.border.bottom.width = px(3),
    column_labels.border.bottom.color = "black",
    data_row.padding = px(3),
    source_notes.font.size = 12,
    table.font.size = 16,
    heading.align = "left",
    ...
  ) 
}

# Create table
df %>%
    gt(rowname_col = row_names) %>%
    gt_theme_538() %>%
    # Add images as column labels
    cols_label(row_names = "",
                ja = html("<img src=https://cdn.nba.com/headshots/nba/latest/1040x760/1629630.png style='width:120px;'> Ja Morant"),
                drose = html("<img src=https://cdn.nba.com/headshots/nba/latest/1040x760/201565.png style='width:120px;'> Derrick Rose")) %>%
    opt_row_striping() %>%
    cols_width(row_names ~ px(90),
                drose ~ px(120),
                ja ~ px(120)) %>%
    cols_align(align = "right", columns = c(ja, drose)) %>%
    gtsave("./images/comparison_table.png")
