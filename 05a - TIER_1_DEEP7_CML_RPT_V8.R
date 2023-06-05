


#Replicating the TIER_1_DEEP7_CML_RPT_V8

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
  
  
  FRS_DEEP7_CML_SEASON_SPECIES <- readRDS(file = file.path(".",
                                                          "data",
                                                          year,
                                                          "intermediate",
                                                          "FRS_DEEP7_CML_SEASON_SPECIES.RDS"))
  #-------------------
  # sm edits: Compare observations between trip headers and season
  # maybe we should grab unique season/cml from trip heaers and not seasons species
#  trip_headers <- FRS_DEEP7_TRIP_HEADERS %>% 
#    group_by(SEASON, FISHER_LIC_FK) %>% 
#    summarize(n_headers = n())
  
#  cml_season_species <- FRS_DEEP7_CML_SEASON_SPECIES %>% 
#    group_by(SEASON, FISHER_LIC_FK) %>% 
#    summarize(n_species = n())
  
#  test <- left_join(trip_headers, cml_season_species)
  
  #-------------------
  
#----------------------
# Lines 171 - 182
# sm edits:  why take the max of VESSELS?  This is a character element made in the TRIP_HEADERS code
  table_t <- FRS_DEEP7_TRIP_HEADERS %>%
    group_by(SEASON, CML = FISHER_LIC_FK) %>%
    summarize(FISHING_DAYS = sum(FISHING_DAYS, na.rm = TRUE),
              DAYS_AT_SEA = sum(DAYS_AT_SEA, na.rm = TRUE),
              FISHERS = n_distinct(FISHER_LIC_FK),
              VESSELS = n_distinct(VESSEL),
              TRIPS = n_distinct(TRIP_KEY),
              HOURS_FISHED = sum(HOURS_FISHED, na.rm = TRUE),
              VESSEL = max(VESSEL))

#----------------------
# Lines 183 - 274 :  All deep 14 species stats 
  
  # matching deep 14 fk codes with species name 
  species_code.df <- data.frame(
    SPECIES_FK = c(22, 21, 19, 17, 97, 15, 58, 208, 20, 114, 205, 202, 200, 16), 
    ENGLISH_NAME = c("ONAGA", "EHU", "OPAKAPAKA", "KALEKALE", "GINDAI", "HAPUUPUU", "LEHI",
                     "YELLOW_KALEKALE", "UKU", "TAAPE", "WHITE_ULUA", "BLACK_ULUA", "BUTAGUCHI",
                     "KAHALA"))
  
  # Creating the species level stats (lines 184 - 274)
    # Grabbing all unique fisher_lic_fk for each season to do a final merge 
  #season_permit.df <- FRS_DEEP7_CML_SEASON_SPECIES %>%
  season_permit.df <- FRS_DEEP7_TRIP_HEADERS %>%
    group_by(SEASON, CML = FISHER_LIC_FK) %>%
    summarize(n = n()) %>%
    select(-n)
  
  # Calc stats for an indiviudal fish in the D14 
  calc_D14_stats.f <- function(i){
    
    one_species_FK <- species_code.df$SPECIES_FK[i]
    one_english_name <- species_code.df$ENGLISH_NAME[i]
    
    sub_FRS <- FRS_DEEP7_CML_SEASON_SPECIES %>% 
      filter(SPECIES_FK == one_species_FK) %>% 
      group_by(SEASON, CML = FISHER_LIC_FK) %>% 
      summarize(KEPT = max(FRS_NUM_KEPT),
                AVG_LBS_PIECE = max(AVG_LBS_PIECE),
                EST_LBS_KEPT = max(EST_LBS_KEPT), 
                AVG_PRICE_LB = max(AVG_PRICE_LB),
                EST_VALUE = max(EST_VALUE)) %>% 
      doBy::renameCol("KEPT", paste0(one_english_name, "_KEPT")) %>% 
      doBy::renameCol("AVG_LBS_PIECE", paste0(one_english_name, "_AVG_LBS_PIECE")) %>% 
      doBy::renameCol("EST_LBS_KEPT", paste0(one_english_name, "_EST_LBS_KEPT")) %>% 
      doBy::renameCol("AVG_PRICE_LB", paste0(one_english_name, "_AVG_PRICE_LB")) %>% 
      doBy::renameCol("EST_VALUE", paste0(one_english_name, "_EST_VALUE")) %>%
      right_join(season_permit.df) 
    
    return(sub_FRS)
  }
  
  FRS.l <- lapply(1:nrow(species_code.df), FUN = calc_D14_stats.f)
  
  FRS <- purrr::reduce(FRS.l, left_join) %>%
    replace(is.na(.), 0)
    
#----------------------
# Lines 291 - 306 : table for deep8 to deep14
  
  calc_group_stats.f <- function(fk_code, group){
    
    one_group_stats.df <- FRS_DEEP7_CML_SEASON_SPECIES %>%
      filter(SPECIES_FK %in% fk_code,
             FRS_NUM_KEPT > 0) %>%
      group_by(SEASON, CML = FISHER_LIC_FK) %>%
      summarize(FRS_NUM_KEPT = sum(FRS_NUM_KEPT, na.rm = TRUE),
                AVG_LBS_PIECE = sum(EST_LBS_KEPT)/ifelse(is.na(sum(FRS_NUM_KEPT, na.rm = TRUE)), 
                                                         0, sum(FRS_NUM_KEPT, na.rm = TRUE)),
                EST_LBS_KEPT = sum(EST_LBS_KEPT, na.rm = TRUE),
                AVG_PRICE_LB = sum(EST_VALUE)/ifelse(is.na(sum(EST_LBS_KEPT, na.rm = TRUE)), 
                                                     0, sum(EST_LBS_KEPT, na.rm = TRUE)),
                EST_VALUE = sum(EST_VALUE)) %>%
      doBy::renameCol("FRS_NUM_KEPT", paste0(group, "_KEPT")) %>%
      doBy::renameCol("AVG_LBS_PIECE", paste0(group, "_AVG_LBS_PIECE")) %>%
      doBy::renameCol("EST_LBS_KEPT", paste0(group, "_EST_LBS_KEPT")) %>%
      doBy::renameCol("AVG_PRICE_LB", paste0(group, "_AVG_PRICE_LB")) %>%
      doBy::renameCol("EST_VALUE", paste0(group, "_EST_VALUE")) 
    
    return(one_group_stats.df)
  }

# D7 totals 275 - 289
  d7 <- calc_group_stats.f(fk_code = c(22, 21, 19, 17, 97, 15, 58),
                           group = "DEEP7")
  
# D8_14 total 291 - 306
  d8_14 <- calc_group_stats.f(fk_code = c( 208, 20, 114, 205, 202, 200, 16),
                                    group = "DEEP8_14")
  
# non_d14 307 - 320 
  non_fk <- FRS_DEEP7_CML_SEASON_SPECIES %>% 
    filter(!(SPECIES_FK %in% c(22, 21, 19, 17, 97, 15, 58, 208, 20, 114, 205, 202, 200, 16))) %>%
    select(SPECIES_FK)
  
  non_deep14 <- calc_group_stats.f(fk_code = non_fk$SPECIES_FK,
                                    group = "NON_DEEP14")
  
# all species 322 - 345
  all_fk <- FRS_DEEP7_CML_SEASON_SPECIES %>%
    group_by(SPECIES_FK) %>%
    summarize(n = n())
  
  all_species <- calc_group_stats.f(fk_code = all_fk$SPECIES_FK,
                                    group = "ALL_SPECIES")
  
  
#----------------------
# Joining Tables
  
  TIER_1_DP7_CML_RPT <- table_t %>%
    left_join(FRS) %>%
    left_join(all_species, by = c("SEASON", "CML")) %>%
    left_join(d7, by = c("SEASON", "CML")) %>%
    left_join(d8_14, by = c("SEASON", "CML")) %>%
    left_join(non_deep14, by = c("SEASON", "CML"))

#------------------------------
# sm edits: 
  
  # Originally, we had issues with DEEP7_14 variables and NONDEEP_14 variables not
  # matching the sql-produced data set.  This was because sql defines 0 entries.  
  # this code produces a data set were 0 entries are NAs.  
  # Make sure zero entries are reported as '0's and not NAs 
  
  NONDEEP_14_VARS <- grep("DEEP8_14", names(TIER_1_DP7_CML_RPT), value = TRUE)
  DEEP8_14_VARS <- grep("DEEP8_14", names(TIER_1_DP7_CML_RPT), value = TRUE)
  
  NAs_FILLED.df <- TIER_1_DP7_CML_RPT %>% 
    select(CML, SEASON, NONDEEP_14_VARS, DEEP8_14_VARS) %>% 
    replace(is.na(.), 0)
  
  test <- TIER_1_DP7_CML_RPT %>% 
    select(-c(NONDEEP_14_VARS, DEEP8_14_VARS)) %>% 
    left_join(NAs_FILLED.df) %>% 
    replace(is.na(.), 0) 
  # sm edits:  replace all NAs with 0 otherwise itll throw off the code that compares the
  # replicated data set to ashleys produced data set. 
  
  TIER_1_DP7_CML_RPT <- test
  
  # sm edits:  Im not sure why there are some obervations where DEEP7_NUMKEPT ==0
  # This should not be the case.  Remove these observations 
  test <- TIER_1_DP7_CML_RPT %>% 
    filter(DEEP7_KEPT > 0)
  
  TIER_1_DP7_CML_RPT <- test
  
#------------------------------

  save(TIER_1_DP7_CML_RPT, file = file.path(".",
                                            "data",
                                            year,
                                            "final",
                                            paste0("TIER_1_DP7_CML_RPT_", 
                                                   year, ".RData")))
  
  write_csv(TIER_1_DP7_CML_RPT, file = file.path(".",
                                                "data",
                                                 year,
                                                "final",
                                                paste0("TIER_1_DP7_CML_RPT_", 
                                                       year, ".csv")))
