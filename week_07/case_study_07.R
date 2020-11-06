 
#Case Study7

#Problem: make figure illustrating the distribution of GDP per capita for all countries within each continent using
          #"world" data and "spData" package

#Current version of the code given in the assignment
library(tidyverse)
library(reprex)
library(sf)
library(spData)
data(world)
ggplot(world,aes(x=gdpPercap, y=continent, color=continent))+
  geom_density(alpha=0.5,color=F)

#My New Codes to perform the task
  #Given packages I did not use
library(tidyverse) #I did not ued this one
library(reprex) #I did not ued this one

   #I only use the following packages and lines of codes
library(spData)
library(rgdal) #Add
library(sf)
library(ggplot2) #Add
data(world)
ggplot(world, aes(x = gdpPercap, fill = continent)) + #I replace "y=continent, color=continent" by "fill=continent"
  geom_density(alpha = 0.5, color = F) +
  labs(x = "GDP Per Capita", y = "Density") + #Add this line for x-axis and y-axis
  theme(legend.position = "bottom") #Add legend
