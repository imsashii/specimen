##### COMPLETE QUERY ######

--create the view
DROP MATERIALIZED VIEW IF EXISTS update_view_sql_data CASCADE;
CREATE MATERIALIZED VIEW update_view_sql_data as

with new_set as(
select apartment_id,update_date,if_onboarded,update_date as temp_date,
lag(if_onboarded) over(partition by apartment_id order by apartment_id,update_date) prev_value
from sampledata_sql order by apartment_id,update_date) --'sampledata_sql' is a .csv file
select apartment_id,update_date,
case
	when if_onboarded = 't' and prev_value = 'f' then update_date 
end as onboarded_date from new_set order by apartment_id,update_date;

--after updating the db ie sampledata_sql, run this
select * from update_view_sql_data;
