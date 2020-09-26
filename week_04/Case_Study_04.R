# CASE STUDY4

#Goal: Find the Full name of the destination airport farthest from any
#of the NYC airports

#Loading required packages
library(tidyverse)
library(nycflights13)

#The farthest airport from NYC result
flights%>% select(distance,dest)%>% arrange(desc(distance))%>%
  slice(1)%>% left_join(airports,by=c("dest"="faa"))%>%
  select(name)


select(airports, dest = faa, destName=name)%>% right_join(flights)%>% 
  arrange(desc(distance)) %>% slice(1) %>% 
  select(destName)

#EXTRA TIMES TASKS
#PLOT1
#Here, I just followed exactly the instructions given in the task assignment
#So, I copy and pasted here the given codes in the assignment
library(MAP) #I load this package because R is asking me to do it

airports %>%
  distinct(lon,lat) %>%
  ggplot(aes(lon, lat)) +
  borders("world") +
  geom_point(col = "red") +
  coord_quickmap()

#PLOT2
#Can you figure out how to map mean delays by destination airport as shown below?
#(This is the given instruction)