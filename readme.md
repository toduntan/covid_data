1. Install snowSQL: https://docs.snowflake.com/en/user-guide/snowsql-install-config.html#installing-snowsql
2. Edit snowsql config file w/ connection info
		- Windows Location: c:\\<user_directory>\\.snowsql
		- Connections required: 
				- connections.ingest_svc_acct
					- user INGEST_SVC_ACCT
				- connections.primary
					- user with SYSADMIN and SECURITYADMIN access
3. Create project directory in windows.
4. Adjust R script to write CSVs to data repository in new project directory (eg: <project_path>\data_files).
5. Either clone project using git or download files from GitLab: https://gitlab.com/bformus/covid_data
5. From the command prompt, run "sf_covid_data_one_time_setup.bat" including password argument for user INGEST_SVC_ACCT that is created during setup process.
		- sf_covid_data_one_time_setup.bat <password>
6. Schedule in windows task scheduler "sf_covid_data_ingestion.bat" with argument for project files "C:\<project_path>"
		- sf_covid_data_ingestion.bat "C:\<project_path>"
