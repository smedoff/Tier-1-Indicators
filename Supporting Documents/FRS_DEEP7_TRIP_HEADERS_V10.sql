-- FRS_DEEP7_TRIP_HEADERS-10.sql
-- ksender 2018 12 05
-- v8 modified to run from PROD
-- v9 used for 2018 run
-- v10 used for 2019 run no change

--RENAME FRS_DEEP7_TRIP_HEADERS TO FRS_DEEP7_TRIP_HEADERS_2018;

--DROP TABLE FRS_DEEP7_TRIP_HEADERS;
 
CREATE TABLE FRS_DEEP7_TRIP_HEADERS as
select
     season,
     fisher_lic_fk,
     trip_key,
     report_key,
     fishing_days,
     trip_begin_date,     
     trip_end_date,
              --
         case when trip_begin_date < season_start_date then season_start_date else trip_begin_date end start_date,
         case when trip_end_date > season_end_date then season_end_date else trip_end_date end end_date,  
                
         ( case when trip_end_date > season_end_date then season_end_date else trip_end_date end )  -
               (  case when trip_begin_date < season_start_date then season_start_date else trip_begin_date end ) + 1 days_at_sea,            
     FIRST_FISHING_DATE,
     LAST_FISHING_DATE,
     hours_fished,
     vessel
 from (
 with temp as
(
select
     year_title season,
     season_start_date,
     season_end_date,
     s.year season_year,
     fisher_lic_fk,
     trip_begin_date,
     trip_end_date,
     hours_fished,
     area_fk,
     gear_fk,
     -- trip_key
     NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
                                                       lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) ) AS trip_key,
     -- fishing_day_key
                    NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
                                                       lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) ) || lpad( to_char( fished_date), 6, '0' )  AS fishing_day_key,
     -- report_key
      lpad( to_char( fisher_lic_fk), 6, '0' )  ||  to_char( decode( report_year, 0, to_char( trip_end_date, 'YYYY' ), report_year ) ) || lpad( to_char( decode( report_month, 0, to_char( trip_end_date, 'MM' ), report_month ) ) , 2, '0'  ) report_key,                                               
     fished_date,
     report_year,
     report_month,
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
       llds_fishery_seasons s, 
       wp_hawaii.h_frs_area a
where
       s.fishery = 'MHIB'
       and gear_fk <> 2
       and ( num_kept > 0 or frs.lbs_kept > 0 )
       and fisher_lic_fk is not null
       and a.area_pk  = frs.area_fk
       and area between 1 and 999
      and fished_date between s.season_start_date and s.season_end_date
      and       NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || lpad(  to_char( trip_end_date, 'YYYYMMDD' ), 8, '0' ),
                                                       lpad( to_char( fisher_lic_fk), 6, '0' )  || lpad ( to_char( fished_date, 'YYYYMMDD' ), 8, '0' ) )
       in (select
                   NVL2(TRIP_END_DATE,  lpad( to_char( fisher_lic_fk), 6, '0' )   || to_char( trip_end_date, 'YYYYMMDD' ),
                                                       lpad( to_char( fisher_lic_fk), 6, '0' )  || to_char( fished_date, 'YYYYMMDD' ) ) trip_key
             from
                  wp_hawaii.h_frs frs,
                  wp_hawaii.h_frs_area ar
          where
                        substr(   decode( trip_end_date, NULL, to_char( fished_date, 'YYYYMMDD' ) || lpad( to_char( fisher_lic_fk), 6, '0' ),
                                                to_char( trip_end_date, 'YYYYMMDD' ) || lpad( to_char( fisher_lic_fk), 6, '0' ) ), 1, 4 ) > 2000
                     and species_fk in ( 22, 21, 19, 17, 97, 15, 58 )
       and gear_fk <> 2
       and ( num_kept > 0 or frs.lbs_kept > 0 )
       and fisher_lic_fk is not null
       and ar.area_pk  = frs.area_fk
       and area between 1 and 999 )
 )
  select
     t.season,
     season_start_date,
     season_end_date,
     season_year,
     t.fisher_lic_fk,
     t.trip_key,
     t.report_key,
     -- lpad( to_char( fisher_lic_fk), 6, '0' )  ||  to_char( report_year ) || lpad( to_char( report_month ), 2, '0'  ) report_key,
     count( distinct fishing_day_key ) fishing_days,
     /*
     ( max( fished_date ) - min( fished_date ) + 1 ) days_at_sea,
     NVL2( min( trip_begin_date ), min( trip_begin_date ), min(fished_date ) )  trip_begin_date,
     NVL2( max( trip_end_date ),  max( trip_end_date ),  max( fished_date ) )  trip_end_date,
     */
     CASE WHEN min(trip_begin_date ) is null THEN min(fished_date )
              ELSE min( trip_begin_date ) END AS trip_begin_date,     
     CASE WHEN max(trip_end_date ) is null THEN max(fished_date )
              ELSE max( trip_end_date ) END AS trip_end_date,
              --
     min( fished_date) FIRST_FISHING_DATE,
     max( fished_date) LAST_FISHING_DATE,
     sum( hours_fished ) hours_fished,
     max(vessel ) vessel
 from temp t
 group by
     t.season,
     season_start_date,
     season_end_date,
     season_year,
     t.trip_key,
     t.report_key,
     t.fisher_lic_fk
 );
 
 -- check to see no dups
 select season, trip_key, count( *) from frs_deep7_trip_headers group by season, trip_key order by 3 desc, 1;