#Use libraries
library("ggplot2", lib.loc="~/R/win-library/3.5")
library("plyr", lib.loc="~/R/win-library/3.5")
library("readr", lib.loc="~/R/win-library/3.5")

#Import data
Population_per_department_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Population_per_department_2015.csv", sep = ";")
Budget_per_department_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Depenses_InvestissementmentAllDept2015.csv", sep=";")
Budget_per_department_2015 <- merge(Budget_per_department_2015, Population_per_department_2015, by = "DepName")

#Plot investment per department
ggplot(data=Budget_per_department_2015, aes(x = DepCode, y = Depensestotales_hab, color=DepCode)) + ylab("Total investment per inhabitant (???)") + xlab("Department code") + labs(fill = "Departments names") + geom_bar(stat='identity', position='identity', show.legend=FALSE)

#10 highest investements
highest_investments <- head(Budget_per_department_2015[order(Budget_per_department_2015$Depensestotales_hab, decreasing=TRUE), ], 10)
ggplot(data=highest_investments, aes(x=reorder(DepCode, -Depensestotales_hab), y=Depensestotales_hab, fill=DepName)) + ylab("Total investment per inhabitant (???)") + xlab("Department code") + labs(fill = "Departments names") + geom_col(position = 'dodge')

#10 lowest investments
lowest_investments <- tail(Budget_per_department_2015[order(Budget_per_department_2015$Depensestotales_hab, decreasing=TRUE), ], 10)
ggplot(data=lowest_investments, aes(x=reorder(DepCode, Depensestotales_hab), y=Depensestotales_hab, fill=DepName)) + ylab("Total investment per inhabitant (???)") + xlab("Department code") + labs(fill = "Departments names") + geom_col(position = 'dodge')
