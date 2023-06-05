


#Replicating the TIER_1_DEEP7_SEASON_RPT_V11

# NOTES: 
  # this code was produced by translating the sql code directly using the produced 
  # FRS_DEEP7_TRIP_HEADERS and the TIER_1_DP7_CML_RPT tables.  
  
library(tidyverse)
library(dplyr)
library(data.table)

rm(list=setdiff(ls(), c("year")))

#----------------------
#Load data in 

  FRS_DEEP7_TRIP_HEADERS <- readRDS(file = file.path(".",
                                                    "data",
                                                    year,
                                                    "intermediate",
                                                    "FRS_DEEP7_TRIP_HEADERS.RDS"))

  
  load(file = file.path(".",
                        "data",
                        year,
                        "final",
                        paste0("TIER_1_DP7_CML_RPT_", year, ".RData")))



#----------------------
# Create fishery level stats 

# lines 125 - 135
  table_t <- FRS_DEEP7_TRIP_HEADERS %>%
    group_by(SEASON) %>%
    summarize(VESSELS = n_distinct(VESSEL, na.rm = TRUE))

# lines 137 - 251
  # Selecting fishery level variables (line 137)
  sub1_summ <- TIER_1_DP7_CML_RPT %>%
    group_by(SEASON) %>%
    summarize(TRIPS = sum(TRIPS),
              FISHERS = n_distinct(CML),
              DAYS_AT_SEA = sum(DAYS_AT_SEA),
              FISHING_DAYS = sum(FISHING_DAYS),
              HOURS_FISHED = sum(HOURS_FISHED))
  
  # Creating species level stats
  groups <- c("ALL_SPECIES", "DEEP7", "DEEP8_14", "NON_DEEP14", "ONAGA", "EHU", "OPAKAPAKA",
               "KALEKALE", "GINDAI", "HAPUUPUU", "LEHI", "YELLOW_KALEKALE", "UKU", "TAAPE", 
             "WHITE_ULUA", "BLACK_ULUA", "BUTAGUCHI", "KAHALA")
  
  calc_season_species_stats.f <- function(i){
    
    one_group <- groups[i]
    
    one_species.df <- TIER_1_DP7_CML_RPT %>%
      select(SEASON, 
             KEPT = paste0(one_group, "_KEPT"),
             EST_LBS_KEPT = paste0(one_group, "_EST_LBS_KEPT"),
             EST_VALUE = paste0(one_group, "_EST_VALUE"),
             AVG_LBS_PIECE = paste0(one_group, "_AVG_LBS_PIECE"),
             AVG_PRICE_LB = paste0(one_group, "_AVG_PRICE_LB")) %>%
      group_by(SEASON) %>%
      summarize(KEPT = sum(KEPT, na.rm = TRUE),
                EST_LBS_KEPT = sum(EST_LBS_KEPT, na.rm = TRUE),
                EST_VALUE = sum(EST_VALUE, na.rm = TRUE),
                AVG_LBS_PIECE = sum(EST_LBS_KEPT)/ifelse(is.na(sum(KEPT, na.rm = TRUE)), 
                                                         0, sum(KEPT, na.rm = TRUE)),
                AVG_PRICE_LB = sum(EST_VALUE)/ifelse(is.na(sum(EST_LBS_KEPT, na.rm = TRUE)), 
                                                        0, sum(EST_LBS_KEPT, na.rm = TRUE))) %>%
      
  # sm edits:  Karens code defines AVG_LBS_PIECE and AVG_PRICE_LB with these equations.  
    # but when I run these lines the values are way off from her org script.  
     # mutate(AVG_LBS_PIECE = EST_LBS_KEPT/ifelse(is.na(KEPT), 0, sum(KEPT, na.rm = TRUE)),
     #        AVG_PRICE_LB = EST_VALUE/ifelse(is.na(EST_LBS_KEPT), 0, sum(KEPT, na.rm = TRUE))) %>% 
      
      doBy::renameCol("KEPT", paste0(one_group, "_KEPT")) %>% 
      doBy::renameCol("EST_LBS_KEPT", paste0(one_group, "_EST_LBS_KEPT")) %>% 
      doBy::renameCol("EST_VALUE", paste0(one_group, "_EST_VALUE")) %>% 
      doBy::renameCol("AVG_LBS_PIECE", paste0(one_group, "_AVG_LBS_PIECE")) %>% 
      doBy::renameCol("AVG_PRICE_LB", paste0(one_group, "_AVG_PRICE_LB"))

  }


  species_stats.l <- lapply(1:length(groups), FUN = calc_season_species_stats.f)

  TIER_1_DP7_SEASON_RPT <- purrr::reduce(species_stats.l, left_join) %>%
     right_join(sub1_summ) %>%
     right_join(table_t)

  save(TIER_1_DP7_SEASON_RPT, file = file.path(".",
                                               "data",
                                               year,
                                               "final",
                                               paste0("TIER_1_DP7_SEASON_RPT_", 
                                                      year, ".RData")))
  
  write_csv(TIER_1_DP7_SEASON_RPT, file = file.path(".",
                                                    "data",
                                                    year,
                                                    "final",
                                                    paste0("TIER_1_DP7_SEASON_RPT_", 
                                                           year, ".csv")))
















