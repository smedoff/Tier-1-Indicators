-- TIER_1_DEEP7_SEASON_RPT_V11.sql
-- ksender 2018 12 05
-- v10 2018
-- v11 2019 no change

-- remember to edit suffix of table by run date in both CREATE and FROM lines
CREATE  TABLE TIER_1_D7_SEASON_RPT20191212 AS (
select
     t.season,
     summ.trips,
     summ.fishers,
     summ.days_at_sea,
     summ.fishing_days,
     t.vessels,
     round( summ.hours_fished ) hours_fished,
   -- all_species
  all_species_kept,
  round( all_species_avg_lbs_piece, 10)    all_species_avg_lbs_piece,
  round( all_species_est_lbs_kept, 10 )      all_species_est_lbs_kept,
  round( all_species_avg_price_lb, 10)      all_species_avg_price_lb,
  round( all_species_est_value, 10 )         all_species_est_value,
      --
   deep7_kept,
   round( deep7_avg_lbs_piece , 10)           deep7_avg_lbs_piece,
   round( deep7_est_lbs_kept, 10 )             deep7_est_lbs_kept,
   round( deep7_avg_price_lb , 10)             deep7_avg_price_lb,
   round( deep7_est_value, 10 )                  deep7_est_value,
   --
   deep8_14_kept,
   round( deep8_14_avg_lbs_piece, 10)     deep8_14_avg_lbs_piece,
   round( deep8_14_est_lbs_kept, 10 )       deep8_14_est_lbs_kept,
   round( deep8_14_avg_price_lb, 10)       deep8_14_avg_price_lb,
   round( deep8_14_est_value, 10 )            deep8_14_est_value,
   -- non_d14
   non_deep14_kept,
   round( non_deep14_avg_lbs_piece, 10)    non_deep14_avg_lbs_piece,
   round( non_deep14_est_lbs_kept, 10 )      non_deep14_est_lbs_kept,
   round( non_deep14_avg_price_lb, 10)      non_deep14_avg_price_lb,
   round( non_deep14_est_value, 10 )          non_deep14_est_value,
    --
-- onaga 22
     onaga_kept,
     round( onaga_avg_lbs_piece, 10) onaga_avg_lbs_piece,
     round( onaga_est_lbs_kept, 10 ) onaga_est_lbs_kept,
     round( onaga_avg_price_lb, 10) onaga_avg_price_lb,
     round( onaga_est_value, 10 ) onaga_est_value,
     -- ehu 21
     ehu_kept,
     round( ehu_avg_lbs_piece, 10) ehu_avg_lbs_piece,
     round( ehu_est_lbs_kept, 10 ) ehu_est_lbs_kept ,
     round( ehu_avg_price_lb, 10) ehu_avg_price_lb,
     round( ehu_est_value, 10 ) ehu_est_value,
     -- opakapaka 19
     opakapaka_kept,
    round( opakapaka_avg_lbs_piece, 10) opakapaka_avg_lbs_piece,
    round( opakapaka_est_lbs_kept, 10 ) opakapaka_est_lbs_kept,
    round( opakapaka_avg_price_lb, 10) opakapaka_avg_price_lb ,
     round( opakapaka_est_value, 10 ) opakapaka_est_value,  
     -- kalekale 17
     kalekale_kept,
    round( kalekale_avg_lbs_piece, 10) kalekale_avg_lbs_piece,
    round( kalekale_est_lbs_kept, 10 ) kalekale_est_lbs_kept,
     round( kalekale_avg_price_lb, 10) kalekale_avg_price_lb,
    round(  kalekale_est_value, 10 ) kalekale_est_value, 
     -- gindai 97
     gindai_kept,
    round(  gindai_avg_lbs_piece, 10) gindai_avg_lbs_piece,
    round(  gindai_est_lbs_kept, 10 ) gindai_est_lbs_kept ,
    round(  gindai_avg_price_lb, 10) gindai_avg_price_lb,
    round(  gindai_est_value, 10 ) gindai_est_value,     
     -- hapuupuu 15
     hapuupuu_kept,
     round( hapuupuu_avg_lbs_piece, 10) hapuupuu_avg_lbs_piece ,
     round( hapuupuu_est_lbs_kept, 10 ) hapuupuu_est_lbs_kept,
    round(  hapuupuu_avg_price_lb, 10) hapuupuu_avg_price_lb,
     round( hapuupuu_est_value, 10 ) hapuupuu_est_value,     
     -- lehi 58
     lehi_kept,
     round( lehi_avg_lbs_piece, 10) lehi_avg_lbs_piece ,
    round(  lehi_est_lbs_kept, 10 ) lehi_est_lbs_kept ,
   round(  lehi_avg_price_lb, 10) lehi_avg_price_lb,
   round(  lehi_est_value, 10 ) lehi_est_value , 
     -- yellowtail_kalekale
     yellow_kalekale_kept,
    round( yellow_kalekale_avg_lbs_piece, 10) yellow_kalekale_avg_lbs_piece ,
    round(  yellow_kalekale_est_lbs_kept, 10 ) yellow_kalekale_est_lbs_kept ,
    round(  yellow_kalekale_avg_price_lb, 10) yellow_kalekale_avg_price_lb,
    round( yellow_kalekale_est_value, 10 ) yellow_kalekale_est_value,    
     -- uku 20
     uku_kept,
    round(  uku_avg_lbs_piece, 10) uku_avg_lbs_piece,
    round( uku_est_lbs_kept, 10 ) uku_est_lbs_kept,
    round( uku_avg_price_lb, 10) uku_avg_price_lb,
    round(  uku_est_value, 10 ) uku_est_value,
     -- taape 114
     taape_kept,
   round(  taape_avg_lbs_piece, 10) taape_avg_lbs_piece,
   round(  taape_est_lbs_kept, 10 ) taape_est_lbs_kept,
    round( taape_avg_price_lb, 10) taape_avg_price_lb,
    round(  taape_est_value, 10 ) taape_est_value ,   
     -- white_ulua 205
       white_ulua_kept,
   round(  white_ulua_avg_lbs_piece, 10) white_ulua_avg_lbs_piece,
   round(  white_ulua_est_lbs_kept, 10 ) white_ulua_est_lbs_kept,
   round(  white_ulua_avg_price_lb, 10) white_ulua_avg_price_lb ,
    round( white_ulua_est_value, 10 ) white_ulua_est_value,   
     -- black_ulua 202
    black_ulua_kept,
    round( black_ulua_avg_lbs_piece, 10) black_ulua_avg_lbs_piece,
    round( black_ulua_est_lbs_kept, 10 ) black_ulua_est_lbs_kept,
    round( black_ulua_avg_price_lb, 10) black_ulua_avg_price_lb,
    round( black_ulua_est_value, 10 ) black_ulua_est_value,    
     -- butaguchi 200
     butaguchi_kept,
   round(   butaguchi_avg_lbs_piece, 10) butaguchi_avg_lbs_piece ,
   round(  butaguchi_est_lbs_kept, 10 ) butaguchi_est_lbs_kept,
   round(  butaguchi_avg_price_lb, 10) butaguchi_avg_price_lb,
   round(  butaguchi_est_value, 10 ) butaguchi_est_value,     
     -- kahala 16
      kahala_kept,
    round(  kahala_avg_lbs_piece, 10) kahala_avg_lbs_piece,
    round(  kahala_est_lbs_kept, 10 ) kahala_est_lbs_kept ,
    round(  kahala_avg_price_lb, 10) kahala_avg_price_lb,
   round(  kahala_est_value, 10 )   kahala_est_value
    from
         ( select
                    season,
                    sum( fishing_days ) fishing_days,
                    sum( days_at_sea ) days_at_sea,
                    count( distinct fisher_lic_fk ) fishers,
                    count( distinct vessel ) vessels,
                    count( distinct trip_key ) trips,
                    sum( hours_fished ) hours_fished
            from frs_deep7_trip_headers
          group by season ) t,
          --
         ( select season, sum( trips ) trips, count( cml ) fishers, sum( days_at_sea ) days_at_sea, sum( fishing_days ) fishing_days, sum( hours_fished ) hours_fished,
                     --
                     sum( all_species_kept ) all_species_kept, 
                     sum( all_species_est_lbs_kept) / nullif( sum( all_species_kept ), 0 ) all_species_avg_lbs_piece,
                     sum( all_species_est_lbs_kept) all_species_est_lbs_kept, 
                     sum( all_species_est_value) / nullif( sum( all_species_est_lbs_kept), 0 ) all_species_avg_price_lb,
                     sum( all_species_est_value) all_species_est_value,
                     --
                     sum( deep7_kept ) deep7_kept, 
                     sum( deep7_est_lbs_kept) / nullif( sum( deep7_kept ), 0 ) deep7_avg_lbs_piece,
                     sum( deep7_est_lbs_kept) deep7_est_lbs_kept, 
                     sum( deep7_est_value) / nullif( sum( deep7_est_lbs_kept), 0 ) deep7_avg_price_lb,
                     sum( deep7_est_value) deep7_est_value,
                     --
                     sum( deep8_14_kept ) deep8_14_kept, 
                     sum( deep8_14_est_lbs_kept) / nullif( sum( deep8_14_kept ), 0 ) deep8_14_avg_lbs_piece,
                     sum( deep8_14_est_lbs_kept) deep8_14_est_lbs_kept, 
                     sum( deep8_14_est_value) / nullif( sum( deep8_14_est_lbs_kept), 0 ) deep8_14_avg_price_lb,
                     sum( deep8_14_est_value) deep8_14_est_value,
                     --
                     sum( non_deep14_kept ) non_deep14_kept, 
                     sum( non_deep14_est_lbs_kept) / nullif( sum( non_deep14_kept ), 0 ) non_deep14_avg_lbs_piece,
                     sum( non_deep14_est_lbs_kept) non_deep14_est_lbs_kept, 
                     sum( non_deep14_est_value) / nullif( sum( non_deep14_est_lbs_kept), 0 ) non_deep14_avg_price_lb,
                     sum( non_deep14_est_value) non_deep14_est_value,
                     --
                     sum( onaga_kept ) onaga_kept, 
                     sum( onaga_est_lbs_kept) / nullif( sum( onaga_kept ), 0 ) onaga_avg_lbs_piece,
                     sum( onaga_est_lbs_kept) onaga_est_lbs_kept, 
                     sum( onaga_est_value) / nullif( sum( onaga_est_lbs_kept), 0 ) onaga_avg_price_lb,
                     sum( onaga_est_value) onaga_est_value,
                     --
                     sum( ehu_kept ) ehu_kept, 
                     sum( ehu_est_lbs_kept) / nullif( sum( ehu_kept ), 0 ) ehu_avg_lbs_piece,
                     sum( ehu_est_lbs_kept) ehu_est_lbs_kept, 
                     sum( ehu_est_value) / nullif( sum( ehu_est_lbs_kept), 0 ) ehu_avg_price_lb,
                     sum( ehu_est_value) ehu_est_value,
                     --
                     sum( opakapaka_kept ) opakapaka_kept, 
                     sum( opakapaka_est_lbs_kept) / nullif( sum( opakapaka_kept ), 0 ) opakapaka_avg_lbs_piece,
                     sum( opakapaka_est_lbs_kept) opakapaka_est_lbs_kept, 
                     sum( opakapaka_est_value) / nullif( sum( opakapaka_est_lbs_kept), 0 ) opakapaka_avg_price_lb,
                     sum( opakapaka_est_value) opakapaka_est_value,
                     --
                     sum( kalekale_kept ) kalekale_kept,
                     sum( kalekale_est_lbs_kept) / nullif( sum( kalekale_kept ), 0 ) kalekale_avg_lbs_piece,
                     sum( kalekale_est_lbs_kept) kalekale_est_lbs_kept, 
                     sum( kalekale_est_value) / nullif( sum( kalekale_est_lbs_kept), 0 ) kalekale_avg_price_lb,
                     sum( kalekale_est_value) kalekale_est_value,
                     --
                     sum( gindai_kept ) gindai_kept, 
                     sum( gindai_est_lbs_kept) / nullif( sum( gindai_kept ), 0 ) gindai_avg_lbs_piece,
                     sum( gindai_est_lbs_kept) gindai_est_lbs_kept, 
                     sum( gindai_est_value) / nullif( sum( gindai_est_lbs_kept), 0 ) gindai_avg_price_lb,
                     sum( gindai_est_value) gindai_est_value,
                     --
                     sum( hapuupuu_kept ) hapuupuu_kept, 
                     sum( hapuupuu_est_lbs_kept) / nullif( sum( hapuupuu_kept ), 0 ) hapuupuu_avg_lbs_piece,
                     sum( hapuupuu_est_lbs_kept) hapuupuu_est_lbs_kept, 
                     sum( hapuupuu_est_value) / nullif( sum( hapuupuu_est_lbs_kept), 0 ) hapuupuu_avg_price_lb,
                     sum( hapuupuu_est_value) hapuupuu_est_value,
                     --
                     sum( lehi_kept ) lehi_kept, 
                     sum( lehi_est_lbs_kept) / nullif( sum( lehi_kept ), 0 ) lehi_avg_lbs_piece,
                     sum( lehi_est_lbs_kept) lehi_est_lbs_kept, 
                     sum( lehi_est_value) / nullif( sum( lehi_est_lbs_kept), 0 ) lehi_avg_price_lb,
                     sum( lehi_est_value) lehi_est_value,
                     --
                     sum( yellow_kalekale_kept ) yellow_kalekale_kept, 
                     sum( yellow_kalekale_est_lbs_kept) / nullif( sum( yellow_kalekale_kept ), 0 ) yellow_kalekale_avg_lbs_piece,
                     sum( yellow_kalekale_est_lbs_kept) yellow_kalekale_est_lbs_kept, 
                     sum( yellow_kalekale_est_value) / nullif( sum( yellow_kalekale_est_lbs_kept), 0 ) yellow_kalekale_avg_price_lb,
                     sum( yellow_kalekale_est_value) yellow_kalekale_est_value,
                     --
                     sum( uku_kept ) uku_kept, 
                     sum( uku_est_lbs_kept) / nullif( sum( uku_kept ), 0 ) uku_avg_lbs_piece,
                     sum( uku_est_lbs_kept) uku_est_lbs_kept, 
                     sum( uku_est_value) / nullif (sum( uku_est_lbs_kept), 0 ) uku_avg_price_lb,
                     sum( uku_est_value) uku_est_value,
                     --
                     sum( taape_kept ) taape_kept, 
                     sum( taape_est_lbs_kept) / nullif( sum( taape_kept ), 0 ) taape_avg_lbs_piece,
                     sum( taape_est_lbs_kept) taape_est_lbs_kept, 
                     sum( taape_est_value) / nullif( sum( taape_est_lbs_kept), 0 ) taape_avg_price_lb,
                     sum( taape_est_value) taape_est_value,
                     --
                     sum( white_ulua_kept ) white_ulua_kept, 
                     sum( white_ulua_est_lbs_kept) / nullif( sum( white_ulua_kept ), 0 ) white_ulua_avg_lbs_piece,
                     sum( white_ulua_est_lbs_kept) white_ulua_est_lbs_kept, 
                     sum( white_ulua_est_value) / nullif( sum( white_ulua_est_lbs_kept), 0 ) white_ulua_avg_price_lb,
                     sum( white_ulua_est_value) white_ulua_est_value,
                     --
                     sum( black_ulua_kept ) black_ulua_kept, 
                     sum( black_ulua_est_lbs_kept) / nullif( sum( black_ulua_kept ), 0 ) black_ulua_avg_lbs_piece,
                     sum( black_ulua_est_lbs_kept) black_ulua_est_lbs_kept, 
                     sum( black_ulua_est_value) / nullif( sum( black_ulua_est_lbs_kept), 0 ) black_ulua_avg_price_lb,
                     sum( black_ulua_est_value) black_ulua_est_value,
                     --
                     sum( butaguchi_kept ) butaguchi_kept, 
                     sum( butaguchi_est_lbs_kept) / nullif( sum( butaguchi_kept ), 0 ) butaguchi_avg_lbs_piece,
                     sum( butaguchi_est_lbs_kept) butaguchi_est_lbs_kept,
                     sum( butaguchi_est_value) / nullif( sum( butaguchi_est_lbs_kept), 0 ) butaguchi_avg_price_lb,
                     sum( butaguchi_est_value) butaguchi_est_value,
                     --
                     sum( kahala_kept ) kahala_kept, 
                     sum( kahala_est_lbs_kept) / nullif( sum( kahala_kept ), 0 ) kahala_avg_lbs_piece,
                     sum( kahala_est_lbs_kept) kahala_est_lbs_kept, 
                     sum( kahala_est_value) / nullif( sum( kahala_est_lbs_kept), 0 ) kahala_avg_price_lb,
                     sum( kahala_est_value) kahala_est_value
                     --
 --************** edit table suffix
from TIER_1_D7_CML_RPT20191212
group by season ) summ
      where
                summ.season (+) = t.season
);