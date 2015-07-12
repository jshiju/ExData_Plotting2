#=======================================================================================#
# @project  : EDA@Coursera                                                              #
# @author   : jshiju                                                                    #
# @date     : 12/JUL/15                                                                 #
# @desc     : A plot showing the total PM2.5 emission trend in Baltimore, MD and Los    #
#             Angeles County, California from motor vehicle sources for years 1999,     #
#             2002, 2005, and 2008 based on National Emissions Inventory(NEI) database. #                                                                  #
#---------------------------------------------------------------------------------------#


## set working directory to the folder where it conatains a subfolder
## 'data' under which we have the RDS files
## 1. Source_Classification_Code.rds
## 2. summarySCC_PM25.rds
##
## setwd("C:/Learn/R/Coursera/EDA/Project2")

# Remove all unwanted objects from session
rm(list=ls())

# This plot requires ggplot2
require(ggplot2)

# Loads RDS
neiDataset <- readRDS("data/summarySCC_PM25.rds")
sccDataset <- readRDS("data/Source_Classification_Code.rds")

# Do some basic data analysis
head(neiDataset)
head(sccDataset)
dim(neiDataset) # 6497651   6
dim(sccDataset) # 11717    15

# Subset data for Baltimore and Motor Vehicle source 
BmoreData  <- subset(neiDataset, fips == '24510' & type == 'ON-ROAD')
BmoreData$year <- factor(BmoreData$year, levels = c('1999', '2002', '2005', '2008'))

# Subset data for Los Angeles and Motor Vehicle source 
LosAglData <- subset(neiDataset, fips == '06037' & type == 'ON-ROAD')
LosAglData$year <- factor(LosAglData$year, levels = c('1999', '2002', '2005', '2008'))

# Aggregates
bmAggr <- aggregate(BmoreData[, 'Emissions'], by = list(BmoreData$year), sum)
bmAggr$city <- paste(rep('MD', 4))
colnames(bmAggr) <- c('Year', 'Emissions', 'City')


laAggr <- aggregate(LosAglData[, 'Emissions'], by = list(LosAglData$year), sum)
laAggr$city <- paste(rep('CA', 4))
colnames(laAggr) <- c('Year', 'Emissions', 'City')


# Combine two datasets into a single one for plotting
plotData <- as.data.frame(rbind(bmAggr, laAggr))

# Generate the plot which shows the trend and also the absolute measure.
png(filename = "plot6.png", width = 620, height = 480, units = "px")

ggplot(data = plotData, aes(x = Year, y = Emissions)) + 
  geom_bar(aes(fill = Year), stat = "identity") + 
  guides(fill = F) + 
  ggtitle('Total Emissions of Motor Vehicle Sources - Los Angeles County, CA vs. Baltimore City, MD') + 
  ylab(expression('PM'[2.5])) + xlab('Year') + 
  theme(legend.position = 'none') + 
  facet_grid(. ~ City) + 
  geom_text(aes(label = round(Emissions, 0), size = 1, hjust = 0.5, vjust = -1))

dev.off()
