#Case Study6

#Load packages
install.packages('spDataLarge', repos='https://nowosad.github.io/drat/', type='source') #I did this because after running spData, R recommended me to do it
library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)
library(ncdf4)

#LOAD DATA
#Download monthly WorldClim data
data(world)  #load 'world' data from spData package
download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc")
tmean <- raster("absolute.nc") #help from my colleague Chen

#STEPA : PREPARE THE COUNTRY
# 1): Remove Antarctica
world_1 = world %>%
  filter(continent != "Antarctica")

# 2)convert world to sp
world_sp = as(world_1, "Spatial")

#STEPB: PREPARE CLIMATE DATA

max_temp = st_as_sf(raster::extract(tmean, world_sp, fun=max, na.rm=T, small=T, sp=T))
max_temp = max_temp%>%
  
  map1_hot <- ggplot(max_temp) +
  geom_sf(aes(fill=CRU_Global_1961.1960_Mean_Monthly_Surface_Temperature_Climatology)) +
  scale_fill_viridis_c(name="Annual\nMaximum\nTemperature (c)") +
  theme(legend.position = "bottom")
plot(map1_hot)
############################
max_temp2 <- max_temp %>%  group_by(continent) %>% top_n(1)


