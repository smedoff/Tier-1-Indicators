

#------------

#Create the FRS_DEEP7_TRIPS_HEADERS_V10.sql table 

# sm edits:  Based off of conversations with Ashely this sql can be partitioned into three parts 
  # (1) - Lines 31 to 103 
  # (2) - Lines 10 to 103 
  # (3) - Lines 104 - 137
# The execution process should be, 
  # table (1) is used to create table (3) which is used to create table (2)

#------------

library(dplyr)
library(tidyverse)

rm(list=setdiff(ls(), c("year")))

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

source("hlprfnx_creating_variables.r")


#Tables required 
# - WP_HAWAII.H_FRS
# - LLDS_FISHERY_SEASONS
# - WP_HAWAII.H_FRS_AREA


#------------
# Create filtering tables (lines 88 - 102)

#select
  #NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || to_char( trip_end_date, 'YYYYMMDD' ),
  #     lpad( to_char( fisher_lic_fk), 6, '0' )  || to_char( fished_date, 'YYYYMMDD' ) ) trip_key
#from
  #wp_hawaii.h_frs frs,
  #wp_hawaii.h_frs_area ar
#where
  #substr(   decode( trip_end_date, NULL, to_char( fished_date, 'YYYYMMDD' ) || lpad( to_char( fisher_lic_fk), 6, '0' ),
  #                  to_char( trip_end_date, 'YYYYMMDD' ) || lpad( to_char( fisher_lic_fk), 6, '0' ) ), 1, 4 ) > 2000
  #and species_fk in ( 22, 21, 19, 17, 97, 15, 58 )
  #and gear_fk <> 2
  #and ( num_kept > 0 or frs.lbs_kept > 0 )
  #and fisher_lic_fk is not null
  #and ar.area_pk  = frs.area_fk
  #and area between 1 and 999)

  t_filter <- FRS %>%
    creating_TRIP_KEY.f() %>%
    mutate(YEAR = ifelse(is.na(TRIP_END_DATE), 
                         substr(FISHED_DATE, 1, 4),
                         substr(TRIP_END_DATE, 1, 4))) %>%
    filter(YEAR > 2000, 
           SPECIES_FK %in% c(22, 21, 19, 17, 97, 15, 58),
           !(GEAR_FK ==2),
           NUM_KEPT > 0 | LBS_KEPT > 0,
           !is.na(FISHER_LIC_FK)) %>%
    left_join(FRS_AREA, by = c("AREA_FK" = "AREA_PK")) %>%
    filter(AREA %in% 1:999) %>%
    select(TRIP_KEY)



#------------
# Creating Table (1)
#------------
# Create temp tables (lines 31 - 103)

  temp <- FRS %>%
    creating_TRIP_KEY.f() %>%
    creating_FISHING_DAY_KEY.f() %>%
    creating_REPORT_KEY_FRS.f() %>% 
    creating_VESSEL.f() %>%
  
#where
  #s.fishery = 'MHIB' (Save this for later)
  #and gear_fk <> 2
  #and ( num_kept > 0 or frs.lbs_kept > 0 )
  #and fisher_lic_fk is not null
  #and a.area_pk  = frs.area_fk
  #and area between 1 and 999
    filter(!(GEAR_FK ==2),
           NUM_KEPT > 0 | LBS_KEPT > 0,
           !is.na(FISHER_LIC_FK),
           TRIP_KEY %in% t_filter$TRIP_KEY) %>%
    left_join(FRS_AREA, by = c("AREA_FK" = "AREA_PK")) %>%
    filter(AREA %in% 1:999) %>%
           
  #and NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
  #           lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) )
  #in (t_filter table created above )
  
 #and fished_date between s.season_start_date and s.season_end_date
  filter_FISHED_DATE_ADDING_SEASON_VAR.f(rename(FISHERY_SEASONS, SEASON = YEAR_TITLE)) %>%
  select(SEASON,
         SEASON_START_DATE,
         SEASON_END_DATE,
         FISHER_LIC_FK,
         TRIP_BEGIN_DATE,
         TRIP_END_DATE,
         HOURS_FISHED,
         AREA_FK,
         GEAR_FK, 
         TRIP_KEY, 
         FISHING_DAY_KEY, 
         REPORT_KEY,
         FISHED_DATE,
         REPORT_YEAR,
         REPORT_MONTH, 
         VESSEL,
         VESSEL_NAME, 
         USCG_VESSEL_REG, 
         HA_VESSEL_REG) %>% 
  mutate(TRIP_BEGIN_DATE = as.Date(TRIP_BEGIN_DATE),
         TRIP_END_DATE = as.Date(TRIP_END_DATE),
         SEASON_START_DATE = as.Date(SEASON_START_DATE),
         SEASON_END_DATE = as.Date(SEASON_END_DATE), 
         FISHED_DATE = as.Date(FISHED_DATE))
      
      # sm edits: tables were not matching between ashleys sql-produced data set and this produced data set,
      # Jon S. made a good point in saying that matching "REPORT_YEAR" = "YEAR" doesnt make sense for the 
      # seasons df except for the seasons that only have one year (e.g. season 2007 compared to seasons 2007-2008)
      # I am not sure if I see the point in left joining the FRS data with the SEASONS data set except for the fact
      # that we want to filter for MHIB fishery, but the FISHERY_SEASONS data only has FISHERY == "MHIB" observations 
      # So as long as we only keep fishing days within each of the fishing seasons this condition should be satisfied. 
      #left_join(filter(FISHERY_SEASONS, FISHERY == "MHIB"), by = c("SEASON" = "YEAR_TITLE")) 

  
#------------
# Creating Table (3)
#------------
# Create temp2 tables (lines 104 - 137)

  temp2 <- temp %>%
  
#group by
  #t.season,
  #season_start_date,
  #season_end_date,
  #season_year,
  #t.trip_key,
  #t.report_key,
  #t.fisher_lic_fk
    group_by(SEASON, 
             SEASON_START_DATE, 
             SEASON_END_DATE, 
             #SEASON_YEAR, 
             TRIP_KEY,
             REPORT_KEY, 
             FISHER_LIC_FK) %>%
  
  
    summarize(
      
    #count( distinct fishing_day_key ) fishing_days,
      FISHING_DAYS = n_distinct(FISHING_DAY_KEY),
      
    #CASE WHEN min(trip_begin_date ) is null THEN min(fished_date )
      #ELSE min( trip_begin_date ) END AS trip_begin_date
      TRIP_BEGIN_DATE = if(is.na(min(TRIP_BEGIN_DATE))){min(FISHED_DATE)}else{min(TRIP_BEGIN_DATE)},
    
    #CASE WHEN max(trip_end_date ) is null THEN max(fished_date )
      #ELSE max( trip_end_date ) END AS trip_end_date
      TRIP_END_DATE = if(is.na(max(TRIP_END_DATE))){max(FISHED_DATE)}else{max(TRIP_END_DATE)},
    
    #min( fished_date) FIRST_FISHING_DATE
      FIRST_FISHING_DATE = min(FISHED_DATE),
    
    #max( fished_date) LAST_FISHING_DATE
      LAST_FISHING_DATE = max(FISHED_DATE),
    
    #sum( hours_fished ) hours_fished
      HOURS_FISHED = sum(HOURS_FISHED),
    
    #max(vessel ) vessel
      VESSEL = max(VESSEL)) 

  
  
#------------
# Creating Table (2)
#------------
# Create temp tables (lines 11 - 103)

  FRS_DEEP7_TRIP_HEADERS <- temp2 %>%
    select(SEASON, 
           SEASON_START_DATE,
           SEASON_END_DATE,
           FISHER_LIC_FK, 
           TRIP_KEY, 
           REPORT_KEY,
           FISHING_DAYS,
           TRIP_BEGIN_DATE, 
           TRIP_END_DATE, 
           FIRST_FISHING_DATE,
           LAST_FISHING_DATE,
           HOURS_FISHED,
           VESSEL)  %>%
  mutate(
  # case when trip_begin_date < season_start_date then season_start_date else trip_begin_date end start_date
    START_DATE = if(TRIP_BEGIN_DATE < SEASON_START_DATE | is.na(TRIP_BEGIN_DATE)){
                          SEASON_START_DATE 
                        }else{
                          TRIP_BEGIN_DATE
                        },
     
  #case when trip_end_date > season_end_date then season_end_date else trip_end_date end end_date
    END_DATE = if(TRIP_END_DATE > SEASON_END_DATE | is.na(TRIP_END_DATE)){
                      SEASON_END_DATE 
                    }else{
                      TRIP_END_DATE
                    },
  
  #case when trip_end_date > season_end_date then season_end_date else trip_end_date end )  -
    #(  case when trip_begin_date < season_start_date then season_start_date else trip_begin_date end ) + 1 days_at_sea
    DAYS_AT_SEA =  END_DATE - START_DATE + 1)



#------------
# Saving the final data set 

saveRDS(FRS_DEEP7_TRIP_HEADERS, file = file.path(".",
                                              "data",
                                              year,
                                              "intermediate",
                                              "FRS_DEEP7_TRIP_HEADERS.RDS"))
  
  

  

