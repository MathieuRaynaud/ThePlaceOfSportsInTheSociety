# Try to collerate with the life expectancy
#https://www.insee.fr/fr/statistiques/2012749#graphique-TCRD_050_tab1_departements

#Import files
#Version Alex
Sportive_equipments_2015 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/20150801_RES_FichesInstallations.csv", sep=";")
Life_expectancy_department_2016 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/Life_expectancy_2016.csv", sep = ";",dec=",")
Population_per_department_2015 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/Population_per_department_2015.csv", sep = ";")


#Version Mathieu
#Sportive_equipments_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/20150801_RES_FichesInstallations.csv", sep=";")
#Population_per_department_2015 = read.csv("/Users/Mathieu/Documents/INSA/5ème année/Traitement et Analyse des Données pour le Big Data/Projet/ThePlaceOfSportsInTheSociety/Population_per_department_2015.csv", sep = ";")

# We choose to work with the metropolitan France
france_metrop <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", (10:95), "2A", "2B")
Sportive_equipments_2015 <- Sportive_equipments_2015[which(Sportive_equipments_2015$DepCode%in%france_metrop), ]
Life_expectancy_department_2016 <- Life_expectancy_department_2016[which(Life_expectancy_department_2016$DepCode%in%france_metrop), ]
Population_per_department_2015 <- Population_per_department_2015[which(Population_per_department_2015$DepCode%in%france_metrop), ]


# The number of sportive infrastructures per department
infra_per_department <- ddply(Sportive_equipments_2015, "DepCode", summarize, NbEquip=sum(Nb_Equipements))

# Average equipement population
average_equipment_population <- merge(infra_per_department, Population_per_department_2015, by = "DepCode")
average_equipment_population$NbHabPerEquip = average_equipment_population$Population/average_equipment_population$NbEquip

# The life expectancy per departement 
Life_expectancy_department_2016$Avg_Exp = ((Life_expectancy_department_2016$Exp_Men + Life_expectancy_department_2016$Exp_Women)/2 - 82.3)/82.3

# Merged dataframe
merged_df = merge(average_equipment_population, Life_expectancy_department_2016, by = c("DepCode","DepName"))
ggplot(data=merged_df[1:20,], aes(x=DepCode, y=Avg_Exp , y1=NbHabPerEquip, color=DepCode)) + geom_col(position='dodge',show.legend = FALSE)

#select(merged_df,DepCode,NbHabPerEquip,Avg_Exp)
df_2_plot=data.frame(NbHabPerEquip=merged_df$NbHabPerEquip/10000,Avg_Exp=merged_df$Avg_Exp,DepCode=merged_df$DepCode)

df_2_plot = melt(df_2_plot,id.vars='DepCode')


ggplot(df_2_plot, aes(x=DepCode, y=value, fill=variable)) + geom_bar(stat='identity')
ggplot(df_2_plot, aes(x=DepCode, y=value, fill=variable)) + 
  geom_bar(stat='identity', position='dodge',show.legend = FALSE)
