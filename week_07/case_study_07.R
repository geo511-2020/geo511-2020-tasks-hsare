
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
library(sf) #I did not ued this one

library(spData)
library(rgdal)
library(sf)
library(ggplot2)
data(world)
ggplot(world, aes(x = gdpPercap, fill = continent)) +
  geom_density(alpha = 0.5, color = F) +
  labs(x = "GDP Per Capita", y = "Density") +
  theme(legend.position = "bottom")
