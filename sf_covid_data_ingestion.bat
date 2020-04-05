@ECHO OFF

REM check if argument was passed in and it is a valid directory
REM if [%1]==[] goto no_arguments
REM if not exist %1 goto not_a_directory

REM initializing variables
REM set working_directory=%1
set working_directory=%~dp0
set data_directory=%working_directory%\data_files
set log_directory=%working_directory%\logs
set log_archive_directory=%log_directory%\archive
set logfile=%log_directory%\%~n0.log

REM silently delete archived logs and archive last run's log files - 2 total runs of logs are kept, current & previous
del /s %log_archive_directory%\*.log >nul 2>&1

REM move previous run's log files into archive directory
move %log_directory%\*.log %log_archive_directory%

REM initializing log file
echo %date% %time% [INFO] Starting load... > %logfile%

REM using start command to run these in parallel

REM begin US covid data ingestion
echo %date% %time% [INFO] Starting file: time_series_covid19_confirmed_US >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%working_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_confirmed_US.csv" -D table_name="time_series_covid19_confirmed_US" -o output_file="%log_directory%\time_series_covid19_confirmed_US.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

echo %date% %time% [INFO] Starting file: time_series_covid19_deaths_US >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%working_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_deaths_US.csv" -D table_name="time_series_covid19_deaths_US" -o output_file="%log_directory%\time_series_covid19_deaths_US.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

REM begin GLOBAL covid data ingestion
echo %date% %time% [INFO] Starting file: time_series_covid19_confirmed_global >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%working_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_confirmed_global.csv" -D table_name="time_series_covid19_confirmed_global" -o output_file="%log_directory%\time_series_covid19_confirmed_global.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

echo %date% %time% [INFO] Starting file: time_series_covid19_deaths_global >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%working_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_deaths_global.csv" -D table_name="time_series_covid19_deaths_global" -o output_file="%log_directory%\time_series_covid19_deaths_global.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

echo %date% %time% [INFO] Starting file: time_series_covid19_recovered_global >> %logfile%
start "+++covid_data_ingestion+++" snowsql -c primary -d INGESTION -s COVID_DATA -w INGESTION_WH -f "%working_directory%\sf_ingestion_covid_data.sql" -D path_var="%data_directory%\time_series_covid19_recovered_global.csv" -D table_name="time_series_covid19_recovered_global" -o output_file="%log_directory%\time_series_covid19_recovered_global.log" -o quiet=true -o output_format=csv -o timing_in_output_file=true

REM all files started.
echo %date% %time% [INFO] All snowSQL statements started. >> %logfile%

REM monitor started tasks
:loop
  timeout /t 5 >nul
  tasklist /fi "windowtitle eq +++covid_data_ingestion+++*" |find "cmd.exe" >nul && goto :loop

goto end

:no_arguments
	echo %date% %time% [FAILURE] Directory argument not supplied.
	exit /B 1

:not_a_directory
	echo %date% %time% [FAILURE] Directory argument does not exist or permission denied.
	exit /B 1

:end
	REM process complete.
	echo %date% %time% [SUCCESS] Process complete. See individual logs for details or issues. >> %logfile%
	exit 0