setwd('C://Users//jx//Desktop//R assignment//Coursera//data')

SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

aggTotals <- aggregate(Emissions ~ year,NEI, sum)

png(filename='plot1.png')

barplot(
  (aggTotals$Emissions)/10^6,
  names.arg=aggTotals$year,
  xlab="Year",
  ylab="PM2.5 Emissions in units 10^6 Tons",
  main="Total PM2.5 Emissions From All US Sources"
)
dev.off()