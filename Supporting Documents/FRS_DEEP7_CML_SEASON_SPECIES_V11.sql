-- FRS_DEEP7_CML_SEASON_SPECIES_v10.sql
-- ksender 2018 12 05
-- 03:23 min
-- v 11   (no change from v 10)

-- only need to save last year's temporarily to help check data. Clean up later
--RENAME FRS_DEEP7_CML_SEASON_SPECIES to FRS_DEEP7_CML_SEASON_SPP_2018;

--DROP TABLE FRS_DEEP7_CML_SEASON_SPECIES;

CREATE TABLE FRS_DEEP7_CML_SEASON_SPECIES as (
         -----join together to get season/cml species data
 select
   frs.season,
   frs.fisher_lic_fk,
   frs.species_fk,
   frs.species_name,
    ( frs_num_kept + floor( frs_lbs_only / nullif( round( sd_lbs_sold/nullif(sd_num_sold, 0 ), 2 ), 0 ) ) ) frs_num_kept,
   frs_num_kept orig_num_kept,
   frs_lbs_only,
  -- cml_num_sold,
   --cml_lbs_sold,
   --cml_sold_revenue,
  --
   --cml_lbs_sold/nullif(cml_num_sold, 0 ) cml_avg_lbs_piece,
   --cml_sold_revenue/nullif( cml_lbs_sold, 0 ) cml_avg_price_lb,
  -- frs_num_kept * cml_lbs_sold/nullif(cml_num_sold, 0 ) cml_est_lbs_kept,
   --frs_num_kept * cml_lbs_sold/nullif(cml_num_sold, 0 ) * cml_sold_revenue/nullif( cml_lbs_sold, 0 ) cml_est_value,
   --
   floor( frs_lbs_only / nullif ( round( sd_lbs_sold/nullif(sd_num_sold, 0 ), 2 ), 0 ) ) extra_num_kept,
   sd_lbs_sold/nullif(sd_num_sold, 0 ) sd_avg_lbs_piece,
   sd_sold_revenue/nullif( sd_lbs_sold, 0 ) sd_avg_price_lb,
   ( frs_num_kept + floor( frs_lbs_only / nullif( sd_lbs_sold/nullif(sd_num_sold, 0 ), 0 ) ) ) * sd_lbs_sold/nullif(sd_num_sold, 0 ) sd_est_lbs_kept,
   ( frs_num_kept + floor( frs_lbs_only / nullif ( sd_lbs_sold/nullif(sd_num_sold, 0 ), 0 ) ) ) * sd_lbs_sold/nullif(sd_num_sold, 0 ) * sd_sold_revenue/nullif(sd_lbs_sold, 0 ) sd_est_value
 --
  from          
 ( select
                    season,
                    fisher_lic_fk,
                    species_fk,
                    species_name,
                    sum( frs_num_kept ) frs_num_kept,
                    /*
                    sum( CASE WHEN frs_num_kept > 0 THEN 0
                              ELSE CASE WHEN frs_lbs_kept > 0 THEN frs_lbs_kept else frs_lbs_sold  end end ) frs_lbs_only
                    */
                    -- sometimes there is no reported num_kept but there is a reported kept_lbs
                    -- need to accumulate these as frs_lbs_only which can be converted to pieces and added to num_kept
                    sum( CASE WHEN frs_num_kept > 0 THEN 0
                              ELSE frs_lbs_sold  end ) frs_lbs_only         
            from frs_deep7_detail
          group by season, fisher_lic_fk, species_fk, species_name ) frs,            
(select 
         season,
         dar_species,
         num_sold  sd_num_sold,
         lbs_sold  sd_lbs_sold,
         sold_revenue  sd_sold_revenue
 from
        id_deep7_season_species_v
            ) sd
where
          sd.season (+) = frs.season
    and sd.dar_species (+)  = frs.species_fk
)
 ;