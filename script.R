library(tidyverse)
library(readr)
library(janitor)
library(tigris)

brockton <- read_csv("Brockton_ShotSpotterCSV.csv",
                     col_types = cols(
                       `Incident Id` = col_double(),
                       `CAD Id` = col_character(),
                       Time = col_datetime(format = ""),
                       Type = col_character(),
                       Address = col_character(),
                       Latitude = col_double(),
                       Longitude = col_double(),
                       `# of Rounds` = col_double(),
                       District = col_logical(),
                       Beat = col_logical()
                     )) %>% 
  clean_names()

#x <- call_geolocator("Brockton", "MA")
shapes <- urban_areas(class = "sf") %>% 
  mutate(brockton = str_detect(NAME10, ""))

