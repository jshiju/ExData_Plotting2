#============================================================================================#
# @project  : EDA@Coursera                                                                   #
# @author   : jshiju                                                                         #
# @date     : 12/JUL/15                                                                      #
# @desc     : A plot showing how have emissions from coal combustion-related sources changed #
#             from 1999-2008 based on National Emissions Inventory(NEI) database.            #
#--------------------------------------------------------------------------------------------#


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


# Coal-related sources
sccDataset.coal = sccDataset[grepl("coal", sccDataset$Short.Name, ignore.case = TRUE), ]

# Merges two data sets
mergeData <- merge(x = neiDataset, y = sccDataset.coal, by = 'SCC')
mergeData.sum <- aggregate(mergeData[, 'Emissions'], by = list(mergeData$year), sum)
colnames(mergeData.sum) <- c('Year', 'Emissions')


# Generate the plot which shows the trend and also the absolute measure.
png(filename = "plot4.png", width = 480, height = 480, units = "px")
ggplot(data = mergeData.sum, aes(x = Year, y = Emissions / 1000)) + 
  geom_line(aes(group = 1, col = Emissions)) + 
  geom_point(aes(size = 2, col = Emissions)) + 
  ggtitle(expression(paste('Total Emissions of PM',''[2.5], ' from Coal combution sources'))) + 
  ylab(expression(paste('PM', ''[2.5], ' in kilotons'))) + 
  geom_text(aes(label = round(Emissions / 1000, digits = 2), size = 2, hjust = 1.5, vjust = 1.5)) + 
  theme(legend.position = 'none') + scale_colour_gradient(low = 'black', high = 'red')

dev.off()


