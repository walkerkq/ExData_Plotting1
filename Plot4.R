#install packages
install.packages("sqldf")
library("sqldf")
#load in the file
file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file.url,"./household_power_consumption.zip",method="curl")
unzip("household_power_consumption.zip")
#read only 1/2/07-2/2/07
power <- read.csv.sql("household_power_consumption.txt",
                      sql="select * from file where (Date = '1/2/2007' OR Date = '2/2/2007')",
                      header=TRUE,
                      sep=";")
#fix date and time
power$DateTime <- paste(power$Date,power$Time,sep=" ")
power$DateTime <- strptime(power$DateTime,format="%d/%m/%Y %H:%M:%S")
power$Date = NULL
power$Time = NULL

#set grid
par(mfrow=c(2,2))
#Make top left plot
plot(power$DateTime,power$Global_active_power,type="l",ylab="Global Active Power (kilowatts)",xlab="")
#Make top right plot
plot(power$DateTime,power$Voltage,type="l",xlab="datetime",ylab="Voltage")
#Make bottom left plot
plot(power$DateTime,power$Sub_metering_1,type="l",ylim=c(0,40),xlab="",ylab="Energy Sub Metering")
lines(power$DateTime,power$Sub_metering_2,col="red",type="l")
lines(power$DateTime,power$Sub_metering_3,col="blue",type="l")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lwd=c(1,1,1),cex=0.4,bty="n")
#Make the bottom right plot
plot(power$DateTime,power$Global_reactive_power,type="l",xlab="datetime",ylab="Global_reactive_power")

#export to PNG
dev.copy(png,file="Plot4.png",width=480,height=480)
dev.off()