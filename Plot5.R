library(plyr)
library(ggplot2)
if(!exists("NEI")){
  NEI <- readRDS("./Week 4/summarySCC_PM25.rds")
}
if(!exists("SCC")){
  SCC <- readRDS("./Week 4/Source_Classification_Code.rds")
}
# Assumptions: motor vehicles = On and check the levels for types of vehicles defined
mv.sourced <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))

mv.sourcec <- SCC[SCC$EI.Sector %in% mv.sourced, ]["SCC"]

#subset the emissions from motor vehicles from NEI for Baltimore.
emMV.ba <- NEI[NEI$SCC %in% mv.sourcec$SCC & NEI$fips == "24510",]

# Find the emissions due to motor vehicles in Baltimore for every year
balmv.pm25yr <- ddply(emMV.ba, .(year), function(x) sum(x$Emissions))
colnames(balmv.pm25yr)[2] <- "Emissions"

#Plot to png
png("plot5.png")
qplot(year, Emissions, data=balmv.pm25yr, geom="line") + ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions by Year")) + xlab("Year") + ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()
