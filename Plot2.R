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

#Make the plot
plot(power$DateTime,power$Global_active_power,type="l",ylab="Global Active Power (kilowatts)",xlab="")

#Export to PNG
dev.copy(png,file="Plot2.png",width=480,height=480)
dev.off()