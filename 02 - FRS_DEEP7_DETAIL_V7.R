
#Replicating the DEEP7_V7 table

library(tidyverse)
library(dplyr)
rm(list=setdiff(ls(), c("year")))

#----------------------
#Load data in 


FISHERY_SEASONS <- readRDS(file.path(".",
                                     "data",
                                     year,
                                     "source",
                                     "llds.LLDS_FISHERY_SEASONS.RDS"))

FRS <- readRDS(file.path(".",
                         "data",
                         year,
                         "source",
                         "WP_HAWAII.H_FRS.RDS"))


FRS_AREA <- readRDS(file.path(".",
                              "data",
                              year,
                              "source",
                              "wp_hawaii.H_FRS_AREA.RDS"))


FRS_SPECIES <- readRDS(file.path(".",
                                 "data",
                                 year,
                                 "source",
                                 "WP_HAWAII_WH.FRS_SPECIES.RDS"))


FRS_DEEP7_TRIP_HEADERS <- readRDS(file = file.path(".",
                                                 "data",
                                                 year,
                                                 "intermediate",
                                                 "FRS_DEEP7_TRIP_HEADERS.RDS"))



source("hlprfnx_creating_variables.r")

#----------------------
# Satifsy the following filtering condition 
# and a.area_pk  = frs.area_fk
# and area between 1 and 999

FRS_AREA <- FRS_AREA %>% 
  filter(AREA %in% 1:999)

# sm edits:  original I wrote the code s.th I would filter the areas as 

# df %>% 
#   filter(AREA_PK %in% FRS_AREA$AREA_FK) %>% 
#   filter(AREA_PK %in% 1:999)

# Based on Ashleys response on 11/23/21: The AREA_PK is the unique key of the 
# area table, a character field, and comprised of the area+subarea. The AREA 
# field is only the numeric area grid code from DAR.  What we REALLY want, 
# is the FRS_AREA$AREA field to be filtered for 1:999 and then filter the FRS 
# data set to only keep AREA_PK %in% FRS_AREA$AREA_FK

#----------------------
# Make table 1 (line 66 - 67)

TABLE1 <- FRS_DEEP7_TRIP_HEADERS %>%
  select(TRIP_KEY)

#----------------------
# Make table 2 (line 11 - 67)

table2_SEASONS <- FISHERY_SEASONS %>%
  select(SEASON = YEAR_TITLE,
         SEASON_START_DATE,
         SEASON_END_DATE,
         YEAR)

table2_FRS <- FRS %>%
  select(FISHER_LIC_FK,
         TRIP_END_DATE,
         FISHED_DATE,
         AREA_FK,
         GEAR_FK,
         HOURS_FISHED,
         REPORT_MONTH,
         REPORT_YEAR,
         VESSEL_NAME,
         USCG_VESSEL_REG,
         HA_VESSEL_REG,
         TRIP_BEGIN_DATE,
         FRS_NUM_KEPT = NUM_KEPT,
         FRS_NUM_SOLD = NUM_SOLD,
         FRS_NUM_LOST = NUM_LOST,
         FRS_LBS_SOLD = LBS_SOLD,
         FRS_LBS_KEPT = LBS_KEPT,
         FRS_SOLD_REVENUE = SOLD_REVENUE,
         SPECIES_FK) %>%
  
  # Create Variable TRIP_KEY (lines 22 -24)
  creating_TRIP_KEY.f() %>%
  
  # Create Variable FISHING_DAY_KEY (lines 25 - 27)
  creating_FISHING_DAY_KEY.f() %>%
  
  # Create Variable REPORT_KEY (lines 28)
  creating_REPORT_KEY_FRS.f() %>%
  
  # Create Variable VESSEL (lines 32)
  # sm edits:  I cant follow what line 66 is doing
  creating_VESSEL.f() %>%
  
  # Filtering tables (lines 57 -67)
  filter(!(GEAR_FK == 2)) %>% 
  filter(FRS_NUM_KEPT > 0 | FRS_LBS_KEPT > 0 | FRS_LBS_SOLD > 0) %>%
  filter(!is.null(FISHER_LIC_FK)) %>% 
  filter(AREA_FK %in% FRS_AREA$AREA_PK) %>% 
  # Line 63: sp.species_pk = frs.species_fk
  # we have to filter FRS$SPECIES_FK %in% FRS_SPECIES$SPECIES_PK
  # but we also want to preserve the SPECIES_NAME so we also need to left_join
  filter(SPECIES_FK %in% FRS_SPECIES$SPECIES_PK) %>% 
  left_join(FRS_SPECIES %>% 
              select(SPECIES_PK, SPECIES_NAME), 
            by = c("SPECIES_FK" = "SPECIES_PK")) %>%
  filter_FISHED_DATE_ADDING_SEASON_VAR.f(SEASONS.df = table2_SEASONS) %>%
  filter(TRIP_KEY %in% TABLE1$TRIP_KEY)

FRS_DEEP7_DETAILS <- table2_FRS

saveRDS(FRS_DEEP7_DETAILS, file = file.path(".",
                                         "data",
                                         year, 
                                         "intermediate",
                                         "FRS_DEEP7_DETAILS.RDS"))


#-------------
# Checking our work 

test <- FRS_DEEP7_DETAILS %>%
  group_by(SEASON) %>%
  summarize(TRIPS = n_distinct(TRIP_KEY))
  
  
 