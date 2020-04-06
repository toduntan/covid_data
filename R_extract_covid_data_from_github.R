library(data.table)
library(dplyr)
library(readxl)
library(stringr)
library(lubridate)

args = commandArgs(trailingOnly=TRUE)

#declare JHU url directory
jhu_url_stub<-"https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data"

#declare directory for global confirmed case time series
covid19_confirmed_global_url <- "/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

#declare directory for global deaths time series
covid19_deaths_global_url <- "/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"

#declare directory for global recovered time series
covid19_recovered_global_url <- "/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"

#declare directory for US confirmed time series
covid19_confirmed_US_url <- "/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
  
#declare directory for US death time series
covid19_deaths_US_url <- "/csse_covid_19_time_series/time_series_covid19_deaths_US.csv"

#declare URLS for snapshot (map data)
url_dir<-paste0('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/')
date<-Sys.Date()-1
file_date<-paste0(str_pad(month(date),width = 2,pad='0'),'-',str_pad(day(date),width = 2,pad='0'),'-',year(date),'.csv')
confirmed_data_url_snapshot<-paste0(url_dir,file_date)

# Fetch the Github timeseries data and unpivot (melt) for time series 
time_series_covid19_confirmed_global <- suppressWarnings(melt(fread(paste0(jhu_url_stub,covid19_confirmed_global_url)), id.vars = c(1:4), variable.name = "Date", value.name = "Cases"))

# Fetch the Github timeseries data and unpivot (melt) for time series 
time_series_covid19_deaths_global <- suppressWarnings(melt(fread(paste0(jhu_url_stub,covid19_deaths_global_url)), id.vars = c(1:4), variable.name = "Date", value.name = "Cases"))

# Fetch the Github timeseries data and unpivot (melt) for time series 
time_series_covid19_recovered_global <- suppressWarnings(melt(fread(paste0(jhu_url_stub,covid19_recovered_global_url)), id.vars = c(1:4), variable.name = "Date", value.name = "Cases"))

# Fetch the Github timeseries data and unpivot (melt) for time series 
time_series_covid19_confirmed_US <- suppressWarnings(melt(fread(paste0(jhu_url_stub,covid19_confirmed_US_url)), id.vars = c(1:11), variable.name = "Date", value.name = "Cases"))

# Fetch the Github timeseries data and unpivot (melt) for time series 
time_series_covid19_deaths_US <- suppressWarnings(melt(fread(paste0(jhu_url_stub,covid19_deaths_US_url)), id.vars = c(1:12), variable.name = "Date", value.name = "Cases"))

#Stores dataframes as CSV files in appropriate directory
write.csv(time_series_covid19_confirmed_global, paste(args[1],"\\data_files\\time_series_covid19_confirmed_global.csv", sep=""),row.names = FALSE)
write.csv(time_series_covid19_deaths_global, paste(args[1],"\\data_files\\time_series_covid19_deaths_global.csv", sep=""),row.names = FALSE)
write.csv(time_series_covid19_recovered_global, paste(args[1],"\\data_files\\time_series_covid19_recovered_global.csv", sep=""),row.names = FALSE)
write.csv(time_series_covid19_confirmed_US, paste(args[1],"\\data_files\\time_series_covid19_confirmed_US.csv", sep=""),row.names = FALSE)
write.csv(time_series_covid19_deaths_US, paste(args[1],"\\data_files\\time_series_covid19_deaths_US.csv", sep=""),row.names = FALSE)