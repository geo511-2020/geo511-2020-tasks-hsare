#Case Study2
#
#Given Data1:
library(tidyverse)
dataurl="https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_USW00014733_14_0_1/station.cvs"

#Given Data2:
temp=read_cvs(dataurl,
              skip=1, #skip the first line
              na="999.90" , # missing data
              clo_names = c("YEAR", "JAN","FEB","MAR", #Names of the column
                            "APR","MAY","JUN","JUL",
                            "AUG","SEPT","OCT","NOV",
                            "DEC","DJF","MAM","JJA",
                            "SON","metANN"))

##Use the tool to explore the data
view(temp)
#summary(temp) , alternative
#glimpse(temp), alternative too
plt <- ggplot(temp, aes(x=YEAR, y=JJA)) +
  geom_lines(col = grey(.1)) +
  geom_smooth(col = "red") +
  ylab("Mean Summer Temperatures (c)") +
  ggtitle("Mean Summer Temperatures in Buffalo, NY",
          subtitle = "Summer includes June, July and August\nData from the global Historical Climate Network\nRed lines is a LOESS smooth") +
  xlab("Year")
print(plt)

#Save graphic to png file
#code from my group colleague Brendan Kunz. I updated this code after our group meeting3
ggsave(("Case Study2.png"), plot = last_plot()) #code from my group colleague Brendan Kunz