#Case Study11


```{r setup, include=FALSE} #I put this because my laptop I used to run this code seem to not work perfectly without it
knitr::opts_chunk$set(echo = TRUE) #I put this because my laptop I used to run this code seem to not work perfectly without it
```


```{r Buffalo, echo=FALSE, message=FALSE, warning=FALSE, paged.print=FALSE}
#I load the required packages
library(tidyverse)
library(spData)
library(sf)
library(dplyr)
library(mapview) 
library(foreach)
library(doParallel)
registerDoParallel(4)
getDoParWorkers() 

library(tidycensus)
#Installation of my API key
census_api_key("b2e6b175927cf24c630b387a6adc01d4320e489b", install = TRUE) 
#Load required package and data. Note that this is given in the assignment instructions
library(tidycensus)
racevars <- c(White = "P005003", 
              Black = "P005004", 
              Asian = "P005006", 
              Hispanic = "P004003")
options(tigris_use_cache = TRUE)
erie <- get_decennial(geography = "block", variables = racevars, 
                      state = "NY", county = "Erie County", geometry = TRUE,
                      summary_var = "P001001", cache_table=T)
erie_crop <- st_crop(erie, c(xmin=-78.9,xmax=-78.85,ymin=42.888,ymax=42.92))
erie_loop <- foreach(i= unique(erie_crop$variable), .combine='rbind') %do% {
  filter(erie_crop, variable==i) %>%
    st_sample(size=.$value) %>%
    st_as_sf() %>%
    mutate(variable=i)
}
#Now the mapview part
mapview(erie_loop, zcol="variable", cex=1, alpha = 0)
mapview(erie_loop, zcol="variable", cex=0.1, alpha = 0)
```
