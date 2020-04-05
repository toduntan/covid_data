1. Install snowSQL: https://docs.snowflake.com/en/user-guide/snowsql-install-config.html#installing-snowsql
2. Edit snowsql config file w/ connection info
		- Windows Location: c:\<user_directory>\.snowsql
3. Create project directory.
4. Adjust R script to write CSVs to data repository in new project directory (eg: <project_path>\data_files).
5. Place files in project directory.
		- sf_ingestion_covid_data.sql
		- sf_ddls_covid_data_one_time_run.sql
		- db_grants.sql
5. Run "sf_ddls_covid_data_one_time_run.sql" via snowSQL
		- Requires access to SYSADMIN and SECURITYADMIN roles.
		- 
6. Run "db_grants.sql" via snowSQL command
		- Requires access to SYSADMIN and SECURITYADMIN roles.
		- 
