#Case Study10

# Load packages
library(raster)
library(rasterVis)
library(rgdal)
library(ggmap)
library(tidyverse)
library(knitr)

# New package
library(ncdf4)

#LAND COVER AND LAND USE
# Create afolder to hold the downloaded data
dir.create("data",showWarnings = F) #create a folder to hold the data

lulc_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MCD12Q1.051_aid0001.nc?raw=true"
lst_url="https://github.com/adammwilson/DataScienceData/blob/master/inst/extdata/appeears/MOD11A2.006_aid0001.nc?raw=true"

# download them
download.file(lulc_url,destfile="data/MCD12Q1.051_aid0001.nc", mode="wb")
download.file(lst_url,destfile="data/MOD11A2.006_aid0001.nc", mode="wb")

#LOAD DATA INTO R
lulc=stack("data/MCD12Q1.051_aid0001.nc",varname="Land_Cover_Type_1")
lst=stack("data/MOD11A2.006_aid0001.nc",varname="LST_Day_1km")

# Explore LULC data
plot(lulc)

lulc=lulc[[13]]
plot(lulc)

# PROCESS LANDCOVER DATA
#Assign land cover clases from MODIS website
Land_Cover_Type_1 = c(
  Water = 0, 
  `Evergreen Needleleaf forest` = 1, 
  `Evergreen Broadleaf forest` = 2,
  `Deciduous Needleleaf forest` = 3, 
  `Deciduous Broadleaf forest` = 4,
  `Mixed forest` = 5, 
  `Closed shrublands` = 6,
  `Open shrublands` = 7,
  `Woody savannas` = 8, 
  Savannas = 9,
  Grasslands = 10,
  `Permanent wetlands` = 11, 
  Croplands = 12,
  `Urban & built-up` = 13,
  `Cropland/Natural vegetation mosaic` = 14, 
  `Snow & ice` = 15,
  `Barren/Sparsely vegetated` = 16, 
  Unclassified = 254,
  NoDataFill = 255)

lcd=data.frame(
  ID=Land_Cover_Type_1,
  landcover=names(Land_Cover_Type_1),
  col=c("#000080","#008000","#00FF00", "#99CC00","#99FF99", "#339966", "#993366", "#FFCC99", "#CCFFCC", "#FFCC00", "#FF9900", "#006699", "#FFFF00", "#FF0000", "#999966", "#FFFFFF", "#808080", "#000000", "#000000"),
  stringsAsFactors = F)
# colors from https://lpdaac.usgs.gov/about/news_archive/modisterra_land_cover_types_yearly_l3_global_005deg_cmg_mod12c1
kable(head(lcd))


# convert to raster (easy)
lulc=as.factor(lulc)

# update the RAT with a left join
levels(lulc)=left_join(levels(lulc)[[1]],lcd)

# plot it
gplot(lulc)+
  geom_raster(aes(fill=as.factor(value)))+
  scale_fill_manual(values=levels(lulc)[[1]]$col,
                    labels=levels(lulc)[[1]]$landcover,
                    name="Landcover Type")+
  coord_equal()+
  theme(legend.position = "bottom")+
  guides(fill=guide_legend(ncol=1,byrow=TRUE))

#LAND SURFACE TEMPERATURE
plot(lst[[1:12]])

# Convert LST to Degrees C
#You can convert LST from Degrees Kelvin (K) to Celcius (C) with offs()
offs(lst)=-273.15
plot(lst[[1:10]])


# Add Dates to Z (time) dimension
#The default layer names of the LST file include the date as follows:
names(lst)[1:5]

tdates=names(lst)%>%
  sub(pattern="X",replacement="")%>%
  as.Date("%Y.%m.%d")

names(lst)=1:nlayers(lst)
lst=setZ(lst,tdates)


# Part 1: EXTRACT TIME SERIES FOR A POINT
#Step1: Use lw=SpatialPoints(data.frame(x= -78.791547,y=43.007211)) to define a new Spatial Point at that location.
lw=SpatialPoints(data.frame(x= -78.791547,y=43.007211))
#Step2: Set the projection of your point with projection() to "+proj=longlat"
projection(lw) <- "+proj=longlat"
#Step3: Transform the point to the projection of the raster using spTransform()
lw %>% spTransform(CRSobj = crs(lst))
#Step4: Extract the LST data for that location with: extract(lst,lw,buffer=1000,fun=mean,na.rm=T). You may want to transpose them with t() to convert it from a wide matrix to long vector
data_Part1 <- raster::extract(lst,lw,buffer=1000,fun=mean,na.rm=T) %>% t()
#Step5:Extract the dates for each layer with getZ(lst) and combine them into a data.frame with the transposed raster values. You could use data.frame(), cbind.data.frame() or bind_cols() to do this. The goal is to make a single dataframe with the dates and lst values in columns
dates <- getZ(lst)
lst_dates = data.frame(LST = data_Part1, Date = dates, stringsAsFactors = F)
head(lst_dates)
#Step6: Plot it with ggplot() including points for the raw data and a smooth version as a line. You will probably want to adjust both span and n in geom_smooth
ggplot(lst_dates, aes(x=Date, y=LST)) +
  geom_point() +
  geom_smooth(color = "Blue", se = FALSE, span = 0.01, n = 100)

# Part 2: SUMMARIZE WEEKLY DATA TO MONTHLY CLIMATOLOGIES
#Step1: First make a variable called tmonth by converting the dates to months using as.numeric(format(getZ(lst2),"%m"))
tmonth <- as.numeric(format(getZ(lst), "%m"))
#Step2: Use stackApply() to summarize the mean value per month (using the tmonth variable you just created) and save the results as lst_month
lst_month <- stackApply(lst, indices = tmonth, fun = mean, na.rm = T)
#Step3: Set the names of the layers to months with names(lst_month)=month.name
names(lst_month) = month.name
#Step4: Plot the map for each month with gplot() in the RasterVis Package
gplot(lst_month)+
  geom_tile(aes(fill = value))+
  facet_wrap(~ variable)+
  scale_fill_gradientn(colors = c("blue", "grey", "red"),
                       values = scales::rescale(c(0, 10, 20, 30)))+
  coord_equal()+
  theme(axis.text = element_blank())
#Step5: Calculate the monthly mean for the entire image with cellStats(lst_month,mean)
cellStats(lst_month,mean) %>% kable(digits = round(2), col.names = "Mean", format = "rst")

# Part 3: SUMMARIZE LAND SURFACE TEMPERATURE BY LAND COVER
#Step1: Resample lc to lst grid using resample() with method=ngb
lulc2 <- resample(lulc, lst, method = "ngb")
#Step2: Extract the values from lst_month and lulc2 into a data.frame as follows
lcds1=cbind.data.frame(
  values(lst_month),
  ID=values(lulc2[[1]]))%>%
  na.omit()
#Step3: Gather the data into a ‘tidy’ format using gather(key='month',value='value,-ID)
gather_lcds1 <- lcds1 %>% 
  gather(key='month', value='value', -ID) %>% 
#Step4: Use mutate() to convert ID to numeric (e.g. ID=as.numeric(ID) and month to an ordered factor with month=factor(month,levels=month.name,ordered=T)  
  mutate(ID=as.numeric(ID), month=factor(month, levels=month.name, ordered=T)) %>% 
#Step5: do a left join with the lcd table you created at the beginning  
  left_join(lcd, by = "ID") %>% 
#Step6: Use filter() to keep only landcover%in%c("Urban & built-up","Deciduous Broadleaf forest")  
  filter(landcover %in% c("Urban & built-up","Deciduous Broadleaf forest"))
#Step8: Develop a ggplot to illustrate the monthly variability in LST between the two land cover types. The exact form of plot is up to you. Experiment with different geometries, etc
ggplot(gather_lcds1, aes(x=month, y=value))+
  geom_jitter(alpha=0.9)+
  geom_violin(scale = "width", color = "Red", fill = "Grey")+
  facet_wrap(~landcover)+
  labs(title="Land Surface Temperature in Urban and Forest", x="Month", y="Monthly Mean Land Surface Temperature (C)")+
  theme(axis.text.x = element_text(angle = 45))

