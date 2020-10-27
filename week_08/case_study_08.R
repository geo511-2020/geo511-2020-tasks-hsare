#Case Study8 

output:
  html_document: default
github_document: default
powerpoint_presentation: default
word_document: default

library(ggplot2)
library(tidyverse)
library(knitr)
library(kableExtra) #Help from my groupmate
value = read_table("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_annmean_mlo.txt",  skip=56)
  select(year, mean)

gaph1=ggplot(value, aes(year, mean))+
  geom_line(color="red")+
  labs(x="Year",y="Maunal Loa Annual Mean co2 in ppm", title="Annual Mean Carbon Dioxide Concentration 1959-present")
plot(graph1)


#########
library(magick)
value %>% top_n(5) %>% arrange(desc(year))%>%
  kable(align = "ll", caption = "Top 5 Annual Mean Carbon Dioxide Concebntrations at Mona Loa") %>% kable_styling() #Help from my groupmate
row(1, bold=T, color="red")%>% as_image(width=10, file="table.png")