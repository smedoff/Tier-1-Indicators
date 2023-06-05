

library(RODBC) # for connecting to Oracle the SQL way
library(tidyverse) # for data manipulations

rm(list=setdiff(ls(), c("year")))


ch <- odbcConnect(dsn="PIC",
                  uid=rstudioapi::askForPassword("Oracle user name"),
                  pwd=rstudioapi::askForPassword("Oracle password"),
                  believeNRows=FALSE)

#-------------
# Check the list of data sets under thuis schema
  sqlTables(ch, schema='WP_HAWAII')
  #sqlTables(ch, schema='WP_HAWAII')

# I was having troulbe downloading the dealer data so i just watned 
# make sure i have access to it. 
  #tables_available <- sqlTables(ch)

  #test <- tables_available %>% 
  #  filter(str_detect(TABLE_NAME, "DEALER"))

# Querying input tables 

#-------------

  FISHERY_SEASONS <- sqlQuery(ch, paste("SELECT *",
                                      "FROM LLDS.LLDS_FISHERY_SEASONS"))
  
  saveRDS(FISHERY_SEASONS, file.path(".",
                                     "data",
                                     year,
                                     "source",
                                     "llds.LLDS_FISHERY_SEASONS.RDS"))
  rm(FISHERY_SEASONS)

#-------------
  
  H_FRS_AREA <- sqlQuery(ch, paste("SELECT *",
                                        "FROM wp_hawaii.H_FRS_AREA"))
  
  saveRDS(H_FRS_AREA, file.path(".",
                                "data",
                                year,
                                "source",
                                "wp_hawaii.H_FRS_AREA.RDS"))
  rm(H_FRS_AREA)

#-------------
  
  H_FRS_SPECIES <- sqlQuery(ch, paste("SELECT *",
                                      "FROM WP_HAWAII_WH.H_FRS_SPECIES"))
  
  saveRDS(H_FRS_SPECIES, file.path(".",
                                   "data",
                                   year,
                                   "source",
                                   "WP_HAWAII_WH.FRS_SPECIES.RDS"))
  rm(H_FRS_SPECIES)

#-------------
  
  H_FRS <- sqlQuery(ch, paste("SELECT *",
                              "FROM WP_HAWAII.H_FRS"))
  
  saveRDS(H_FRS, file.path(".",
                           "data",
                           year,
                           "source",
                           "WP_HAWAII.H_FRS.RDS"))
  rm(H_FRS)


#-------------
  
  H_INTEGDEALER <- sqlQuery(ch, paste("SELECT *",
                                      "FROM WP_HAWAII.H_INTEGDEALER"))
  
  saveRDS(H_INTEGDEALER, file.path(".",
                                   "data",
                                   year, 
                                   "source",
                                   "WP_HAWAII.H_INTEGDEALER.RDS"))
  rm(H_INTEGDEALER)


  
  
  

