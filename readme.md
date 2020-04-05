## COVID-19 Data Ingestion Project

- Install snowSQL from [Official Snowflake snowSQL source](https://docs.snowflake.com/en/user-guide/snowsql-install-config.html#installing-snowsql)
- Edit snowsql config file w/ connection info
	- Windows Location: c:\\<user_directory>\\.snowsql
	- Connections required: 
		- connections.ingest_svc_acct  
			- user INGEST_SVC_ACCT  
		- connections.primary  
			- user with SYSADMIN and SECURITYADMIN access  
- Create project directory in windows.
- Adjust R script to write CSVs to data repository in new project directory (eg: <project_path>\data_files).
- Either clone project using git or download files from GitLab: https://gitlab.com/bformus/covid_data
- From the command prompt, run [sf_covid_data_one_time_setup.bat](./sf_covid_data_one_time_setup.bat) including password argument for user INGEST_SVC_ACCT that is created during setup process.  
	- Ex: sf_covid_data_one_time_setup.bat <password>
- Schedule primary bat file with windows task scheduler [sf_covid_data_ingestion.bat](./sf_covid_data_ingestion.bat)
