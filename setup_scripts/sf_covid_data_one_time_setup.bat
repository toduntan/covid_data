@ECHO OFF

REM check if argument was passed in and it is a valid directory
if [%1]==[] goto no_pw_argument

REM initializing variables
set "password=%1"
set log_directory=%~dp0\..\logs
set logfile=%log_directory%\%~n0.log

REM initializing log file
echo %date% %time% [INFO] Starting one-time setup... > %logfile%

REM run one-time setup.  Requires SYSADMIN and SECURITYADMIN roles.
echo %date% %time% [INFO] Executing sf_ddls_covid_data_one_time_run.sql...
echo %date% %time% [INFO] Executing sf_ddls_covid_data_one_time_run.sql... >> %logfile%
snowsql -c primary -f "%~dp0\sf_ddls_covid_data_one_time_run.sql" -D pwd="%password%" -o output_file="%logfile%" -o friendly=false -o output_format=plain -o timing_in_output_file=true
echo %date% %time% [INFO] sf_ddls_covid_data_one_time_run.sql executed.
echo %date% %time% [INFO] sf_ddls_covid_data_one_time_run.sql executed. >> %logfile%

REM beginning database role creation.  Requires SYSADMIN and SECURITYADMIN roles.
echo %date% %time% [INFO] Executing db_grants.sql for INGESTION db...
echo %date% %time% [INFO] Executing db_grants.sql for INGESTION db... >> %logfile%
snowsql -c primary -f "%~dp0\db_grants.sql" -D DATABASE="INGESTION" -D WAREHOUSE="INGESTION_WH" -o output_file="%logfile%" -o friendly=false -o output_format=plain -o timing_in_output_file=true
echo %date% %time% [INFO] db_grants.sql for INGESTION dbexecuted.
echo %date% %time% [INFO] db_grants.sql for INGESTION dbexecuted. >> %logfile%

REM beginning database TRANSFORM role creation.  Requires SYSADMIN and SECURITYADMIN roles.
echo %date% %time% [INFO] Executing db_grants.sql for TRANSFORM db...
echo %date% %time% [INFO] Executing db_grants.sql for TRANSFORM db... >> %logfile%
snowsql -c primary -f "%~dp0\db_grants.sql" -D DATABASE="TRANSFORM" -D WAREHOUSE="INGESTION_WH" -o output_file="%logfile%" -o friendly=false -o output_format=plain -o timing_in_output_file=true
echo %date% %time% [INFO] db_grants.sql for TRANSFORM db executed.
echo %date% %time% [INFO] db_grants.sql for TRANSFORM db executed. >> %logfile%

REM beginning database REPORTING role creation.  Requires SYSADMIN and SECURITYADMIN roles.
echo %date% %time% [INFO] Executing db_grants.sql for REPORTING db...
echo %date% %time% [INFO] Executing db_grants.sql for REPORTING db... >> %logfile%
snowsql -c primary -f "%~dp0\db_grants.sql" -D DATABASE="REPORTING" -D WAREHOUSE="INGESTION_WH" -o output_file="%logfile%" -o friendly=false -o output_format=plain -o timing_in_output_file=true
echo %date% %time% [INFO] db_grants.sql for REPORTING db executed.
echo %date% %time% [INFO] db_grants.sql for REPORTING db executed. >> %logfile%

REM assign roles to INGEST_SVC_ACCT.  Requires SECURITYADMIN.
echo %date% %time% [INFO] Granting privileges to INGEST_SVC_ACCT...
echo %date% %time% [INFO] Granting privileges to INGEST_SVC_ACCT... >> %logfile%
snowsql -c primary -r SECURITYADMIN -q "alter user INGEST_SVC_ACCT set default_warehouse=INGESTION_WH default_namespace=INGESTION default_role=INGESTION_WRITE; grant role INGESTION_WRITE, TRANSFORM_WRITE, REPORTING_WRITE to user INGEST_SVC_ACCT;" -o output_file="%logfile%" -o friendly=false -o output_format=plain -o timing_in_output_file=true
echo %date% %time% [INFO] Query executed.
echo %date% %time% [INFO] Query executed. >> %logfile%

REM testing access
echo %date% %time% [INFO] Executing query as INGEST_SVC_ACCT to verify access.
echo %date% %time% [INFO] Executing query as INGEST_SVC_ACCT to verify access. >> %logfile%
snowsql -c ingest_svc_acct -d INGESTION -s COVID_DATA -w INGESTION_WAREHOUSE -q "select * from time_series_covid19_confirmed_global" -o friendly=false -o output_file="%logfile%" -o output_format=plain -o timing_in_output_file=true
echo %date% %time% [INFO] Query executed.
echo %date% %time% [INFO] Query executed. >> %logfile%

goto end
	
:no_pw_argument
	echo %date% %time% [FAILURE] Password argument not supplied.
	exit /B 1

:end
	REM process complete.
	echo %date% %time% [SUCCESS] One-time setup complete.
	echo %date% %time% [SUCCESS] One-time setup complete. >> %logfile%
	pause