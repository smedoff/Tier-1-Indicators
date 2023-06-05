

# Creating stats for all species
#i <- 12

#season <- season.df
#species <- species.l[[i]]
#grouping_variable <- "SEASON"
  # sm TODO: switch this so it dynamically groups variables so we can flexibly switch the grouping condition
  # to produce the cml reports 


compiling_d7_season_rpt.f <- function(i, season = season.df, species){
  
  species <- species.l[[i]]
  
  variable_label <- names(species.l)[i]
  
  if(!(species == "ALL_SPECIES")){
    
    species_name <- species$SPECIES_NAME
    
    species_fk <- species$SPECIES_FK
    
    df <-  left_join( # Table 1
                        sub_DETAILS %>%
                          filter(SPECIES_NAME %in% species_name |
                                   SPECIES_FK %in% species_fk) %>%
                          group_by(SEASON) %>%
                          summarize(SPECIES_KEPT = sum(NUM_KEPT, na.rm = TRUE)),
                        # Table 2
                        sub_SEASON_V11 %>%
                          filter(SPECIES_NAME %in% species_name |
                                   SPECIES_FK %in% species_fk)  %>%
                          group_by(SEASON) %>%
                          summarize(AVG_LBS_PIECE = mean(AVG_LBS_PIECE, na.rm = TRUE),
                                    EST_LBS_KEPT = sum(EST_LBS_KEPT, na.rm = TRUE),
                                    AVG_PRICE_LB = mean(AVG_PRICE_LB, na.rm = TRUE),
                                    EST_VALUE = sum(EST_VALUE, na.rm = TRUE))
                      ) %>% 
                        # Renaming variables
                        doBy::renameCol("SPECIES_KEPT", paste0(variable_label, "_KEPT")) %>% 
                        doBy::renameCol("AVG_LBS_PIECE", paste0(variable_label, "_AVG_LBS_PIECE")) %>% 
                        doBy::renameCol("EST_LBS_KEPT", paste0(variable_label, "_EST_LBS_KEPT")) %>% 
                        doBy::renameCol("AVG_PRICE_LB", paste0(variable_label, "_AVG_PRICE_LB")) %>% 
                        doBy::renameCol("EST_VALUE", paste0(variable_label, "_EST_VALUE")) %>%
            right_join(season)
    
    
  }else{

    df <-  left_join( # Table 1
                          sub_DETAILS %>%
                            group_by(SEASON) %>%
                            summarize(SPECIES_KEPT = sum(NUM_KEPT, na.rm = TRUE)),
                          # Table 2
                          sub_SEASON_V11 %>%
                            group_by(SEASON) %>%
                            summarize(AVG_LBS_PIECE = mean(AVG_LBS_PIECE, na.rm = TRUE),
                                      EST_LBS_KEPT = sum(EST_LBS_KEPT, na.rm = TRUE),
                                      AVG_PRICE_LB = mean(AVG_PRICE_LB, na.rm = TRUE),
                                      EST_VALUE = sum(EST_VALUE, na.rm = TRUE))
                        ) %>% 
                          # Renaming variables
                          doBy::renameCol("SPECIES_KEPT", paste0(variable_label, "__KEPT")) %>% 
                          doBy::renameCol("AVG_LBS_PIECE", paste0(variable_label, "_AVG_LBS_PIECE")) %>% 
                          doBy::renameCol("EST_LBS_KEPT", paste0(variable_label, "_EST_LBS_KEPT")) %>% 
                          doBy::renameCol("AVG_PRICE_LB", paste0(variable_label, "_AVG_PRICE_LB")) %>% 
                          doBy::renameCol("EST_VALUE", paste0(variable_label, "_EST_VALUE")) %>%
      right_join(season)
    
  } #end of "species" ifelse statement
  
  return(df)
  
} #end of function 
  




