#' @title ggtimeline
#' @description Creates timeline from time series data.
#'
#' @param df Dataframe containing time series data
#' @param date_col Name of column containing dates
#' @param title_col Name of column containing timeline data
#' @param color_col Name of column that contains groups to color points
#' @param time_span One of "day", "month", or "year"
#' @param time_space Number of days/months/years between those shown on timeline
#'
#' @return ggplot-based timeline
#' @importFrom dplyr pull
#' @importFrom tibble tibble
#' @importFrom dplyr rename
#' @importFrom dplyr mutate
#' @importFrom magrittr "%>%"
#' @importFrom lubridate ymd
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 aes_string
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_hline
#' @importFrom ggplot2 geom_segment
#' @importFrom ggplot2 geom_text
#' @importFrom lubridate years
#' @importFrom lubridate days
#' @export



ggtimeline <- function(df, date_col, title_col, color_col = NULL,
                       time_span, time_space){


    positions <- c(0.5, -0.5, 1.0, -1.0, 1.25, -1.25, 1.5, -1.5)
    directions <- c(1, -1)

    length_dates <- df %>% pull({{date_col}}) %>% length()

    df2 <- df %>%
      mutate(position = rep(positions, length.out = length_dates),
             direction = rep(directions, length.out = length_dates))


    min_date <- df2 %>% pull({{date_col}}) %>% min()
    max_date <- df2 %>% pull({{date_col}}) %>% max()

    if(time_span == "month"){
      date_range_df <- seq(min_date - months(1),
                           max_date + months(1),
                           by = time_span) %>%
        tibble() %>%
        rename(date_range = ".") %>%
        mutate(date_range = ymd(date_range),
               date_format = format(date_range, '%b  %Y'),
               keep = rep(as.numeric(paste(c(1, rep(0, times = time_space)))),
                          length.out = nrow(.))) %>%
        filter(keep == 1)
    }

    if(time_span == "year"){
      date_range_df <- seq(min_date - years(1),
                           max_date + years(1),
                           by = time_span) %>%
        tibble() %>%
        rename(date_range = ".") %>%
        mutate(date_range = ymd(date_range),
               date_format = format(date_range, '%b  %Y'),
               keep = rep(as.numeric(paste(c(1, rep(0, times = time_space)))),
                          length.out = nrow(.))) %>%
        filter(keep == 1)
    }

    if(time_span == "day"){
      date_range_df <- seq(min_date - days(1),
                           max_date + days(1),
                           by = time_span) %>%
        tibble() %>%
        rename(date_range = ".") %>%
        mutate(date_range = ymd(date_range),
               date_format = format(date_range, '%d  %b  %Y'),
               keep = rep(as.numeric(paste(c(1, rep(0, times = time_space)))),
                          length.out = nrow(.))) %>%
        filter(keep == 1)
    }

    name_date <- df2 %>% select({{date_col}}) %>% colnames()
    title_date <- df2 %>% select({{title_col}}) %>% colnames()


    ggplot(df2, aes_string(x = name_date, y = "position",
                          label = title_date)) +
      geom_point(size=2, aes_string(color = {{color_col}})) +
      geom_hline(yintercept=0, color = "black", size=.8) +
      geom_segment(aes_string(y="position", yend=0,xend=name_date),
                   color='black', size=0.2) +
      geom_text(data = date_range_df, aes_string(label = "date_format", x = "date_range", y = 0, angle = 90),
                size = 2.5, hjust = 0.5, fontface = "bold")
}









#' @export
