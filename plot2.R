## Get set up
library(tidyverse)
library(lubridate) 

url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
tmp <- tempfile()


## Load data
download.file(url, tmp)
df_0 <- read.table(unz(tmp, "household_power_consumption.txt"),
                   sep=';', header=TRUE, stringsAsFactors=FALSE)
unlink(tmp)


## Reshape data
df <- df_0 %>%
    mutate(date = dmy(Date)) %>%
    filter(date == ymd("2007-02-01") | date == ymd("2007-02-02")) %>%
    mutate(datetime = dmy_hms(paste(Date, Time)) %>% 
              with_tz(tzone="Europe/London"),
           global_active_power = as.numeric(Global_active_power),
           global_reactive_power = as.numeric(Global_reactive_power),
           voltage = as.numeric(Voltage),
           global_intensity = as.numeric(Global_intensity),
           sub_metering_1 = as.numeric(Sub_metering_1),
           sub_metering_2 = as.numeric(Sub_metering_2),
           sub_metering_3 = as.numeric(Sub_metering_3)
           ) %>%
    select(datetime, global_active_power, global_reactive_power, voltage,
           global_intensity, sub_metering_1, sub_metering_2, sub_metering_3
           )
table(weekdays(df$datetime))


## Construct the plot; save to a PNG file with dimensions of 480 x 480 pixels.
png("plot2.png", width=480, height=480)
with(df, plot(datetime, global_active_power, 
              pch=NA_integer_,
              xlab="",
              ylab="Global Active Power (kilowatts)"
              )
     )
with(df, lines(datetime, global_active_power))

dev.off()
