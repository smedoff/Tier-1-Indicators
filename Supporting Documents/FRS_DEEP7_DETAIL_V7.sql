-- FRS_DEEP7_DETAIL_v7.sql
-- ksender 2012 12 05
-- v7    (no change from v 6)

-- only need to save last year's temporarily to help check data. Clean up later
RENAME FRS_DEEP7_DETAIL TO FRS_DEEP7_DETAIL_2018;

--DROP TABLE FRS_DEEP7_DETAIL;
 
 CREATE TABLE FRS_DEEP7_DETAIL as (
 select
     year_title season,
     fisher_lic_fk ,
     species_fk,
     species_name,
     num_kept       frs_num_kept,
    num_sold       frs_num_sold,
    num_lost        frs_num_lost,
    lbs_kept         frs_lbs_kept,
    lbs_sold         frs_lbs_sold,
     sold_revenue   frs_sold_revenue,
      -- trip_key
     NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
                                                       lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) ) AS trip_key,
     -- fishing_day_key
                    NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
                                                       lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) ) || lpad( to_char( fished_date), 6, '0' )  AS fishing_day_key,
     -- report_key
      lpad( to_char( fisher_lic_fk), 6, '0' )  ||  to_char( report_year ) || lpad( to_char( report_month ), 2, '0'  ) report_key,                                             
     fished_date,
     report_year,
    CASE WHEN
                       uscg_vessel_reg is null  or uscg_vessel_reg = 'N/A' THEN
                              CASE WHEN
                                   ha_vessel_reg is null THEN
                                           CASE WHEN
                                               vessel_name is null THEN
                                                   'CML' || lpad( to_char( fisher_lic_fk), 6, '0' )
                                               ELSE
                                                    vessel_name
                                               END
                                   ELSE
                                        'HA' || replace(translate(ha_vessel_reg, translate(ha_vessel_reg, '01234567890', ' '), ' '), ' ','')
                              END
                       ELSE
                              uscg_vessel_reg
      END vessel,
      vessel_name,
     uscg_vessel_reg,
     ha_vessel_reg
   from
       wp_hawaii.h_frs frs, 
       wp_hawaii.h_frs_area a,
       llds_fishery_seasons s,
       wp_hawaii.h_frs_species sp
where
              gear_fk <> 2                 
       and ( num_kept > 0 or lbs_kept > 0 or lbs_sold > 0 )
       and frs.fisher_lic_fk is not null
       and a.area_pk  = frs.area_fk
      and area between 1 and 999
      and fished_date between s.season_start_date and s.season_end_date
      and sp.species_pk = frs.species_fk 
       and        NVL2(frs.TRIP_END_DATE,  lpad( to_char( frs.fisher_lic_fk), 6, '0' )   || lpad(  to_char( frs.trip_end_date, 'YYYYMMDD' ), 8, '0' ),
                                                       lpad( to_char( frs.fisher_lic_fk), 6, '0' )  || lpad ( to_char( frs.fished_date, 'YYYYMMDD' ), 8, '0' ) )
                        in (select
                                  trip_key from frs_deep7_trip_headers ) )
;


select season, count( distinct trip_key ) from FRS_DEEP7_DETAIL
group by season
order by season;

/* from 20181205 (v6)
SEASON    COUNT(DISTINCTTRIP_KEY)
2013 - 2014    3172
2014 - 2015    2879
2015 - 2016    2310
2016 - 2017    2346
2017 - 2018    2149
*/

/* from 20180118 (v5)
SEASON    COUNT(DISTINCTTRIP_KEY)
2002    2989
2003    2870
2004    2766
2005    2588
2006    2399
2007    1222
2007 - 2008    2340
2008 - 2009    3263
2009 - 2010    2786
2010 - 2011    3424
2011 - 2012    3080
2012 - 2013    2977
2013 - 2014    3172
2014 - 2015    2886
2015 - 2016    2346
2016 - 2017    2329

*/
/*
PRIOR Run
SEASON                         COUNT(DISTINCTTRIP_KEY)                
2002                           2989                                   
2003                           2868                                   
2004                           2755                                   
2005                           2583                                   
2006                           2386                                   
2007                           1219                                   
2007 - 2008                    2339                                   
2008 - 2009                    3263                                   
2009 - 2010                    2784                                   
2010 - 2011                    3421                                   
2011 - 2012                    3078                                   
2012 - 2013                    2977                                   
2013 - 2014                    3163                                   
2014 - 2015                    2860                                   

*/