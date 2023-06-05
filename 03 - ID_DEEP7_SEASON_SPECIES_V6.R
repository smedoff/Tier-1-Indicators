

#Replicating the DEEP7_V6 table

# sm edits: 
  # - Karen renames SPECIES_FK as DAR_SPECIES 
  # - for simplicity, I will leave SPECIES_FK as is 

library(tidyverse)
library(dplyr)
library(data.table)

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

DEALER <- readRDS(file.path(".",
                                 "data",
                                 year,
                                 "source",
                                 "WP_HAWAII.H_INTEGDEALER.RDS"))


source("hlprfnx_creating_variables.r")



#---------------------

#Nested table FRS_t (lines 35 - 42)
  FRS_t <- FRS_DEEP7_TRIP_HEADERS %>%
    group_by(SEASON, 
             FISHER_LIC_FK, 
             REPORT_KEY) %>%
    summarize(TRIPS_PER_REPORT = n())
  
#Nested table DEALER_t (lines 43 - 56)
  DEALER_id <- DEALER %>%
    creating_REPORT_KEY_DEALER.f() %>%
    filter(REPORT_KEY %in% as.character(FRS_DEEP7_TRIP_HEADERS$REPORT_KEY),
           NUM_SOLD > 0,
           FISHERY %like% "FRS") %>%
    group_by(FISHERY, FISHER_LIC_FK, REPORT_KEY, SPECIES_FK) %>%
    summarize(NUM_SOLD = sum(NUM_SOLD, na.rm = TRUE),
              LBS_SOLD = sum(LBS_SOLD, na.rm = TRUE),
              SOLD_REVENUE = sum(SOLD_REVENUE, na.rm = TRUE))

  
#Nested table sp (line 42)
  sp <- FRS_SPECIES
  
#----------------------
# Creating table temp (lines 25 - 61)
  
  temp <- DEALER_id  %>%
    # lines 58 - 59
    inner_join(FRS_t) %>%
    inner_join(FRS_SPECIES, by = c("SPECIES_FK" = "SPECIES_PK")) %>%
    
    # lines 60
      group_by(SEASON, 
               REPORT_KEY, 
               FISHER_LIC_FK, 
               SPECIES_FK, 
               SPECIES_NAME) %>%
        
    # lines 31 - 33
      summarize(NUM_SOLD = sum(NUM_SOLD, na.rm = TRUE),
                LBS_SOLD = sum(LBS_SOLD, na.rm = TRUE),
                SOLD_REVENUE = sum(SOLD_REVENUE, na.rm = TRUE))
      
#----------------------
# Group temp table (lines 62 - 72)  
  ID_DEEP7_SEASON_SPECIES_V <- temp %>%
    group_by(SEASON, SPECIES_FK, SPECIES_NAME) %>%
    summarize(NUM_SOLD = sum(NUM_SOLD, na.rm = TRUE),
              LBS_SOLD = sum(LBS_SOLD, na.rm = TRUE),
              SOLD_REVENUE = sum(SOLD_REVENUE, na.rm = TRUE),
              AVG_LBS_PIECE = sum(LBS_SOLD, na.rm = TRUE)/sum(NUM_SOLD, na.rm = TRUE),
              AVG_PRICE_LB = sum(SOLD_REVENUE, na.rm = TRUE)/sum(LBS_SOLD, na.rm = TRUE))
  
  saveRDS(ID_DEEP7_SEASON_SPECIES_V, file = file.path(".",
                                                   "data",
                                                   year,
                                                   "intermediate",
                                                   "ID_DEEP7_SEASON_SPECIES_V.RDS"))
  