#Use libraries
library("ggplot2", lib.loc="~/R/win-library/3.5")
library("plyr", lib.loc="~/R/win-library/3.5")
library("readr", lib.loc="~/R/win-library/3.5")

#Import data
Population_variations_2010_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Population_variations_2010_2015.csv", sep=";")

#Plot data
ggplot(data=Population_variations_2010_2015, aes(x=DepCode, y=Variation, fill=DepCode)) + geom_bar(stat='identity', position='identity',show.legend = FALSE)

#10 most attractive departments
most_attractives <- head(Population_variations_2010_2015[order(Population_variations_2010_2015$Variation, decreasing=TRUE), ], 10)
ggplot(data=most_attractives, aes(x=reorder(DepCode, -Variation), y=Variation, fill=DepName)) + geom_col(position = 'dodge')

#10 less attractive departments
less_attractives <- tail(Population_variations_2010_2015[order(Population_variations_2010_2015$Variation, decreasing=TRUE), ], 10)
ggplot(data=less_attractives, aes(x=reorder(DepCode, Variation), y=Variation, fill=DepName)) + geom_col(position = 'dodge')