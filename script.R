library(tidyverse)
library(readr)
library(janitor)
library(tigris)
library(sf)
library(ggthemes)
library(fs)
library(gganimate)

#brockton <- read_csv("Brockton_ShotSpotterCSV.csv",
 #                    col_types = cols(
  #                     `Incident Id` = col_double(),
   #                    `CAD Id` = col_character(),
    #                   Time = col_datetime(format = ""),
     #                  Type = col_character(),
      #                 Address = col_character(),
       #                Latitude = col_double(),
        #               Longitude = col_double(),
         #              `# of Rounds` = col_double(),
          #             District = col_logical(),
           #            Beat = col_logical()
            #         )) %>% 
#  clean_names()

worcester <- read_csv("worcester_ma.csv",
                      col_types = cols(
                        Date = col_character(),
                        `Time Range` = col_character(),
                        Latitude = col_number(),
                        Longitude = col_number(),
                        `Incident Type` = col_character(),
                        `Round Count` = col_character()
                      )) %>% 
  clean_names()

raw_shapes <- urban_areas(class = "sf") 
worcester_shapes <- raw_shapes %>% 
  mutate(worcester = str_detect(NAME10, "Worcester")) %>% 
  filter(worcester)

gun_locations <- st_as_sf(worcester,
                          coords = c("longitude", "latitude"),
                          crs = 4326)
ggplot(data = worcester_shapes)  +
  geom_sf()+
  #geom_sf(data = gun_locations, aes(color = incident_type, fill = incident_type))+
  theme_map()+
  theme_solarized()
  

