#Case Study9

#Load Packages


library(sf)
library(tidyverse)
library(ggmap)
library(rnoaa)
library(spData)
data(world)
data(us_states)

#Does not work in October 2020
# Doesn't work in October 2020.
storms <- storm_shp(basin = "NA")
storm_data <- read_sf(storms$path)
# 2020 update - it appears NOAA changed the URL which broke the R function.  Use the following instead of storm_shp().
dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
unzip(file.path(tdir,"temp.zip"),exdir = tdir)
list.files(tdir)

#Another given code
storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))

#STEP2

storms <- storm_data%>%
  filter(year>=1950)%>% #Filter to storms 1950-present with filter()
  mutate_if(is.numeric, 
            function(x) ifelse(x==-999.0,NA,x))%>% #Use mutate_if() to convert -999.0 to NA in all numeric columns with the following command from the dplyr package: mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x))
  mutate(decade=floor(year/10)*10) #Use the following command to add a column for decade: mutate(decade=(floor(year/10)*10))
region=st_bbox(storms) #Use st_bbox() to identify the bounding box of the storm data and save this as an object called region


map1=ggplot() +
  geom_sf(data=world,
          inherit.aes = F,size=.1,
          fill="grey",colour="black")+
  facet_wrap(~decade)+
  stat_bin2d(data=storms,
             aes(y=st_coordinates(storms)[,2],
                 x=st_coordinates(storms)[,1]),bins=100)+
  scale_fill_distiller(palette="YlOrRd",
                       trans="log",
                       direction=-1,
                       breaks = c(1,10,100,1000))+
  coord_sf(ylim=region[c(2,4)],
           xlim=region[c(1,3)])+
  labs(x="",y="")
map1


library(knitr) #I add this here because R is asking me after I run my code at this point
library(kableExtra) #I add this here because R is asking me after I run my code at this point
us_states<- st_transform(us_states,st_crs(storms))
us_states = us_states%.>%
  select(state = NAME)
storm_states <- st_join(storms, us_states, 
                        join = st_intersects, 
                        left = F)
storm_states%>%
  group_by(NAME)%>%
  summarize(storms=length(unique(Name)))%>%
  st_set_geometry(NULL)%>%
  arrange(desc(storms))%>%
  slice(1:5)%>%
  st_drop_geometry()
  kable()%>%
  kable_styling()


