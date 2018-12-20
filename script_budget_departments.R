#Use libraries
library("ggplot2", lib.loc="~/R/win-library/3.5")
library("plyr", lib.loc="~/R/win-library/3.5")
library("readr", lib.loc="~/R/win-library/3.5")

#Import data
Budget_per_department_2014 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Budget_per_department_2014.csv", sep=";")

#Replace N.A values by 0
Budget_per_department_2014[is.na(Budget_per_department_2014)] <- 0

#Plot relevant data (only investment buddget)
Budget_per_department_2014$Investment_budget <- Budget_per_department_2014$Service_investment + Budget_per_department_2014$Collectivity_investment
ggplot(data=Budget_per_department_2014, aes(x = DepCode, y = Investment_budget, fill=DepCode)) + geom_bar(stat='identity', position='identity', show.legend=FALSE)

#Remove rows for which data is missing (investment = 0)
Unknown_departments <- Budget_per_department_2014[c(which(Budget_per_department_2014$Investment_budget == 0)), ]
Budget_per_department_2014 <- Budget_per_department_2014[-c(which(Budget_per_department_2014$Investment_budget == 0)), ]

#10 highest investements
highest_investments <- head(Budget_per_department_2014[order(Budget_per_department_2014$Investment_budget, decreasing=TRUE), ], 10)
ggplot(data=highest_investments, aes(x=reorder(DepCode, -Investment_budget), y=Investment_budget, fill=DepName)) + geom_col(position = 'dodge')

#10 lower investments
lower_investments <- tail(Budget_per_department_2014[order(Budget_per_department_2014$Investment_budget, decreasing=TRUE), ], 10)
ggplot(data=lower_investments, aes(x=reorder(DepCode, Investment_budget), y=Investment_budget, fill=DepName)) + geom_col(position = 'dodge')

## BE CAREFUL !!! WE DO NOT HAVE DATA FOR THESE DEPARTMENTS
View(Unknown_departments)
