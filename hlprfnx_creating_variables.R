
#Example synthax 
  #df <- FRS

#-------------
# Create Variable TRIP_KEY

#NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
#     lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) ) AS trip_key,


    creating_TRIP_KEY.f <- function(df){
      
      table.df <- df
      
      TRIP_KEY <- table.df %>%
        mutate(TRIP_KEY = ifelse(!is.na(TRIP_END_DATE),
                                 paste0(str_pad(FISHER_LIC_FK, width = 6, side = "left", pad = "0"), 
                                        str_pad(TRIP_END_DATE, width = 8, side = "left", pad = "0")),
                                 paste0(str_pad(FISHER_LIC_FK, width = 6, side = "left", pad = "0"), 
                                        str_pad(FISHED_DATE, width = 8, side = "left", pad = "0")))) %>%
        mutate(TRIP_KEY = gsub("-", "", TRIP_KEY))
      
      return(TRIP_KEY)
    }


#-------------  
# Create Variable FISHING_DAY_KEY 
    
#-- fishing_day_key
#NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
#     lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) ) || lpad( to_char( fished_date), 6, '0' )  AS fishing_day_key,

    # This function was updated 02-16-2022.  To me, this functions makes more sense but when applied, it 
    # was throwing off the values.  
    # TODO figure out why this function is different then the old one. 

    
    creating_FISHING_DAY_KEY.f <- function(df){
      
      # Original function that doesn't work because !is.na(TRIP_END_DATE) has length > 1
      FISHING_DAY_KEY <- df %>%
        
        mutate(FISHING_DAY_KEY = ifelse(!is.na(TRIP_END_DATE),
                                        paste0(str_pad(FISHER_LIC_FK, width = 6, side = "left", pad = "0"), 
                                               str_pad(TRIP_END_DATE, width = 8, side = "left", pad = "0"),
                                               str_pad(FISHED_DATE, width = 6, side = "left", pad = "0")),
                                        paste0(str_pad(FISHER_LIC_FK, width = 6, side = "left", pad = "0"), 
                                               str_pad(FISHED_DATE, width = 8, side = "left", pad = "0"),
                                               str_pad(FISHED_DATE, width = 6, side = "left", pad = "0"))))

      
      return(FISHING_DAY_KEY)
    }
    

    

#-------------
# Create Variable VESSEL (lines 32)
# sm edits:  I cant follow what line 66 is doing
    #df <- FRS
    
#    CASE WHEN
#       uscg_vessel_reg is null  or uscg_vessel_reg = 'N/A' THEN
#     CASE WHEN
#         ha_vessel_reg is null THEN
#       CASE WHEN
#           vessel_name is null THEN
#           'CML' || lpad( to_char( fisher_lic_fk), 6, '0' )
#       ELSE
#           vessel_name
#       END
#     ELSE
#       'HA' || replace(translate(ha_vessel_reg, translate(ha_vessel_reg, '01234567890', ' '), ' '), ' ','')
#     END
#    ELSE
#    uscg_vessel_reg
#    END vessel
    
    creating_VESSEL.f <- function(df){
      
      table.df <- df 
      
      VESSEL <- table.df %>%
        # Some HA_VESSEL_REG values took the form "514753, 0315G"
        # The ', ' was problematic because the str_extract function would only grab the numbers before 
        # the comma.  Remove the comma and white spaces before we apply the function
        mutate(HA_VESSEL_REG_CLEAN1 = gsub("[a-zA-Z ]", "", HA_VESSEL_REG),
               HA_VESSEL_REG_CLEAN2 = gsub("[[:punct:]]", "", HA_VESSEL_REG_CLEAN1)) %>% 
        mutate(HA_VESSEL_REG_CLEAN3 = ifelse(nchar(HA_VESSEL_REG_CLEAN2) <= 3, 
                                            str_pad(HA_VESSEL_REG_CLEAN2, 
                                                    pad = 0, width = 4, side = "left"),
                                            HA_VESSEL_REG_CLEAN2)) %>% 
        mutate(name_condition = ifelse(is.na(VESSEL_NAME), 
                                      paste0('CML', str_pad(table.df$FISHER_LIC_FK, 6, "left", "0")),
                                      VESSEL_NAME),
              HA_condition = ifelse(is.na(HA_VESSEL_REG_CLEAN3), 
                                    name_condition, 
                                    paste0('HA', HA_VESSEL_REG_CLEAN3)),
              USCG_condition = ifelse(is.na(USCG_VESSEL_REG), 
                                      HA_condition, 
                                      USCG_VESSEL_REG)) %>%
        select(-name_condition, -HA_condition, -HA_VESSEL_REG_CLEAN1, -HA_VESSEL_REG_CLEAN2,
               -HA_VESSEL_REG_CLEAN3) %>%
        rename(VESSEL = USCG_condition)

      return(VESSEL)
    }
    

#--------------
# Adding SEASONS variable and filtering based off of season dates 
 #df <- temp
 #SEASONS.df <- FISHERY_SEASONS %>%
  # rename(SEASON = YEAR_TITLE)
    
# fished_date between s.season_start_date and s.season_end_date
    
    filter_FISHED_DATE_ADDING_SEASON_VAR.f <- function(df, SEASONS.df){
      
      table_SEASONS.df <- SEASONS.df
      
      #Creating fisher season days vector to filter
      fishing_days.l <- lapply(1:nrow(table_SEASONS.df), FUN = function(i){ 
        
        x <- table_SEASONS.df[i, ]
        
        date_range <- data.frame(SEASON = x$SEASON,
                                 #YEAR = x$YEAR,
                                 SEASON_START_DATE = x$SEASON_START_DATE,
                                 SEASON_END_DATE = x$SEASON_END_DATE,
                                 DATE = seq.Date(as.Date(x$SEASON_START_DATE),
                                                 as.Date(x$SEASON_END_DATE),
                                                 by = "days"))
        
        return(date_range)
      })
      
      fishing_days.df <- do.call(rbind, fishing_days.l)
      
      #--------
      # Filter the FISHED_DATE based off of fishing season. 
      
      filtered.df <- df %>% 
        mutate(FISHED_DATE = as.Date(FISHED_DATE)) %>%
        filter(FISHED_DATE %in% fishing_days.df$DATE) %>%
        left_join(fishing_days.df, by = c("FISHED_DATE" = "DATE"))
      
      return(filtered.df)
    }
    

#-----------------------
#Create a days at sea variable 
    creating_DAYS_AT_SEA.f <- function(df){
      
      table.df <- df
      
      DAYS_AT_SEA <- table.df %>% 
        mutate(START_DATE = ifelse(TRIP_BEGIN_DATE < FISHERY_SEASONS$SEASON_START_DATE, FISHERY_SEASONS$SEASON_START_DATE, TRIP_BEGIN_DATE),
               END_DATE = ifelse(TRIP_END_DATE > FISHERY_SEASONS$SEASON_END_DATE, FISHERY_SEASONS$SEASON_END_DATE, TRIP_END_DATE),
               DAYS_AT_SEA = END_DATE - START_DATE) %>% 
        select(-START_DATE, -END_DATE)
      
      return(DAYS_AT_SEA)
    }
    
#-----------------------
#Create a report key variable (Taken from V10 - line 50)
  # sm edits: The REPORT_KEY was made differently in the v7 script (line 28)
  # V10 accounts for na REPORTYEAR values
  # V7 just switches it to a character object 
  # V7 version of REPORTKEY is bellow 
    
  #df <- FRS
    
    
#-- report_key
#lpad( to_char( fisher_lic_fk), 6, '0' )  ||  to_char( decode( report_year, 0, to_char( trip_end_date, 'YYYY' ), report_year ) ) || lpad( to_char( decode( report_month, 0, to_char( trip_end_date, 'MM' ), report_month ) ) , 2, '0'  ) report_key
  
    creating_REPORT_KEY_FRS.f <- function(df){
      
      table.df <- df
      
      REPORT_KEY <- table.df %>%
        mutate(REPORT_KEY = paste0(str_pad(FISHER_LIC_FK, 
                                           width = 6, 
                                           side = "left", 
                                           pad = "0"), 
                                   ifelse(is.na(REPORT_YEAR), 
                                          substr(TRIP_END_DATE, 1, 4), 
                                          REPORT_YEAR),
                                   str_pad(ifelse(is.na(REPORT_MONTH), 
                                                  substr(TRIP_END_DATE, 6, 7), 
                                                  REPORT_MONTH), 
                                           width = 2, side = "left", pad = "0")))
      
      return(REPORT_KEY)
    }
    
    #mutate(REPORT_KEY = paste0(str_pad(FISHER_LIC_FK, 
    #                                   width = 6, 
    #                                   side = "left", 
    #                                   pad = "0"), 
    #                           as.character(REPORT_YEAR),
    #                           str_pad(as.character(REPORT_MONTH), 
    #                                   width = 2, side = "left", pad = "0"))) %>%
    


#-----------------------
#Create a report key variable for DEALER data set
    #df <- DEALER
    
    creating_REPORT_KEY_DEALER.f <- function(df){
      
      table.df <- df
      
      REPORT_KEY <- table.df %>%
        mutate(REPORT_KEY = paste0(str_pad(FISHER_LIC_FK, 
                                           side = "left", width = 6, pad = "0"),
                                   as.character(substr(REPORT_DATE, 1, 4)),
                                   as.character(substr(REPORT_DATE, 6, 7))))
      
      return(REPORT_KEY)
    }



