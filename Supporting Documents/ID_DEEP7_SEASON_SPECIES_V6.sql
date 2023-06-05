-- ID_DEEP7_SEASON_SPECIES_V6.sql
-- ksender 2018 12 05
--get annual mean weights and prices for the deep-7 species
-- using only data from trips that caught at least one deep7
-- v5 2018 run
-- v6 2019 run no change

CREATE OR REPLACE FORCE VIEW ID_DEEP7_SEASON_SPECIES_V
(
 SEASON,
 DAR_SPECIES,
 SPECIES_NAME,
 NUM_SOLD,
 LBS_SOLD,
 SOLD_REVENUE,
 AVG_LBS_PIECE,
 AVG_PRICE_LB
)
AS
(
-- summary by season, cml, species of the Integrated Dealer data
select * from (
with temp as
(
 select --group frs trips by report_key
season,
frs.fisher_lic_fk,
frs.report_key,
id.species_fk,
species_name,
   sum(NUM_SOLD ) num_sold,
   sum( LBS_SOLD ) lbs_sold, 
   sum(SOLD_REVENUE) sold_revenue
from
         (  select   --group frs trips by report_key
                season,
                fisher_lic_fk,
                report_key,
               count (*) trips_per_report
            from frs_deep7_trip_headers t
           group by season, fisher_lic_fk,report_key ) frs,     
       wp_hawaii.h_frs_species sp,
       ( SELECT 
           sum( num_sold ) num_sold,
           sum( lbs_sold ) lbs_sold,
           sum( sold_revenue ) sold_revenue,
            FISHER_LIC_FK,
            lpad( id.fisher_lic_fk, 6, '0' ) || to_char( id.report_date, 'YYYY') || to_char( id.report_date, 'MM' ) report_key,
           SPECIES_FK
       FROM WP_HAWAII.H_integdealer id
     Where
             fishery like '%FRS%'
             and(num_sold > 0)
              and  lpad( id.fisher_lic_fk, 6, '0' ) || to_char( id.report_date, 'YYYY') || to_char( id.report_date, 'MM' ) in (select  report_key from frs_deep7_trip_headers )
      group by fishery, fisher_lic_fk,  lpad( id.fisher_lic_fk, 6, '0' ) || to_char( id.report_date, 'YYYY') || to_char( id.report_date, 'MM' ), species_fk
                 ) id
where
        id.report_key = frs.report_key  
    and id.species_fk = sp.species_pk   -- need for species name
group by season, frs.report_key, frs.fisher_lic_fk,  id.species_fk, species_name
 )
select
season,
species_fk dar_species,
species_name,
   sum( NUM_SOLD ) id_num_sold,
   sum( LBS_SOLD ) id_lbs_sold, 
   sum(SOLD_REVENUE) id_sold_revenue,
   sum( lbs_sold ) / nullif( sum( num_sold ), 0 ) avg_lbs_piece,
   sum( sold_revenue ) / nullif( sum( lbs_sold ), 0 ) avg_price_lb
from temp
group by season,  species_fk, species_name ) )
 ;
 
 /*
 -- paul's code to sub-sample data
 * Find License- Fished
* Dlr_No, CML_No, ReportDate, Spc
SELE Dlr_No, CML_No, ReportDate;
 FROM Temp2;
 WHER Spc IN (SELE Species FROM TempS WHER BETW(List_Num,1,7));
 GROU BY 1,2,3;
 */
