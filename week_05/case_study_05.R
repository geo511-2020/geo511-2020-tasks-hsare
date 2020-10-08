#CASE STUDY5

#Load required packages according to Hints (libraries packages)
library(spData)
library(sf)
library(tidyverse)

#Load required data according to Hints
#Note that I copy and paste here exactly the sames codes given in the assignment

# 1)load 'world' data from spData package
data(world)  
# 2)load 'states' boundaries from spData package
data(us_states)
# plot(world[1])  #plot if desired
# plot(us_states[1]) #plot if desired
########################################
#STEPS
#STEP A) WORLD DATASET. This is the first step in the task
# 1) transform to the albers equal area projection:
#I COPIED AND PASTED HERE THE EXACT CODES GIVEN IN THE ASSIGNMENT
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"


# 2)filter the world dataset to include only name_long=="Canada"

canada <- world %>% st_transform(crs = albers)%>%  #I use the transformation ALBERS specified above
  st_set_geometry("geom")%>%
  filter(name_long=="Canada")%>% #As specified in the task
  # 3)buffer canada to 10km (10000m)
  st_buffer(10000)
####################################

#STEP B) US STATES OBJECTS

# 1)transform to the albers equal area projection defined above as albers
#I use the transformation ALBERS specified above BUT HERE I APPLIED TO NEW YORK
ny <- us_states%>%  st_transform(crs = albers)%>%
  
  # 2)filter the us_states dataset to include only NAME == "New York"
  filter(NAME == "New York")
##########################################

#STEP C) CREATE A BORDER OBJECT

# 1)use st_intersection() to intersect the canada buffer with New York (this will be your final polygon)

ny_border <- canada%>% st_intersection(ny)

# 2) Plot the border area using ggplot() and geom_sf().

ggplot() +
  geom_sf(data = ny) + #BECAUSE OUR DATA IS NY
  geom_sf(data = ny_border, fill = "red") + #BECAUSE WE WANT TO HIGHIGHT NY BORDER WITH CANADA IN RED
  labs(title = "New York Land within 10km") #THE TITLE ID FROM THE FIGURE SHOWN IN THE ASSIGNMENT

print(ny_border) #This is not the area of the border but include other area as well
st_area(ny_border) #This is the real border area
st_area(canada) # Here I am just trying to figure out why print(ny_border) is not showing only the area of the border
st_area(ny) + st_area(canada) # Here I am just trying to figure out why print(ny_border) is not showing only the area of the border

