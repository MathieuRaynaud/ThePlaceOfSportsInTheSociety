# The place of sports in the society

# Analyse of an open data set from the french government, inventorying the sportive infrastructures in France since 2012
# Link of the data set: https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.data.gouv.fr%2Fs%2Fresources%2Frecensement-des-equipements-sportifs-espaces-et-sites-de-pratiques%2F20170817-165944%2FRES_T2_20122016.zip%3Ffbclid%3DIwAR161Lr8fZ6z_ri0LPXBgB3s6fJ8ukpIgwpnddm9f9CfWdAvpgp2CrkiNcQ&h=AT21de_y4OuGqsqaCbUAQl9RJe7nsBD9dvf4-ftbFbnD8QjhKPLwoVBNkZNX1H7cBxmqKdbx0BqNSdnnARIu0JEuY0ru9n1DOa82Xwlkv0L88HHt-6WPP-6FHK4DtrkYxtU

# OpenData_15Avril2012 <- read_delim("INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/RES_T2_20122016/RES20122016/Export_OpenData_Avril2012/OpenData_15Avril2012.txt", 
#                                    +     ";", escape_double = FALSE, trim_ws = TRUE)
X20160713_RES_FichesInstallations <- read_delim("INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/RES_T2_20122016/RES20122016/Fichiers_T22016/20160713_RES_FichesInstallations/20160713_RES_FichesInstallations.csv", 
                                                +     ";", escape_double = FALSE, trim_ws = TRUE)


# Make the data set cleaner by deleting the wrong data
# Cleaned_dataset <- OpenData_15Avril2012[!is.na(as.numeric(as.character(OpenData_15Avril2012$DepCode))),]
# Sport_equipments <- Cleaned_dataset[!is.na(Cleaned_dataset$EquNbEquIdentique), 

# The number of sportive infrastructures per department
# infra_per_department <- ddply(Sport_equipments, "DepCode", summarize, Somme=sum(EquNbEquIdentique))
# ggplot(data=infra_per_department, aes(x=DepCode, y=Somme)) + geom_col(position='dodge')

# The number of sportive infrastructures per department
infra_per_department <- ddply(X20160713_RES_FichesInstallations, "DepCode", summarize, Somme=sum(Nb_Equipements))
ggplot(data=infra_per_department, aes(x=DepCode, y=Somme)) + geom_col(position='dodge')
