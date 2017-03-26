## load dplyr for data manipultion
library(dplyr)

## download source data file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power.zip")
## unzip file to working directory
unzip("household_power.zip",junkpaths=TRUE)
##load file with all cols set to character
powerDat <- read.csv("household_power_consumption.txt", sep=";", colClasses=c(rep("character",9)))
## filter to the date range we care about
powerDat<-powerDat[powerDat$Date %in% c("2/2/2007","1/2/2007"),] 
## combine date / time columns
powerDat<-mutate(powerDat, Date=paste(Date, Time, sep=" "))
## convert chars to numerics
powerDat<-mutate(powerDat, Global_active_power=as.numeric(Global_active_power), Global_reactive_power=as.numeric(Global_reactive_power))
powerDat<-mutate(powerDat, Voltage=as.numeric(Voltage), Global_intensity=as.numeric(Global_intensity))
powerDat<-mutate(powerDat, Sub_metering_1=as.numeric(Sub_metering_1), Sub_metering_2=as.numeric(Sub_metering_2),Sub_metering_3=as.numeric(Sub_metering_3))
## create new column containing the date and time in POSIXlt format 
## have to do last because mutate doesn't like POSIXct dates
powerDat$DateTime<-strptime(powerDat$Date, format="%d/%m/%Y %H:%M:%S")
## histogram of global active power with labels
png("plot1.png")
hist(powerDat$Global_active_power, col="red", xlab= "Global Active Power (kW)", main = "Global Active Power")
dev.off()
## line chart of global active power
png("plot2.png")
plot(powerDat$DateTime,powerDat$Global_active_power, type='l', ylab="Global Active Power (kW)", main="Global Active Power over Time", xlab="Time")
dev.off()
## line chart of sub metering
png("plot3.png")
plot(powerDat$DateTime,powerDat$Sub_metering_1, type='l', ylab="Energy Sub Metering (Watt-hr)", main="Sub Metering Energy", xlab="Time")
lines(powerDat$DateTime, powerDat$Sub_metering_2, col="red")
lines(powerDat$DateTime, powerDat$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"), col=c("black","red","blue"), lwd=1)

## 4 plot chart
png("plot4.png")
## set up pallette by row
par(mfrow=c(2,2))
## first plot (same as plot 1)
plot(powerDat$DateTime,powerDat$Global_active_power, type='l', ylab="Global Active Power (kW)", main="Global Active Power over Time", xlab="Time")
## second plot (new!)
plot(powerDat$DateTime,powerDat$Voltage, type='l', ylab="Voltage", main="Voltage over Time", xlab="Time")
## third plot with multiple lines and legend (same as plot3)
plot(powerDat$DateTime,powerDat$Sub_metering_1, type='l', ylab="Energy Sub Metering (Watt-hr)", main="Sub Metering Energy", xlab="Time")
lines(powerDat$DateTime, powerDat$Sub_metering_2, col="red")
lines(powerDat$DateTime, powerDat$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"), col=c("black","red","blue"), lwd=1)
## fourth plot (new!)
plot(powerDat$DateTime,powerDat$Global_reactive_power, type='l', ylab="Global Reactive Power (kW)", main="Global Reactive Power", xlab="Time")
dev.off()



