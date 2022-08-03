setwd('C://Users//jx//Desktop//R assignment//Coursera//data')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
baltimoreNEI <- NEI[NEI$fips=="24510",]

aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI,sum)

png(filename='plot2.png')

barplot(
  aggTotalsBaltimore$Emissions,
  names.arg=aggTotalsBaltimore$year,
  xlab="Year",
  ylab="PM2.5 Emissions in Tons",
  main="Total PM2.5 Emissions From all Baltimore City Sources"
  )
dev.off()