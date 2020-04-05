!set variable_substitution=true;

--truncate table
truncate table &table_name
;

--upload file into user stage (table stages do not support file_format option)
put file://&path_var @~/covid_data
;

--copy data into table
copy into &table_name
from @~/covid_data/&table_name.csv
file_format = (format_name = 'ff_ingestion_covid_data')
;

--remove file from stage
remove @~/covid_data/&table_name.csv
;