#Case Study3

# INSTRUCTIONS1: Load necessary packages
library(ggplot2)
library(gapminder)
library(dplyr)

# INSTRUCTION2: Use filter to eliminate kuwait data from the gapminder
gapminder <- gapminder %>% filter(country != "kuwait")

############################################
#PLOT1
#I used only the instrutions given + the information of the given figure (x-axis, y-axis,...)

# 1)Use ggplot() and the theme_bw() to duplicate the first plot using the filtered dataset (without Kuwait)
# 2)Specify the appropriate aesthetic mapping (aes()) to color by contintent,
#adjust the size of the point with size=pop/100000,
#x-axis=lifeExp, y-axis=gdpPerCap [these informations are from the Given figure]
plt1 <- ggplot(data = gapminder, aes(color = continent, x = lifeExp, y = gdpPercap, size = pop/100000)) +
  geom_point() +
  # 3)Use scale_y_continuous(trans = "sqrt") to get the correct scale on the y-axis.
  # 4)Use facet_wrap(~year,nrow=1) to divide the plot into separate panels.
  facet_wrap(~year,nrow=1) +
  scale_y_continuous(trans = "sqrt") +
  theme_bw()

# 5) Use labs() to specify more informative x, y, size, and color keys.
labs(x = "Life Expectancy", y = "GDP per capita", size = "Population(100k)", color = "continent")

#Print
print(plt1)
# Save
#code from my group colleague Brendan Kunz
ggsave(("Case Study3_1.png"), plot = last_plot()) #code from my group colleague Brendan Kunz
################################################
#PLOT2

# PART_A )Prepare the data for the second plot
# A1)Use group_by() to group by continent and year
# A2)Use summarize() with the below commands to calculate the data for the black continent average line on the second plot:
#gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop)
#pop = sum(as.numeric(pop))
# A3)Save this aggregated data as an object called gapminder_continent
gapminder.continent <- gapminder %>%
  group_by(continent, year) %>%
  summarise(gdpPercap = weighted.mean(x = gdpPercap, w = pop),
            pop = sum(as.numeric(pop)))

#PART_B )Plot #2 (the second row of plots)
#Use ggplot() and the theme_bw() to duplicate the second plot.
#In this plot you will add elements from both the raw gapminder dataset and your dataset summarized by continent.

# B1) Similar like the previous plot plt1, we have:
plt2 <- ggplot(data = gapminder, aes(color = continent, x = year, y = gdpPercap)) +
  # B2) Here we did similar like previous plot plt1 again but use this instead because of what is asked
  #You will need to use the new data you summarized to add the black lines and dots showing the continent average.
  geom_point(aes(size = pop/100000)) +
  geom_line(aes(group = country)) +
  geom_point(data = gapminder.continent, color = "black", aes(size = pop/100000)) +
  geom_line(data = gapminder.continent, color = "black") +
  
  
  # B3) Similarly like previous plot plt1, I add:
  facet_wrap(~continent, nrow=1) +
  theme_bw() +
  labs(x = "Year", y = "GDP per capita", color = "continent", size = "Population(100k)")


#Print
print(plt2)
# Save
#code from my group colleague Brendan Kunz
ggsave(("Case Study3_2.png"), plot = last_plot()) #code from my group colleague Brendan Kunz

