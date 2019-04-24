
#This loads the necessary packages for the rest of the code.

library(tidyverse)
library(readr)
library(janitor)
library(tigris)
library(sf)
library(ggthemes)
library(fs)
library(gganimate)
library(lubridate)

#Here read the data into an object from the csv file that was downloaded. We
#observe that the variable types for longitude, latitude, and date are not what
#we want.

springfield <- read_csv("springfield_MA.csv",
                        col_types = cols(
                          Date = col_character(),
                          `Time Range` = col_character(),
                          Latitude = col_character(),
                          Longitude = col_character(),
                          `Incident Type` = col_character()
                        )) %>% 
  
#This standardizes the column names, so the data is easier to work with.
  
  clean_names() %>% 
  
#This removes some of the formating that caused the longitude and latitude
#variables to be downloaded as characters rather than doubles.
  
  mutate(latitude = str_remove_all(latitude, ",")) %>% 
  mutate(longitude = str_remove_all(longitude, ",")) %>% 
  
#This turns the longitude and latitude varibales into numbers so that they can
#be used as the coordinates.
  mutate(latitude= as.numeric(latitude)) %>% 
  mutate(longitude = as.numeric(longitude)) %>% 
  
#We remove any rows that have NA for longitude or latitude because they will not
#be able to be mapped. These NA occur because the entry was not able to be
#interpreted as a number.
  
  filter(!is.na(longitude)) %>% 
  filter(!is.na(latitude)) %>% 

#These filters restrict the data to the bounds determined by the shap
#springfield we will call below.
  
  filter(longitude > -72.8) %>% 
  filter(longitude < -71.3) %>% 
  filter(latitude > 41.9) %>% 
  filter(latitude < 42.4) %>% 
  
#This converts the date column from a character varibale to a date variable so
#that we can work with it more easily.
  
  mutate(date = as.Date(date, "%d/%m/%Y")) %>% 
  
#Here we remove any NA dates, because our annimation will have frames based on
#dates, so date-less data will not be useful.
  
  filter(!is.na(date))


#Here we are modifying the springfield object to prepare it for being used in
#creating the annimation.

springfield2 <- springfield %>% 
  
#Since our animation frames will be different years, we isolate the year from
#the date as a new variable.
  
  mutate(year = year(date)) %>%
  
#So shrink the amount of data we're wroking with so that it looks better on the
#plot, we restrict the incident type to machine gun incidents.
  
  filter(incident_type == "MG") %>% 

#Here we make the newly created year variable into a numeric variable so we can
#iterate over it as our annimation frames.
  
  mutate(year = as.numeric(year))


  
#Here we create an object will all of the urban area shape files. This will
#allow us to find the Springfield shapefile.

raw_shapes <- urban_areas(class = "sf") 



#Here we are finding and storing the springfield shapefile specifically.

springfield_shapes <- raw_shapes %>% 
  
#Here we detect whether any row has the city and state that we want.
  
  mutate(springfield = str_detect(NAME10, "Springfield, MA")) %>% 

#Now we isolate the row for springfield MA, by seeing where the detection above
#was TRUE.
  
  filter(springfield)

#This creates an sf object of the locations indicated by longitude and latitude
#for all the rows of the springfield2 object. The crs determines the convention
#of the perspective and the na.fail allows the command to handle na coordinates.

springfield_shot_locations <- st_as_sf(springfield2,
                          coords = c("longitude", "latitude"),
                          crs = 4326,
                          na.fail = FALSE)

#This creates an animated plot (map) and spores it as an object called
#animation.

animation<- ggplot()  +
  
#This adds a layer to the plot indicating the region of springfield as
#determined by the shapefile.
  
  geom_sf(data = springfield_shapes)+
  
#This adds in the points of the machine gun shots using the sf object we
#previously created with this information. The points are given color, made
#translucent so that it is clear when they are clumped together, and the legend
#is removed because it adds no useful information.
  
  geom_sf(data = springfield_shot_locations, aes(color = "red", fill = "red", 
                                                 alpha = .1), show.legend = FALSE)+
#This makes the plot formated as a map.
  
  theme_map()+
  
#This improves the appearance of the map by adding some color and coordinates.
  
  theme_solarized()+

#This adds a descriptive title and subtitle explaining what the map shows. The
#subtitle adds shows the year currently displayed.
  
  labs(title = "Machine Gun Shot locations in Springfield MA",
       subtitle = "By Year, from 2008 to 2018 (Currently Displaying: {closest_state} )")+
  
#This indicates that the plot will be animated with each frame showing a
#different year.
  
  transition_states(year)+
  
#For further clarity of what is displayed, the year displayed is added under the
#map.
  
  labs(x = "Year Displayed: {closest_state}")+
  
#This reduces the size of the overall map shown to avoid a lot of dead space
#without any data points.
  
  coord_sf(xlim = c(-72.7,-72.5), ylim = c(42.0,42.2))

#This saves the animation object (the animated map) as a gif and puts it in the
#folder of the shiny app so it can easily be called into the map.

anim_save("Shotspotter/springfield.gif", animation)
