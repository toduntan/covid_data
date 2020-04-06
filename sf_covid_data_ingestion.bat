@ECHO OFF

REM initializing variables
set working_directory=%~dp0
set data_directory=%working_directory%\data_files
set data_archive_directory=%data_directory%\archive
set log_directory=%working_directory%\logs
set log_archive_directory=%log_directory%\archive
set sql_ingestion_directory=%working_directory%\sql_files\01_ingestion
set sql_transform_directory=%working_directory%\sql_files\02_transform
set sql_reporting_directory=%working_directory%\sql_files\03_reporting
set logfile=%log_directory%\%~n0.log
set "lock=%temp%\wait%random%.lock"

REM silently delete archived logs.  Two total runs of logs are kept, current & previous
del /s %log_archive_directory%\*.log >nul 2>&1

REM archive previous run's log files
move %log_directory%\*.log %log_archive_directory%

REM initializing log file
echo %date% %time% [INFO] Starting ingestion... > %logfile%

REM silently delete archived CSVs.  Two total runs of CSVs are kept, current & previous.
echo %date% %time% [INFO] Deleting archived CSVs... >> %logfile%
del /s %data_archive_directory%\*.csv >nul 2>&1

REM archive previous run's CSV files
echo %date% %time% [INFO] Archiving previous run's CSVs... >> %logfile%
move %data_directory%\*.csv %data_archive_directory%

REM download and unpivot source files
echo %date% %time% [INFO] Downloading and unpivoting files from source... >> %logfile%
Rscript %working_directory%\R_extract_covid_data_from_github.R %working_directory%
echo %date% %time% [INFO] Source files extracted. >> %logfile%

REM using start command to run these in parallel

REM begin US covid data ingestion
echo %date% %time% [INFO] Starting file: time_series_covid19_confirmed_US >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%sql_ingestion_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_confirmed_US.csv" -D table_name="time_series_covid19_confirmed_US" -o output_file="%log_directory%\time_series_covid19_confirmed_US.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

echo %date% %time% [INFO] Starting file: time_series_covid19_deaths_US >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%sql_ingestion_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_deaths_US.csv" -D table_name="time_series_covid19_deaths_US" -o output_file="%log_directory%\time_series_covid19_deaths_US.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

REM begin GLOBAL covid data ingestion
echo %date% %time% [INFO] Starting file: time_series_covid19_confirmed_global >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%sql_ingestion_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_confirmed_global.csv" -D table_name="time_series_covid19_confirmed_global" -o output_file="%log_directory%\time_series_covid19_confirmed_global.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

echo %date% %time% [INFO] Starting file: time_series_covid19_deaths_global >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%sql_ingestion_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_deaths_global.csv" -D table_name="time_series_covid19_deaths_global" -o output_file="%log_directory%\time_series_covid19_deaths_global.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

echo %date% %time% [INFO] Starting file: time_series_covid19_recovered_global >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%sql_ingestion_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_recovered_global.csv" -D table_name="time_series_covid19_recovered_global" -o output_file="%log_directory%\time_series_covid19_recovered_global.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

REM all files started.
echo %date% %time% [INFO] All snowSQL statements started. >> %logfile%

REM monitor started tasks
:loop
  timeout /t 5 >nul
  tasklist /fi "windowtitle eq +++covid_data_ingestion+++*" |find "cmd.exe" >nul && goto :loop

REM process complete.
	echo %date% %time% [SUCCESS] Ingestion process complete. See individual logs for details or issues. >> %logfile%
	exit 0