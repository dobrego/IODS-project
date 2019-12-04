#Aleksandra Dobrego
#December 4th, 2019
#It's an R Studio Exercise 6: Data Wrangling

#Loading datasets
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")
setwd("~/IODS-project/data") #setting work directory to data folder
write.table(BPRS, file = "BPRS.csv") #writing BPRS to data folder
write.table(rats, file = "rats.csv") #writing rats to data folder
names(BPRS) #checking variable names for BPRS
names(rats) #checking variable names for rats
str(BPRS) #all variables are integer
str(rats) #all variables are integer
summary(BPRS) #we can see here week variables changing over time
summary(rats) #same here

#Converting categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
str(BPRS) #checking
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)
str(rats) #checking

#Converting data sets to long form
library(dplyr)
library(tidyr)
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5))) #adding week number
RATSL <- rats %>% gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD,3,4))) #adding time

#Comparing the wide form and the long form versions
names(BPRSL)
names(BPRS)
#we don't want weeks to be independent variables, so the long form collapsed all of them into key-value pairs under "weeks"
names(RATSL)
names(rats)
#we don't want WDs to be independent variables, so the long form collapsed all of them into key-value pairs under "WD"
str(BPRSL)
str(BPRS)
str(RATSL)
str(rats)
summary(BPRSL)
summary(RATSL)



