-- TIER_1_DEEP7_CML_RPT_v8.sql
-- ksender 2012 12 05
-- v7 2018
-- v8 2019 no change

-- remember to edit suffix of table by run date
-- note that DEEP7 is abbreviated to D7 as other report name would exceed char limit
CREATE TABLE TIER_1_D7_CML_RPT20191212 as (
select
     t.cml,
     t.season,
     vessel,
     vessels,
     trips,
     days_at_sea,
     fishing_days,
     hours_fished,
   -- all_species
  round( nvl(all_species.frs_num_kept, 0 ) )   all_species_kept,
  round( nvl(all_species.avg_lbs_piece, 0 ), 10)   all_species_avg_lbs_piece,
  round( nvl(all_species.est_lbs_kept , 0 ), 10)    all_species_est_lbs_kept,
  round( nvl(all_species.avg_price_lb, 0 ), 10)     all_species_avg_price_lb,
  round( nvl(all_species.est_value, 0 ), 10)         all_species_est_value,
      --
  round( nvl( d7.frs_num_kept, 0 )  )          deep7_kept,
   round( nvl( d7.avg_lbs_piece, 0 ) , 10)          deep7_avg_lbs_piece,
   round( nvl( d7.est_lbs_kept , 0 ), 10)            deep7_est_lbs_kept,
  round(  nvl( d7.avg_price_lb, 0 ), 10)             deep7_avg_price_lb,
   round( nvl( d7.est_value , 0 ), 10)                deep7_est_value,
  -- nvl( d7.sold_revenue, 0 )       deep7_sold_revenue,
   --
  round( nvl( d8_14.frs_num_kept , 0 )  )  deep8_14_kept,
  round(  nvl( d8_14.avg_lbs_piece , 0 ), 10)   deep8_14_avg_lbs_piece,
   round( nvl( d8_14.est_lbs_kept, 0 ), 10)      deep8_14_est_lbs_kept,
 round(  nvl(  d8_14.avg_price_lb, 0 ), 10)      deep8_14_avg_price_lb,
   round( nvl( d8_14.est_value, 0 ), 10)           deep8_14_est_value, 
   -- non_d14
  round( nvl( non_d14.frs_num_kept, 0 )  )  non_deep14_kept,
  round( nvl(  non_d14.avg_lbs_piece, 0 ), 10)   non_deep14_avg_lbs_piece,
  round( nvl(  non_d14.est_lbs_kept, 0 ), 10)     non_deep14_est_lbs_kept,
  round( nvl(  non_d14.avg_price_lb, 0 ), 10)     non_deep14_avg_price_lb,
   round( nvl( non_d14.est_value, 0 ), 10)         non_deep14_est_value,
    --
-- onaga 22
     onaga_kept,
     round( onaga_avg_lbs_piece, 10) onaga_avg_lbs_piece ,
     round( onaga_est_lbs_kept, 10) onaga_est_lbs_kept,
     round( onaga_avg_price_lb, 10) onaga_avg_price_lb,
    round(  onaga_est_value, 10) onaga_est_value,
    -- onaga_lbs_sold,
     --onaga_num_sold,
    -- onaga_sold_revenue,
     -- ehu 21
     round( ehu_kept ) ehu_kept,
     round( ehu_avg_lbs_piece, 10) ehu_avg_lbs_piece,
     round( ehu_est_lbs_kept, 10) ehu_est_lbs_kept,
     round( ehu_avg_price_lb, 10) ehu_avg_price_lb,
     round( ehu_est_value, 10) ehu_est_value,
    -- ehu_lbs_sold,
    -- ehu_num_sold,
    -- ehu_sold_revenue, 
     -- opakapaka 19
     round( opakapaka_kept ) opakapaka_kept,
    round( opakapaka_avg_lbs_piece, 10) opakapaka_avg_lbs_piece,
    round( opakapaka_est_lbs_kept, 10) opakapaka_est_lbs_kept,
    round( opakapaka_avg_price_lb, 10) opakapaka_avg_price_lb,
    round(  opakapaka_est_value, 10) opakapaka_est_value,
    -- opakapaka_lbs_sold,
   --  opakapaka_num_sold,
    -- opakapaka_sold_revenue,     
     -- kalekale 17
    round( kalekale_kept ) kalekale_kept,
    round( kalekale_avg_lbs_piece, 10) kalekale_avg_lbs_piece,
    round( kalekale_est_lbs_kept, 10) kalekale_est_lbs_kept,
    round(  kalekale_avg_price_lb, 10) kalekale_avg_price_lb,
    round(  kalekale_est_value, 10) kalekale_est_value,
    -- kalekale_lbs_sold,
   --  kalekale_num_sold,
    -- kalekale_sold_revenue,   
     -- gindai 97
     round( gindai_kept ) gindai_kept,
     round( gindai_avg_lbs_piece, 10) gindai_avg_lbs_piece,
     round( gindai_est_lbs_kept, 10) gindai_est_lbs_kept,
     round( gindai_avg_price_lb, 10) gindai_avg_price_lb,
     round( gindai_est_value, 10) gindai_est_value,
   --  gindai_lbs_sold,
    -- gindai_num_sold,
    -- gindai_sold_revenue,    
     -- hapuupuu 15
     round( hapuupuu_kept ) hapuupuu_kept,
    round(  hapuupuu_avg_lbs_piece, 10) hapuupuu_avg_lbs_piece,
    round(  hapuupuu_est_lbs_kept, 10) hapuupuu_est_lbs_kept,
    round(  hapuupuu_avg_price_lb, 10) hapuupuu_avg_price_lb,
    round(  hapuupuu_est_value, 10) hapuupuu_est_value,
   --  hapuupuu_lbs_sold,
   --  hapuupuu_num_sold,
   --  hapuupuu_sold_revenue,    
     -- lehi 58
    round(  lehi_kept ) lehi_kept,
    round(  lehi_avg_lbs_piece, 10) lehi_avg_lbs_piece,
    round(  lehi_est_lbs_kept, 10) lehi_est_lbs_kept,
    round( lehi_avg_price_lb, 10) lehi_avg_price_lb,
   round(  lehi_est_value, 10) lehi_est_value, 
   --  lehi_lbs_sold,
   --  lehi_num_sold,
    -- lehi_sold_revenue,
     -- yellowtail_kalekale 208
    round( yellow_kalekale_kept ) yellow_kalekale_kept,
   round(  yellow_kalekale_avg_lbs_piece, 10) yellow_kalekale_avg_lbs_piece,
    round(  yellow_kalekale_est_lbs_kept, 10) yellow_kalekale_est_lbs_kept,
    round(  yellow_kalekale_avg_price_lb, 10) yellow_kalekale_avg_price_lb,
    round( yellow_kalekale_est_value, 10) yellow_kalekale_est_value,
    --     yellow_kalekale_lbs_sold,
   --  yellow_kalekale_num_sold,
    -- yellow_kalekale_sold_revenue,    
     -- uku 20
    round(  uku_kept ) uku_kept,
    round(  uku_avg_lbs_piece, 10) uku_avg_lbs_piece,
   round(  uku_est_lbs_kept, 10) uku_est_lbs_kept,
    round(  uku_avg_price_lb, 10) uku_avg_price_lb,
   round(  uku_est_value, 10) uku_est_value, 
   --  uku_lbs_sold,
    -- uku_num_sold,
    -- uku_sold_revenue,   
     -- taape 114
   round(  taape_kept ) taape_kept,
   round(  taape_avg_lbs_piece, 10) taape_avg_lbs_piece,
   round(  taape_est_lbs_kept, 10) taape_est_lbs_kept,
  round(   taape_avg_price_lb, 10) taape_avg_price_lb,
  round(    taape_est_value, 10) taape_est_value, 
   --  taape_lbs_sold,
   --  taape_num_sold,
    -- taape_sold_revenue,   
     -- white_ulua 205
   round(  white_ulua_kept ) white_ulua_kept,
   round(   white_ulua_avg_lbs_piece, 10) white_ulua_avg_lbs_piece,
   round(  white_ulua_est_lbs_kept, 10) white_ulua_est_lbs_kept,
   round(  white_ulua_avg_price_lb, 10) white_ulua_avg_price_lb,
   round(  white_ulua_est_value, 10) white_ulua_est_value,  
   --  white_ulua_lbs_sold,
   --  white_ulua_num_sold,
    -- white_ulua_sold_revenue, 
     -- black_ulua 202
    round( black_ulua_kept ) black_ulua_kept,
   round(  black_ulua_avg_lbs_piece, 10) black_ulua_avg_lbs_piece,
   round(  black_ulua_est_lbs_kept, 10) black_ulua_est_lbs_kept,
   round(  black_ulua_avg_price_lb, 10) black_ulua_avg_price_lb,
   round(  black_ulua_est_value, 10) black_ulua_est_value,  
    -- black_ulua_lbs_sold,
    -- black_ulua_num_sold,
    -- black_ulua_sold_revenue,   
     -- butaguchi 200
   round(  butaguchi_kept ) butaguchi_kept,
   round(   butaguchi_avg_lbs_piece, 10) butaguchi_avg_lbs_piece,
  round(  butaguchi_est_lbs_kept, 10) butaguchi_est_lbs_kept,
  round(   butaguchi_avg_price_lb, 10) butaguchi_avg_price_lb,
   round(  butaguchi_est_value, 10) butaguchi_est_value,  
   --  butaguchi_lbs_sold,
   --  butaguchi_num_sold,
   --  butaguchi_sold_revenue,   
     -- kahala 16
   round(  kahala_kept ) kahala_kept,
   round(  kahala_avg_lbs_piece, 10) kahala_avg_lbs_piece,
   round(  kahala_est_lbs_kept, 10) kahala_est_lbs_kept,
   round(  kahala_avg_price_lb, 10) kahala_avg_price_lb,
   round(  kahala_est_value,2 ) kahala_est_value --,
   --  kahala_lbs_sold,
   --  kahala_num_sold,
   --  kahala_sold_revenue
    from
         ( select
                    season,
                    fisher_lic_fk CML,
                    sum( fishing_days ) fishing_days,
                    sum( days_at_sea ) days_at_sea,
                    count( distinct fisher_lic_fk ) fishers,
                    count( distinct vessel ) vessels,
                    count( distinct trip_key ) trips,
                    sum( hours_fished ) hours_fished,
                    max( vessel ) vessel
            from frs_deep7_trip_headers
          group by season, fisher_lic_fk ) t,
          --
         ( select 
               season
          , fisher_lic_fk cml
          -- 22 onaga
          , max( decode( species_fk, 22,  frs_num_kept, 0 )   ) onaga_kept
          , max( decode( species_fk, 22,  sd_avg_lbs_piece , 0 ) )  onaga_avg_lbs_piece
          , max( decode( species_fk, 22,  sd_est_lbs_kept , 0 )  ) onaga_est_lbs_kept
          , max( decode( species_fk, 22,  sd_avg_price_lb , 0 ) )   onaga_avg_price_lb
          , max( decode( species_fk, 22,  sd_est_value , 0 )  ) onaga_est_value
          -- 21 ehu
          , max( decode( species_fk, 21,   frs_num_kept , 0 )  ) ehu_kept
          , max( decode( species_fk, 21,   sd_avg_lbs_piece , 0 ) )  ehu_avg_lbs_piece
          , max( decode( species_fk, 21,   sd_est_lbs_kept , 0 )  ) ehu_est_lbs_kept
          , max( decode( species_fk, 21,   sd_avg_price_lb   , 0 ) ) ehu_avg_price_lb
          , max( decode( species_fk, 21,   sd_est_value , 0 )  ) ehu_est_value
          -- 19 opakapaka
          , max( decode( species_fk, 19,   frs_num_kept, 0 )   ) opakapaka_kept
          , max( decode( species_fk, 19,   sd_avg_lbs_piece , 0 ) )  opakapaka_avg_lbs_piece
          , max( decode( species_fk, 19,   sd_est_lbs_kept, 0 )  ) opakapaka_est_lbs_kept
          , max( decode( species_fk, 19,   sd_avg_price_lb   , 0 ) ) opakapaka_avg_price_lb
          , max( decode( species_fk, 19,   sd_est_value , 0 )  ) opakapaka_est_value

          -- 17 kalekale
          , max( decode( species_fk, 17,   frs_num_kept , 0 )  ) kalekale_kept
          , max( decode( species_fk, 17,   sd_avg_lbs_piece , 0 ) )  kalekale_avg_lbs_piece
          , max( decode( species_fk, 17,   sd_est_lbs_kept , 0 )  ) kalekale_est_lbs_kept
          , max( decode( species_fk, 17,   sd_avg_price_lb   , 0 ) ) kalekale_avg_price_lb
          , max( decode( species_fk, 17,   sd_est_value , 0 )  ) kalekale_est_value
          -- 97 gindai
          , max( decode( species_fk, 97,   frs_num_kept , 0 )  ) gindai_kept
          , max( decode( species_fk, 97,   sd_avg_lbs_piece , 0 ) )  gindai_avg_lbs_piece
          , max( decode( species_fk, 97,   sd_est_lbs_kept , 0 )  ) gindai_est_lbs_kept
          , max( decode( species_fk, 97,   sd_avg_price_lb   , 0 ) ) gindai_avg_price_lb
          , max( decode( species_fk, 97,   sd_est_value , 0 )  ) gindai_est_value
          -- 15 hapuupuu
          , max( decode( species_fk, 15,   frs_num_kept , 0 )  ) hapuupuu_kept
          , max( decode( species_fk, 15,   sd_avg_lbs_piece , 0 ) )  hapuupuu_avg_lbs_piece
          , max( decode( species_fk, 15,   sd_est_lbs_kept , 0 )  ) hapuupuu_est_lbs_kept
          , max( decode( species_fk, 15,   sd_avg_price_lb   , 0 ) ) hapuupuu_avg_price_lb
          , max( decode( species_fk, 15,   sd_est_value , 0 )  ) hapuupuu_est_value
          -- 58 lehi
          , max( decode( species_fk, 58,   frs_num_kept, 0 )  ) lehi_kept
          , max( decode( species_fk, 58,   sd_avg_lbs_piece , 0 ) )  lehi_avg_lbs_piece
          , max( decode( species_fk, 58,   sd_est_lbs_kept, 0 )  ) lehi_est_lbs_kept
          , max( decode( species_fk, 58,   sd_avg_price_lb   , 0 ) ) lehi_avg_price_lb
          , max( decode( species_fk, 58,   sd_est_value, 0 )  ) lehi_est_value
          -- 208 yellow_kalekale
          , max( decode( species_fk, 208,   frs_num_kept, 0 )  ) yellow_kalekale_kept
          , max( decode( species_fk, 208,   sd_avg_lbs_piece , 0 ) )  yellow_kalekale_avg_lbs_piece
          , max( decode( species_fk, 208,   sd_est_lbs_kept , 0 )  ) yellow_kalekale_est_lbs_kept
          , max( decode( species_fk, 208,   sd_avg_price_lb   , 0 ) ) yellow_kalekale_avg_price_lb
          , max( decode( species_fk, 208,   sd_est_value , 0 )  ) yellow_kalekale_est_value
          -- 20 uku
          , max( decode( species_fk, 20,   frs_num_kept, 0 )  ) uku_kept
          , max( decode( species_fk, 20,   sd_avg_lbs_piece , 0 ) )  uku_avg_lbs_piece
          , max( decode( species_fk, 20,   sd_est_lbs_kept, 0 )  ) uku_est_lbs_kept
          , max( decode( species_fk, 20,   sd_avg_price_lb   , 0 ) ) uku_avg_price_lb
          , max( decode( species_fk, 20,   sd_est_value, 0 )  ) uku_est_value
          -- 114 taape
          , max( decode( species_fk, 114,   frs_num_kept , 0 )  ) taape_kept
          , max( decode( species_fk, 114,   sd_avg_lbs_piece , 0 ) )  taape_avg_lbs_piece
          , max( decode( species_fk, 114,   sd_est_lbs_kept, 0 )  ) taape_est_lbs_kept
          , max( decode( species_fk, 114,   sd_avg_price_lb   , 0 ) ) taape_avg_price_lb
          , max( decode( species_fk, 114,   sd_est_value , 0 )  ) taape_est_value
          -- 205 white_ulua
          , max( decode( species_fk, 205,    frs_num_kept , 0 )  ) white_ulua_kept
          , max( decode( species_fk, 205,   sd_avg_lbs_piece , 0 ) )  white_ulua_avg_lbs_piece
          , max( decode( species_fk, 205,   sd_est_lbs_kept, 0 )  ) white_ulua_est_lbs_kept
          , max( decode( species_fk, 205,   sd_avg_price_lb   , 0 ) ) white_ulua_avg_price_lb
          , max( decode( species_fk, 205,   sd_est_value , 0 )  ) white_ulua_est_value
          -- 202 black_ulua
          , max( decode( species_fk, 202,   frs_num_kept, 0 )  ) black_ulua_kept
          , max( decode( species_fk, 202,   sd_avg_lbs_piece , 0 ) )  black_ulua_avg_lbs_piece
          , max( decode( species_fk, 202,   sd_est_lbs_kept , 0 )  ) black_ulua_est_lbs_kept
          , max( decode( species_fk, 202,   sd_avg_price_lb   , 0 ) ) black_ulua_avg_price_lb
          , max( decode( species_fk, 202,   sd_est_value, 0 )  ) black_ulua_est_value
          -- 200 butaguchi
          , max( decode( species_fk, 200,   frs_num_kept, 0 )  ) butaguchi_kept
          , max( decode( species_fk, 200,   sd_avg_lbs_piece , 0 ) )  butaguchi_avg_lbs_piece
          , max( decode( species_fk, 200,   sd_est_lbs_kept , 0 )  ) butaguchi_est_lbs_kept
          , max( decode( species_fk, 200,   sd_avg_price_lb   , 0 ) ) butaguchi_avg_price_lb
          , max( decode( species_fk, 200,   sd_est_value, 0 )  ) butaguchi_est_value
          -- 16 kahala
          , max( decode( species_fk, 16,   frs_num_kept, 0 )  ) kahala_kept
          , max( decode( species_fk, 16,   sd_avg_lbs_piece , 0 ) )  kahala_avg_lbs_piece
          , max( decode( species_fk, 16,   sd_est_lbs_kept , 0 )  ) kahala_est_lbs_kept
          , max( decode( species_fk, 16,   sd_avg_price_lb   , 0 ) ) kahala_avg_price_lb
          , max( decode( species_fk, 16,   sd_est_value , 0 )  ) kahala_est_value
     from
          frs_deep7_cml_season_species
     group by season, fisher_lic_fk ) frs,
         ( select
            frs.season  -- d7 totals
          , frs.fisher_lic_fk cml  
          , sum(  frs_num_kept ) frs_num_kept
          , sum(  sd_est_lbs_kept  ) / nullif( sum( frs_num_kept ), 0 ) avg_lbs_piece
          , sum(  sd_est_lbs_kept ) est_lbs_kept
          , sum(  sd_est_value  ) / nullif( sum( sd_est_lbs_kept ), 0 ) avg_price_lb
          , sum(  sd_est_value ) est_value
       from
                  frs_deep7_cml_season_species frs
     where 
         species_fk  in ( 22, 21, 19, 17, 97, 15, 58 )
         and frs_num_kept > 0
     group by
         frs.season, frs.fisher_lic_fk) d7,
          --
         ( select
              frs.season  -- d8_14 id totals  
           ,  frs.fisher_lic_fk cml
          , sum(  frs_num_kept ) frs_num_kept
          , sum(  sd_est_lbs_kept  ) / nullif( sum( frs_num_kept ), 0 ) avg_lbs_piece
          , sum(  sd_est_lbs_kept ) est_lbs_kept
          , sum(  sd_est_value  ) / nullif( sum( sd_est_lbs_kept ), 0 ) avg_price_lb
          , sum(  sd_est_value ) est_value
       from
         frs_deep7_cml_season_species frs
     where 
         species_fk  in (  208, 20, 114, 205, 202, 200, 16 )
         and frs_num_kept > 0
     group by
         frs.season, frs.fisher_lic_fk)  d8_14,
          --
         ( select 
            season  -- non_d14 id totals 
          ,  fisher_lic_fk cml
          , sum(  frs_num_kept ) frs_num_kept
          , sum(  sd_est_lbs_kept  ) / nullif( sum( frs_num_kept ), 0 ) avg_lbs_piece
          , sum(  sd_est_lbs_kept ) est_lbs_kept
          , sum(  sd_est_value  ) / nullif( sum( sd_est_lbs_kept ), 0 ) avg_price_lb
          , sum(  sd_est_value ) est_value
       from
         frs_deep7_cml_season_species
     where 
         species_fk  not in (  22, 21, 19, 17, 97, 15, 58, 208, 20, 114, 205, 202, 200, 16 )
     group by
         season, fisher_lic_fk)  non_d14,
          --
         ( select 
             season -- all species 
          ,  fisher_lic_fk cml
          , sum(  frs_num_kept ) frs_num_kept
          , sum(  sd_est_lbs_kept  ) / nullif( sum( frs_num_kept ), 0 ) avg_lbs_piece
          , sum(  sd_est_lbs_kept ) est_lbs_kept
          , sum(  sd_est_value  ) / nullif( sum( sd_est_lbs_kept ), 0 ) avg_price_lb
          , sum(  sd_est_value ) est_value
       from
         frs_deep7_cml_season_species
     group by
         season, fisher_lic_fk)  all_species
      where
                frs.season (+) = d7.season
          and t.season  (+) = d7.season
          and d8_14.season (+) = d7.season
          and non_d14.season (+) = d7.season
          and all_species.season (+) = d7.season
          and frs.cml (+) = d7.cml
          and t.cml (+) = d7.cml
          and d8_14.cml (+) = d7.cml
          and non_d14.cml (+) = d7.cml
          and all_species.cml (+) = d7.cml
 );