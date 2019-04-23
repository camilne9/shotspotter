library(tidyverse)
library(readr)
library(janitor)
library(tigris)
library(sf)
library(ggthemes)
library(fs)
library(gganimate)
library(lubridate)

springfield <- read_csv("springfield_MA.csv",
                        col_types = cols(
                          Date = col_character(),
                          `Time Range` = col_character(),
                          Latitude = col_character(),
                          Longitude = col_character(),
                          `Incident Type` = col_character()
                        )) %>% 
  clean_names() %>% 
  mutate(latitude = str_remove_all(latitude, "\\,")) %>% 
  mutate(longitude = str_remove_all(longitude, ",")) %>% 
  mutate(latitude= as.numeric(latitude)) %>% 
  mutate(longitude = as.numeric(longitude)) %>% 
  filter(!is.na(longitude)) %>% 
  filter(!is.na(latitude)) %>% 
  filter(longitude > -72.8) %>% 
  filter(longitude < -71.3) %>% 
  filter(latitude > 41.9) %>% 
  filter(latitude < 42.4) %>% 
  mutate(date = as.Date(date, "%d/%m/%Y")) %>% 
  filter(!is.na(date))


springfield2 <- springfield %>% 
  mutate(year = year(date)) %>%
  filter(incident_type == "SG")
  

raw_shapes <- urban_areas(class = "sf") 

springfield_shapes <- raw_shapes %>% 
  mutate(springfield = str_detect(NAME10, "Springfield, MA")) %>% 
  filter(springfield)


springfield_shot_locations <- st_as_sf(springfield2,
                          coords = c("longitude", "latitude"),
                          crs = 4326,
                          na.fail = FALSE)

ggplot()  +
  geom_sf(data = springfield_shapes)+
  geom_sf(data = springfield_shot_locations, aes(color = incident_type, fill = incident_type))+
  theme_map()+
  theme_solarized()
