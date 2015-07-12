#============================================================================================#
# @project  : EDA@Coursera                                                                   #
# @author   : jshiju                                                                         #
# @date     : 12/JUL/15                                                                      #
# @desc     : A plot showing the total PM2.5 emission trend from all sources for each of the #
#             years 1999, 2002, 2005, and 2008 based on National Emissions Inventory(NEI)    #
#             database.                                                                      #
#--------------------------------------------------------------------------------------------#


## set working directory to the folder where it conatains a subfolder
## 'data' under which we have the RDS files
## 1. Source_Classification_Code.rds
## 2. summarySCC_PM25.rds
##
## setwd("C:/Learn/R/Coursera/EDA/Project2")

# Remove all unwanted objects from session
rm(list=ls())

# Loads RDS
neiDataset <- readRDS("data/summarySCC_PM25.rds")
sccDataset <- readRDS("data/Source_Classification_Code.rds")

# Do some basic data analysis
head(neiDataset)
head(sccDataset)
dim(neiDataset) # 6497651   6
dim(sccDataset) # 11717    15

# Aggregates
aggrEmission <- aggregate(neiDataset[, 'Emissions'], by = list(neiDataset$year), FUN = sum)

# Round it to Kilotons for readability
aggrEmission$PM <- round(aggrEmission[, 2] / 1000, 2)


# Generate the plot which shows the trend and also the absolute measure.
png(filename = "plot1.png", width = 620, height = 480, units = "px")
par(mfrow=c(1,2), mar=c(5,4,4,2), oma=c(0,0,0,0))
with(aggrEmission, {
  barplot(PM, names.arg = Group.1, main = expression(paste('Total Emission of PM',''[2.5], ' in US 1999-2008')), 
          xlab = 'Year', ylab = "Emission in Kilotons")

  plot(Group.1, PM, type = "l", xlab = "Year", 
       main = expression(paste('Total Emission of PM',''[2.5], ' in US 1999-2008')), 
       ylab = "Emission in Kilotons")
})

dev.off()



