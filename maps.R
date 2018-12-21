library('rgdal')      # Lire et reprojeter les cartes
library('plotrix')    # Créer des échelles de couleurs
library('classInt')   # Affecter ces couleurs aux données
library("ggplot2", lib.loc="~/R/R-3.5.1/library")
library("plyr", lib.loc="~/R/R-3.5.1/library")
library("reshape2", lib.loc="~/R/R-3.5.1/library")
library("grid")


# Metropolitan france
france_metrop <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", (10:95), "2A", "2B")

#Average nb equipements per inhabitants
Sportive_equipments_2015 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/20150801_RES_FichesInstallations.csv", sep=";")
Population_per_department_2015 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/Population_per_department_2015.csv", sep = ";")
Sportive_equipments_2015 <- Sportive_equipments_2015[which(Sportive_equipments_2015$DepCode%in%france_metrop), ]
Population_per_department_2015 <- Population_per_department_2015[which(Population_per_department_2015$DepCode%in%france_metrop), ]
infra_per_department <- ddply(Sportive_equipments_2015, "DepCode", summarize, NbEquip=sum(Nb_Equipements))
average_equipment_population <- merge(infra_per_department, Population_per_department_2015, by = "DepCode")
average_equipment_population$NbHabPerEquip = average_equipment_population$Population/average_equipment_population$NbEquip


# Life_expectancy df
Life_expectancy_department_2016 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/Life_expectancy_2016.csv", sep = ";",dec=",")
Life_expectancy_department_2016 <- Life_expectancy_department_2016[which(Life_expectancy_department_2016$DepCode%in%france_metrop), ]
Life_expectancy_department_2016$Avg_Exp = ((Life_expectancy_department_2016$Exp_Men + Life_expectancy_department_2016$Exp_Women)/2)

# Population variation
Population_variations_2010_2015 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/Population_variations_2010_2015.csv", sep=";",dec=".")

# Investment per departement
Budget_per_department_2015 = read.csv("C:/Users/Alex/Desktop/GitHub/Big Data/Depenses_InvestissementmentAllDept2015.csv", sep=";")
Budget_per_department_2015 <- merge(Budget_per_department_2015, Population_per_department_2015, by = "DepName")


# Lecture des départements
departements <- readOGR(dsn="C:/Users/Alex/Desktop/GitHub/Big Data/Maps/GEOFLA_1-1_SHP_LAMB93_FR-ED111/DEPARTEMENTS",  layer="DEPARTEMENT")

# Lecture des limites départementales pour sélectionner les frontières
frontieres <- readOGR(dsn="C:/Users/Alex/Desktop/GitHub/Big Data/Maps/GEOFLA_1-1_SHP_LAMB93_FR-ED111/DEPARTEMENTS",  layer="LIMITE_DEPARTEMENT")
frontieres <- frontieres[frontieres$NATURE %in% c('Fronti\xe8re internationale','Limite c\xf4ti\xe8re'),]





# Lecture des pays et sélection de l'Europe
europe <- readOGR(dsn="C:/Users/Alex/Desktop/GitHub/Big Data/Maps/ne_110m_admin_0_countries", layer="ne_110m_admin_0_countries")
europe <- europe[europe$REGION_UN=="Europe",]

# Projection en Lambert 93
europe <- spTransform(europe, CRS("+init=epsg:2154"))


################################################################################################
########################################  Life expectancy Map ##################################
################################################################################################


# Échelle de couleurs
col <- findColours(classIntervals(Life_expectancy_department_2016$Avg_Exp, 5, style="quantile"),smoothColors("#0C3269",98,"white"))
# Légende
leg <- findColours(classIntervals(round(Life_expectancy_department_2016$Avg_Exp), 5, style="quantile"),smoothColors("#0C3269",3,"white"),under="less than", over="more than", between="-",cutlabels=FALSE)

# Exportation en PDF avec gestion de la police
cairo_pdf('C:/Users/Alex/Desktop/GitHub/Big Data/Map_Results/life_expectancy.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

# Tracé de la carte
plot(frontieres, col="#FFFFFF")
plot(europe,     col="#E6E6E6", border="#AAAAAA",lwd=1, add=TRUE)
plot(frontieres, col="#D8D6D4", lwd=6, add=TRUE)
plot(departements,   col=col, border=col, lwd=.1, add=TRUE)
plot(frontieres, col="#666666", lwd=1, add=TRUE)

# Affichage de la légende
legend(-10000,6387500,fill=attr(leg, "palette"),
       legend=names(attr(leg,"table")),
       title = "Life expectancy in years :")

dev.off()


################################################################################################
##########################  Average nb of  equipements per inhabitants map #####################
################################################################################################

# Échelle de couleurs
col <- findColours(classIntervals(average_equipment_population$NbHabPerEquip, 10, style="quantile"),smoothColors("white",3,"#ff9d00"))
# Légende
leg <- findColours(classIntervals(round(average_equipment_population$NbHabPerEquip), 5, style="quantile"),smoothColors("white",3,"#ff9d00"),under="less than", over="more than", between="-",cutlabels=FALSE)

# Exportation en PDF avec gestion de la police
cairo_pdf('C:/Users/Alex/Desktop/GitHub/Big Data/Map_Results/avg_nb_equip.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

# Tracé de la carte
plot(frontieres, col="#FFFFFF")
plot(europe,     col="#E6E6E6", border="#AAAAAA",lwd=1, add=TRUE)
plot(frontieres, col="#D8D6D4", lwd=6, add=TRUE)
plot(departements,   col=col, border=col, lwd=.1, add=TRUE)
plot(frontieres, col="#666666", lwd=1, add=TRUE)

# Affichage de la légende
legend(-10000,6387500,fill=attr(leg, "palette"),
       legend=names(attr(leg,"table")),
       title = "Number of equipements :")

dev.off()


################################################################################################
###############################  Attractivness of each department ##############################
################################################################################################

# Échelle de couleurs
col <- findColours(classIntervals(Population_variations_2010_2015$Variation, 5, style="quantile"),smoothColors("red",5,"green"))
# Légende
leg <- findColours(classIntervals(round(Population_variations_2010_2015$Variation), 4, style="quantile"),smoothColors("red",4,"green"),under="less than", over="more than", between="-",cutlabels=FALSE)

# Exportation en PDF avec gestion de la police
cairo_pdf('C:/Users/Alex/Desktop/GitHub/Big Data/Map_Results/pop_var.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

# Tracé de la carte
plot(frontieres, col="#FFFFFF")
plot(europe,     col="#E6E6E6", border="#AAAAAA",lwd=1, add=TRUE)
plot(frontieres, col="#D8D6D4", lwd=6, add=TRUE)
plot(departements,   col=col, border=col, lwd=.1, add=TRUE)
plot(frontieres, col="#666666", lwd=1, add=TRUE)

# Affichage de la légende
legend(-10000,6387500,fill=attr(leg, "palette"),
       legend=names(attr(leg,"table")),
       title = "Population variations in % :")

dev.off()

################################################################################################
###############################  Attractivness of each department ##############################
################################################################################################

# Échelle de couleurs
col <- findColours(classIntervals(Population_variations_2010_2015$Variation, 5, style="quantile"),smoothColors("red",5,"green"))
# Légende
leg <- findColours(classIntervals(round(Population_variations_2010_2015$Variation), 4, style="quantile"),smoothColors("red",4,"green"),under="less than", over="more than", between="-",cutlabels=FALSE)

# Exportation en PDF avec gestion de la police
cairo_pdf('C:/Users/Alex/Desktop/GitHub/Big Data/Map_Results/pop_var.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

# Tracé de la carte
plot(frontieres, col="#FFFFFF")
plot(europe,     col="#E6E6E6", border="#AAAAAA",lwd=1, add=TRUE)
plot(frontieres, col="#D8D6D4", lwd=6, add=TRUE)
plot(departements,   col=col, border=col, lwd=.1, add=TRUE)
plot(frontieres, col="#666666", lwd=1, add=TRUE)

# Affichage de la légende
legend(-10000,6387500,fill=attr(leg, "palette"),
       legend=names(attr(leg,"table")),
       title = "Population variations in % :")

dev.off()


################################################################################################
##################################  Investment per departement #################################
################################################################################################

# Échelle de couleurs
col <- findColours(classIntervals(Budget_per_department_2015$Depensestotales_hab, 5, style="quantile"),smoothColors("white",5,"#e900ff"))
# Légende
leg <- findColours(classIntervals(round(Budget_per_department_2015$Depensestotales_hab), 4, style="quantile"),smoothColors("white",4,"#e900ff"),under="less than", over="more than", between="-",cutlabels=FALSE)

# Exportation en PDF avec gestion de la police
cairo_pdf('C:/Users/Alex/Desktop/GitHub/Big Data/Map_Results/budget.pdf',width=6,height=4.7)
par(mar=c(0,0,0,0),family="Myriad Pro",ps=8)

# Tracé de la carte
plot(frontieres, col="#FFFFFF")
plot(europe,     col="#E6E6E6", border="#AAAAAA",lwd=1, add=TRUE)
plot(frontieres, col="#D8D6D4", lwd=6, add=TRUE)
plot(departements,   col=col, border=col, lwd=.1, add=TRUE)
plot(frontieres, col="#666666", lwd=1, add=TRUE)

# Affichage de la légende
legend(-10000,6387500,fill=attr(leg, "palette"),
       legend=names(attr(leg,"table")),
       title = "Total expense per inhabitants :")

dev.off()
