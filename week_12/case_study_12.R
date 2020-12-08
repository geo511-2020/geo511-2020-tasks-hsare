#Case Study12
# load required packages from the assignment
library(dplyr)
library(ggplot2)
library(ggmap)
library(htmlwidgets)
library(widgetframe)

#Detailed Steps 
#I downloaded these packages from the assignment

library(tidyverse)
library(rnoaa)
library(xts)
library(dygraphs)

d=meteo_tidy_ghcnd("USW00014733",
                   date_min = "2016-01-01", 
                   var = c("TMAX"),
                   keep_flags=T) %>% 
  mutate(date=as.Date(date),
         tmax=as.numeric(tmax)/10) #Divide the tmax data by 10 to convert to degrees.

#This is what I created for the assignment
maximum_temperature <- xts(d$tmax, order.by = d$date)
dygraph(maximum_temperature, main="Daily Maximum Temperature in Buffalo, NY")%>%
  dyRangeSelector(dateWindow = c("2020-01-01", "2020-10-31"))
