
# This script sources and runs all preliminary code.  
 # Run this script before Running replication scripts 

# Updates 11/30
# I was able to match most of the data sets up until 04.  The data sets match 
# almost perfectly for the 04 script except for 2002.  There are two variables 
# in 2002 that are realy different.  Michel said this is ok.  Just to be safe, 
# I looked a little closer into these problem variables and found that 2002 and 2004
# had some differences.  At the end of the compiling-markdown file, I examine 
# the cmls that have different variable values.  In most cases, the difference does
# not exceed 1.  Run this by Michel and make sure this is ok because I cant figure out
# what the problem is.  Initially, I thought that maybe it was something with the 
# previous scripts like one of the problem-cmls werent filtering correctly (e.g. 
# kept a fishing set that was outside of the area of interest). But I made direct 
# comparisons between observations in the previous intermediate tables and everything
# looks right.  


rm(list=ls())
library(stringr)
library(dplyr)
library(tidyverse)

#----------------
# Set Year Parameter 
  # - This is the only manual parameter you need to set for the whole 
  # - program.  
  
  year <- 2022
  
#----------------
# Create a data storing folder for this years run 
  data_path <- file.path(".",
                         "data",
                         year)
  
  if(!dir.exists(data_path)){
    dir.create(data_path)
    
    dir.create(file.path(data_path, "source"))
    
    dir.create(file.path(data_path, "intermediate"))
    
    dir.create(file.path(data_path, "final"))
    
    dir.create(file.path(data_path, "final", "code check"))
  }
  
#----------------
# Sourcing preliminary scripts
  source(file.path(".",
                   "00 - Query Data.R"))
  
  source(file.path(".",
                   "01 - FRS_DEEP7_TRIP_HEADERS_V10.R"))
  
  
  source(file.path(".",
                   "02 - FRS_DEEP7_DETAIL_V7.R"))
  
  
  source(file.path(".",
                   "03 - ID_DEEP7_SEASON_SPECIES_V6.R"))
  
  source(file.path(".",
                   "04 - FRS_DEEP7_CML_SEASON_SPECIES_V11.R"))
  
#----------------
# Sourcing main scripts to create HILL_SEASON and ASLL_SEASON RPT 
  
  source(file.path(".",
                   "05a - TIER_1_DEEP7_CML_RPT_V8.R"))
  
  
  source(file.path(".",
                   "05b - TIER_1_DEEP7_SEASON_RPT_V11.R"))
  
  
  
#----------------
# Check code by comparing data to the previous year
# we only do this for the SEASON report because to compare the CML report, well have to summarize
# by year/season anyway
  
  # TODO this is not finished... figure out how to copy and paste the code check file to the new years folder
  
  code_check_file <- list.files(file.path("data", year-1, "final", "code check", "compare_seasons.Rmd$")) %>% 
    grep("compare_seasons.Rmd", value = TRUE)
  
  file.copy(code_check_file, file.path("data", year, "final", "code check"))
  
  
  
  
  
  
  