setwd('C://Users//jx//Desktop//R assignment//Coursera//data')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
baltimoreNEI <- NEI[NEI$fips=="24510",]

aggTotalsBaltimore <- aggregate(Emissions ~ year, baltimoreNEI,sum)

png(filename='plot3.png')

library(ggplot2)

ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission in Tons")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(ggp)
dev.off()