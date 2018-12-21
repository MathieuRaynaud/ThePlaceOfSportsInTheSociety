#Use libraries
library("ggplot2", lib.loc="~/R/win-library/3.5")
library("plyr", lib.loc="~/R/win-library/3.5")
library("readr", lib.loc="~/R/win-library/3.5")

#Import data
Population_per_department_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Population_per_department_2015.csv", sep = ";")
Budget_per_department_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Depenses_InvestissementmentAllDept2015.csv", sep=";")
Budget_per_department_2015 <- merge(Budget_per_department_2015, Population_per_department_2015, by = "DepName")

#Plot investment per department
ggplot(data=Budget_per_department_2015, aes(x = DepCode, y = Depensestotales, color=DepCode)) + ylab("Total investment (???)") + xlab("Department code") + labs(fill = "Departments names") + geom_bar(stat='identity', position='identity', show.legend=FALSE)

#10 highest investements
highest_investments <- head(Budget_per_department_2015[order(Budget_per_department_2015$Depensestotales, decreasing=TRUE), ], 10)
ggplot(data=highest_investments, aes(x=reorder(DepCode, -Depensestotales), y=Depensestotales, fill=DepName)) + ylab("Total investment (???)") + xlab("Department code") + labs(fill = "Departments names") + geom_col(position = 'dodge')

#10 lower investments
lower_investments <- tail(Budget_per_department_2015[order(Budget_per_department_2015$Investment_budget, decreasing=TRUE), ], 10)
ggplot(data=lower_investments, aes(x=reorder(DepCode, Investment_budget), y=Investment_budget, fill=DepName)) + geom_col(position = 'dodge')

## BE CAREFUL !!! WE DO NOT HAVE DATA FOR THESE DEPARTMENTS
View(Unknown_departments)

#Remove department 54 which have a huge difference with the others
Budget_per_department_2015 <- Budget_per_department_2015[-c(which(Budget_per_department_2015$DepCode == 54)), ]
ggplot(data=Budget_per_department_2015, aes(x = DepCode, y = Investment_budget, fill=DepCode)) + geom_bar(stat='identity', position='identity', show.legend=FALSE)
