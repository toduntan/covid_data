!set variable_substitution=true
!set header=false
!set output_format=plain
!set timing=false
!set wrap=false

use role SECURITYADMIN
;

--create service account for ingestion
create or replace user INGEST_SVC_ACCT 
	password = '&{pwd}' 
	MUST_CHANGE_PASSWORD = FALSE
;

use role SYSADMIN
;

create or replace warehouse INGESTION_WH with 
	warehouse_size = 'small' 
	warehouse_type = 'standard' 
	auto_suspend = 300 
	initially_suspended = true
	auto_resume = true 
	min_cluster_count = 1 
	max_cluster_count = 1 
	scaling_policy = 'standard'
;

create or replace database INGESTION
;

use database INGESTION
;

create or replace schema COVID_DATA
;

use schema COVID_DATA
;

create or replace table time_series_covid19_confirmed_global
(
	Province_State		varchar,
	Country_Region		varchar,
	Lat								varchar,
	Long							varchar,
	Date							varchar,
	Cases							varchar
)
;

create or replace table time_series_covid19_deaths_global
(
	Province_State		varchar,
	Country_Region		varchar,
	Lat								varchar,
	Long							varchar,
	Date							varchar,
	Cases							varchar
)
;

create or replace table time_series_covid19_recovered_global
(
	Province_State		varchar,
	Country_Region		varchar,
	Lat								varchar,
	Long							varchar,
	Date							varchar,
	Cases							varchar
)
;

create or replace table time_series_covid19_confirmed_US
(
	UID									varchar,
	iso2								varchar,
	iso3								varchar,
	code3								varchar,
	FIPS								varchar,
	Admin2							varchar,
	Province_State			varchar,
	Country_Region			varchar,
	Lat									varchar,
	Long_								varchar,
	Combined_Key				varchar,
	Date								varchar,
	Cases								varchar
)
;

create or replace table time_series_covid19_deaths_US
(
	UID									varchar,
	iso2								varchar,
	iso3								varchar,
	code3								varchar,
	FIPS								varchar,
	Admin2							varchar,
	Province_State			varchar,
	Country_Region			varchar,
	Lat									varchar,
	Long_								varchar,
	Combined_Key				varchar,
	Population					varchar,
	Date								varchar,
	Cases								varchar
)
;

create or replace file format ff_ingestion_covid_data
    type = 'csv' 
    compression = 'auto' 
    field_delimiter = ',' 
    record_delimiter = '\n' 
    skip_header = 1 
    field_optionally_enclosed_by = '\042' 
    trim_space = false 
    error_on_column_count_mismatch = true 
    escape = 'none' 
    escape_unenclosed_field = '\134' 
    date_format = 'auto' 
    timestamp_format = 'auto' 
    null_if = ('\\n')
;