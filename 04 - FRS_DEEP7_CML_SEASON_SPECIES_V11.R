

#Replicating the CML_SEASON_SPECIES_V11 table

# Note:  in final table FRS_NUM_KEPT == ORIG_NUM_KEPT

library(tidyverse)
library(dplyr)
library(data.table)

rm(list=setdiff(ls(), c("year")))

#----------------------
#Load data in 

  FRS_DEEP7_DETAILS <- readRDS(file = file.path(".",
                                           "data",
                                           year,
                                           "intermediate",
                                           "FRS_DEEP7_DETAILS.RDS"))

  
  ID_DEEP7_SEASON_SPECIES_V <- readRDS(file = file.path(".",
                                                   "data",
                                                   year,
                                                   "intermediate",
                                                   "ID_DEEP7_SEASON_SPECIES_V.RDS"))


#source("hlprfnx_creating_variables.r")

#----------------------
# Create the nested tables 
  
  # lines 37 - 52
  FRS <- FRS_DEEP7_DETAILS %>%
    group_by(SEASON, FISHER_LIC_FK, SPECIES_FK, SPECIES_NAME) %>%
    summarize(FRS_NUM_KEPT = sum(FRS_NUM_KEPT, na.rm = TRUE),
              FRS_LBS_SOLD = sum(FRS_LBS_SOLD, na.rm = TRUE)) %>%
    
    #sm edits: taken from lines 43 - 50
    # - org code ifelse(NUMKEPT > 0, 0, ...) which would translate to 
    #   if NUMKEPT is positive (recorded) switch value to 0 which doesnt make sense
    #   I think she was just trying to control for missing data and use another variable 
    #   if numkept was zero or NA
    
    #mutate(LBS_ONLY = ifelse(FRS_NUM_KEPT > 0, FRS_NUM_KEPT, 
    #                         FRS_LBS_SOLD)) %>%
    
    #------
    # this was throwing my numbers off, switch it to what karen has but double check if this 
    # is what she meant to do 
    mutate(LBS_ONLY = ifelse(FRS_NUM_KEPT > 0, 0, FRS_LBS_SOLD)) %>%
    select(-FRS_LBS_SOLD)

  
  # lines 53 - 65
  sd <- ID_DEEP7_SEASON_SPECIES_V %>%
    select(SEASON,
           SPECIES_FK,
           NUM_SOLD,
           LBS_SOLD, 
           SOLD_REVENUE)
  
  # lines 62 - 65
  # sm edits: check this, this seems wierd 
    #  (+)= in the sql code is a right join which i account for when 
    #  creating the FRS_DEEP7_CML_SEASON_SPECIES table below
  
  
  
# ----------------
# Creating final table - HARD CODE 
  
  # Joining tables (line 63 - 64)
  FRS_DEEP7_CML_SEASON_SPECIES <- sd %>%
    right_join(FRS, by = c("SEASON", "SPECIES_FK")) %>%
    rename(ORIG_NUM_KEPT = FRS_NUM_KEPT) %>%
    
    # Prelim expressions for the created variables 
    mutate(exp1 = ifelse(NUM_SOLD == 0, NA, NUM_SOLD),
           exp2 = round(LBS_SOLD/exp1, 2),
           exp3 = ifelse(exp2 == 0, NA, exp2)) %>%
    
    # Creating Variables (lines 18, 30 - 34)
    # sm edits:  She renames FRS_NUM_KEPT as ORIG_NUM_KEPT (line 19) after she creates a new 
    # FRS_NUM_KEPT variable (line 18).  When creating the variables bellow, idk if she is using the 
    # 'new' FRS_NUM_KEPT or the 'org' variable.  I used the origninal.  
    mutate(FRS_NUM_KEPT = ORIG_NUM_KEPT + floor(LBS_ONLY/ exp3),
           EXTRA_NUM_KEPT = floor(LBS_ONLY/exp3),
           AVG_LBS_PIECE = LBS_SOLD/exp1,
           AVG_PRICE_LB = SOLD_REVENUE/ifelse(LBS_SOLD == 0, NA, LBS_SOLD),
           EST_LBS_KEPT = (ORIG_NUM_KEPT + floor(LBS_ONLY/exp3))*LBS_SOLD/ifelse(NUM_SOLD == 0, NA, NUM_SOLD),
           EST_VALUE = (ORIG_NUM_KEPT + floor(LBS_ONLY/exp3))* 
             LBS_SOLD/ifelse(NUM_SOLD == 0, NA, NUM_SOLD)*
             SOLD_REVENUE/ifelse(LBS_SOLD == 0, NA, LBS_SOLD)) %>%
    
    # Remove nested variables 
    select(-exp1, -exp2, -exp3)
  
  saveRDS(FRS_DEEP7_CML_SEASON_SPECIES, file = file.path(".",
                                                      "data",
                                                      year,
                                                      "intermediate",
                                                      "FRS_DEEP7_CML_SEASON_SPECIES.RDS"))
  
  
