# The place of sports in the society

# Analyse of an open data set from the french government, inventorying the sportive infrastructures in France since 2012
# Link of the data set: https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.data.gouv.fr%2Fs%2Fresources%2Frecensement-des-equipements-sportifs-espaces-et-sites-de-pratiques%2F20170817-165944%2FRES_T2_20122016.zip%3Ffbclid%3DIwAR161Lr8fZ6z_ri0LPXBgB3s6fJ8ukpIgwpnddm9f9CfWdAvpgp2CrkiNcQ&h=AT21de_y4OuGqsqaCbUAQl9RJe7nsBD9dvf4-ftbFbnD8QjhKPLwoVBNkZNX1H7cBxmqKdbx0BqNSdnnARIu0JEuY0ru9n1DOa82Xwlkv0L88HHt-6WPP-6FHK4DtrkYxtU

# OpenData_15Avril2012 <- read_delim("INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/RES_T2_20122016/RES20122016/Export_OpenData_Avril2012/OpenData_15Avril2012.txt", 
#                                    +     ";", escape_double = FALSE, trim_ws = TRUE)
X20150801_RES_FichesInstallations <- read_delim("INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/RES_T2_20122016/RES20122016/Fichiers_T22015/20150801_RES_FichesInstallations/20150801_RES_FichesInstallations.csv", 
                                                +     ";", escape_double = FALSE, trim_ws = TRUE)
Population_per_department_2015 <- read_delim("INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Population_per_department_2015.csv", 
                                             +     ";", escape_double = FALSE, trim_ws = TRUE)

# We choose to work with the metropolitan France
Sportive_equipments_2015 <- X20150801_RES_FichesInstallations[which(X20150801_RES_FichesInstallations$DepCode < 96), ]
Population_per_department_2015 <- Population_per_department_2015[which(Population_per_department_2015$DepCode < 96), ]

# Make the data set cleaner by deleting the wrong data
# Cleaned_dataset <- OpenData_15Avril2012[!is.na(as.numeric(as.character(OpenData_15Avril2012$DepCode))),]
# Sport_equipments <- Cleaned_dataset[!is.na(Cleaned_dataset$EquNbEquIdentique), 

# The number of sportive infrastructures per department
# infra_per_department <- ddply(Sport_equipments, "DepCode", summarize, Somme=sum(EquNbEquIdentique))
# ggplot(data=infra_per_department, aes(x=DepCode, y=Somme)) + geom_col(position='dodge')

# The number of sportive infrastructures per department
infra_per_department <- ddply(Sportive_equipments_2015, "DepCode", summarize, Somme=sum(Nb_Equipements))
ggplot(data=infra_per_department, aes(x=DepCode, y=Somme)) + geom_col(position='dodge')

# The population per department
ggplot(data=Population_per_department_2015, aes(x=DepCode, y=Population)) + geom_col(position='dodge')

# The average number of equipments per inhabitants for each department
average_equipment_population <- merge(infra_per_department, Population_per_department_2015, by = "DepCode")
average_equipment_population$Average = average_equipment_population$Population/average_equipment_population$Somme
ggplot(data=average_equipment_population, aes(x=DepCode, y=Average, color=DepCode)) + geom_col(position='dodge')

# Get the 10 best and the 10 worst departments
head(average_equipment_population[order(average_equipment_population$Average, decreasing=TRUE), ], 10)
tail(average_equipment_population[order(average_equipment_population$Average, decreasing=TRUE), ], 10)
