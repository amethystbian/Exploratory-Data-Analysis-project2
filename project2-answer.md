# Questions
You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

Firstly, load the data.
```
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

## Question1
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
```
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
```
From the plot, the total emissions from PM2.5 have decreased in the United States from 1999 to 2008.
![plot1](https://user-images.githubusercontent.com/108068625/182578138-f78c3dc1-5dd0-4f0e-a3b8-3a844622cbe4.png)

## Question2
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
```
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
```
From the plot, the overall total emissions from PM2.5 decreased in the Baltimore City, Maryland did decrease from 1999 to 2008.
![plot2](https://user-images.githubusercontent.com/108068625/182579080-783e47e0-e4fc-4721-a51b-b0a9c287e628.png)

## Question3
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
```
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
```
From the plot, source type non-road, nonpoint, and on-road have a decrease in the emissions from 1999 to 2008 in Baltimore City. However, the point source type has increased from 1999 to 2008.

![plot3](https://user-images.githubusercontent.com/108068625/182579762-db07eddb-a2a9-41fb-adbd-8035143262b4.png)

## Question4
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
```
combustionRelated <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRelated <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalCombustion <- (combustionRelated & coalRelated)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]
png(filename='plot4.png')
library(ggplot2)
ggp <- ggplot(combustionNEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission in 10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))
print(ggp)
dev.off()
```
From the plot, the emissions from coal combustion-related sources decreased from about 6*10^6 to a value that below 4*10^6 from 1999 to 2008. 

![plot4](https://user-images.githubusercontent.com/108068625/182580483-32eb3cc4-6de4-408a-80e6-b91248a723ae.png)

## Question5
How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
```
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]
baltimoreVehiclesNEI <- vehiclesNEI[vehiclesNEI$fips=="24510",]
png(filename='plot5.png')
library(ggplot2)
ggp <- ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission in 10^5 Tons")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))
print(ggp)
dev.off()
```
From the plot, the emissions from motor vehicle sources have decreased from 1999-2008 in Baltimore City.

![plot5](https://user-images.githubusercontent.com/108068625/182580823-a64535a8-3b1f-4940-9e5e-045e9a3e5cfb.png)

## Question6
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
```
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]
vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips=="24510",]
vehiclesBaltimoreNEI$city <- "Baltimore City"
vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
vehiclesLANEI$city <- "Los Angeles County"
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)
png(filename='plot6.png')
library(ggplot2)
ggp <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission in Kilo-Tons")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))
print(ggp)
dev.off()
```
From the plot, Los Angeles County has the greater changes over time in motor vehicle emissions.
![plot6](https://user-images.githubusercontent.com/108068625/182581257-bd334a20-6732-4994-8feb-26b9610d1878.png)
