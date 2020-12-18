# ggtimeline

ggtimeline allows you to create static timeline charts from time series data based on ggplot2 syntax. 

## Getting Started

We'll use some data from the New York Times API as an example. We'll pull the last 10 results related to artificial intelligence:
```
nyt_data <- GET(paste0("https://api.nytimes.com/svc/search/v2/articlesearch.json?q=artificial%20intelligence&api-key=", Sys.getenv("NYT_KEY"))) %>%
    content(as = "text") %>%
    fromJSON(simplifyDataFrame = TRUE)

nyt_data2 <- nyt_data$response$docs

headlines <- nyt_data2$headline %>% select(main)
    
nyt_data3 <- nyt_data2 %>% 
    janitor::clean_names() %>% 
    bind_cols(headlines) %>% 
    mutate(pub_date = as.Date(lubridate::ymd_hms(pub_date)),
           abstract = str_wrap(abstract, 20),
           main_headline = str_wrap(main, 20)) %>% 
    arrange(desc(pub_date))
```
Note that it is highly recommended to use `lubridate` to edit your date column. I also edit the abstract and main headline columns with `stringr::str_wrap` so that the text for each timeline point can fit in the timeline.


```
ggtimeline(nyt_data4, date_col = "pub_date", title_col = "main_headline", color_col = "news_desk", time_span = "day", time_space = 5) +
    ggrepel::geom_text_repel(size = 3, vjust = 1) +
    theme_classic() +
    theme(axis.line.y=element_blank(),
          axis.text.y=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          axis.ticks.y=element_blank(),
          axis.text.x =element_blank(),
          axis.ticks.x =element_blank(),
          axis.line.x =element_blank(),
          legend.position = "bottom")
```

![](https://github.com/cgpeltier/ggtimeline/blob/master/images/ggtimeline_ex1.png?raw=true)

ggtimeline requires you to specify the columns in your dataframe related to the date (date_col), the title (title_col, the text that will actually be in your timeline). Specifying a column that contains groups for timeline point colors is optional. 

The time_span argument must be one of c("day", "month", "year"), while the time_space argument specifies the number of days, months, or years that aren't shown in between the days/months/years that are shown in the timeline. 

Because this is based on ggplot2, you can add additional formatting changes with "+", just like you'd do for other ggplot visualizations.


