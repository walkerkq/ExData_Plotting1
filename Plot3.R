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
plot(power$DateTime,power$Sub_metering_1,type="l",ylim=c(0,40),xlab="",ylab="Energy Sub Metering")
lines(power$DateTime,power$Sub_metering_2,col="red",type="l")
lines(power$DateTime,power$Sub_metering_3,col="blue",type="l")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=c(1,1,1),lwd=c(2.5,2.5,2.5),cex=0.6)

#Export to PNG
dev.copy(png,file="Plot3.png",width=480,height=480)
dev.off()