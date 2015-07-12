#============================================================================================#
# @project  : EDA@Coursera                                                                   #
# @author   : jshiju                                                                         #
# @date     : 12/JUL/15                                                                      #
# @desc     : A plot showing the total PM2.5 emission trend in Baltimore, MD for the main    # 
#             four types of sources (point, nonpoint, onroad, nonroad) for years 1999, 2002, # 
#             2005, and 2008 based on National Emissions Inventory(NEI) database.            #
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

# Subset data for Baltimore
BmoreData <- subset(neiDataset, fips == '24510')


# Generate the plot which shows the trend and also the absolute measure.
png(filename = "plot3.png", width = 480, height = 480, units = "px")


ggplot(BmoreData, aes(year, Emissions, color = type)) +
  geom_line(stat = "summary", fun.y = "sum") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle("Total Emissions in Baltimore from 1999 to 2008 by Type")


# Another way of representing the same using BOXPLOT
#
# BmoreData$year <- factor(BmoreData$year, levels = c('1999', '2002', '2005', '2008'))
# ggplot(data = BmoreData, aes(x = year, y = log(Emissions))) + 
#   facet_grid(. ~ type) + guides(fill = F) + 
#   geom_boxplot(aes(fill = type)) + 
#   stat_boxplot(geom = 'errorbar') + 
#   ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + 
#   xlab('Year') + 
#  ggtitle('Emissions per Type in Baltimore City, MD') + 
#  geom_jitter(alpha = 0.10)

dev.off()

