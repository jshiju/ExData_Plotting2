#=======================================================================================#
# @project  : EDA@Coursera                                                              #
# @author   : jshiju                                                                    #
# @date     : 12/JUL/15                                                                 #
# @desc     : A plot showing the total PM2.5 emission trend in Baltimore, MD from motor # 
#             vehicle sources for years 1999, 2002, 2005, and 2008 based on National    #
#             Emissions Inventory(NEI) database.                                        #                                                                  #
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
BmoreData <- subset(neiDataset, fips == '24510' & type == 'ON-ROAD')

# Aggregates
aggrEmission <- aggregate(BmoreData[, 'Emissions'], by = list(BmoreData$year), sum)
colnames(aggrEmission) <- c('Year', 'Emissions')
aggrEmission$Year <- factor(aggrEmission$Year, levels = c('1999', '2002', '2005', '2008'))




# Generate the plot which shows the trend and also the absolute measure.
png(filename = "plot5.png", width = 480, height = 480, units = "px")

ggplot(data = aggrEmission, aes(x = Year, y = Emissions)) + 
  geom_bar(aes(fill = Year), stat = "identity") + 
  ggtitle('Total Emissions of Motor Vehicle Sources in Baltimore City, MD') +
  xlab('Year') +
  ylab(expression('PM'[2.5]*' in Tons')) + 
  geom_text(aes(label = round(Emissions, 0), size = 1, hjust = .5, vjust = 2)) +
  guides(fill = F) + 
  theme(legend.position = 'none')

dev.off()
