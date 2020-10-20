
#Case Study7

#Current version of the code given in the assignment
library(tidyverse)
library(reprex)
library(sf)
library(spData)
data(world)
ggplot(world,aes(x=gdpPercap, y=continent, color=continent))+
  geom_density(alpha=0.5,color=F)

#My New Codes to perform the task
library(tidyverse) #I did not ued this one
library(reprex) #I did not ued this one
library(sf) #I did not used this one

library(spData)
library(rgdal) #Add
library(sf)
library(ggplot2) #Add
data(world)
ggplot(world, aes(x = gdpPercap, fill = continent)) + #I replace "y=continent, color=continent" by "fill=continent"
  geom_density(alpha = 0.5, color = F) +
  labs(x = "GDP Per Capita", y = "Density") + #Add this line for x-axis and y-axis
  theme(legend.position = "bottom") #Add legend
