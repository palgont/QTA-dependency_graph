# Author: Palgon Tsering
# CLS181: Quantitative Textual Analysis
# Purpose: Collect Federal Reserve Corpus with customized web scraper

#packages
cran_pkgs <- c("tidyquant",
               "tidyverse",
               "ggplot2",
               "jsonlite")

install.packages(cran_pkgs)

#libraries
library(tidyverse)
library(tidyquant)
library(ggplot2)
library(rvest)
library(jsonlite)

#base url for fed speeches
url <- paste0("https://www.federalreserve.gov")

#truncate raw html
read_html(url)

#create fake user agent to click each link and read speeches
uast <- paste0("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 ",
  "(KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36")

#start session with fake user agent
sess <- session("https://www.federalreserve.gov/newsevents/speeches.htm",
         httr::user_agent(uast))

#convert json file to suitable r object containing links to speeches and more
json_url <- "https://www.federalreserve.gov/json/ne-speeches.json"
json_data <- jsonlite::fromJSON(json_url)


#only chairman dataframe
df_chairman <- subset(json_data, grepl("^Chairman", s))

#remove na values from original dataframe
json_data <- json_data[-nrow(json_data), ]

#create list of urls to speeches using json data
url_list <- paste0(url, json_data$l)
#list of just chairman speeches
chair_url_list <- paste0(url, df_chairman$l)

#create list of webpages using url_list
full_page_list <- lapply(url_list, function(page){
  Sys.sleep(1)
  return(session_jump_to(page, x = sess))
})

# webpage_list -> textlist_list -(loop over each one to grab the text)> text
page_abstract <- lapply(page_list, function(page){
  paragraph <- page |> html_element(".col-md-8") |>
    html_elements("p") |>
      html_text()
    #combine strings into one
  speech <- paste(paragraph, collapse = " ")
  return(speech)
  })

head(page_abstract)