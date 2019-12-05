#Aleksandra Dobrego
#November 22, 2019
#It's an R Studio Exercise 4: Data Wrangling

#Reading "Human Development"
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
#reading "Gender Inequality"
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#exploring the datasets
str(hd)
str(gii)
dim(hd)
dim(gii)
summary(hd)
summary(gii)

#renaming the variables
colnames(hd) #see the names
names(hd) <- c("HDI_Rank", "Country", "HDI_index", "life_at_birth", "educ_exp", "educ_mean", "GNI", "GNI_HDI")
colnames(hd) #recheck new names
colnames(gii) #see the names
names(gii) <- c("GII_Rank", "Country", "gender_index", "mat_mort", "adol_birth", "%_parliament", "educ_female", "educ_male", "labour_female", "labour_male")
colnames(gii) #recheck new names

#mutation of gii and creating two new variables
gii <- mutate(gii, ratio_educ = educ_female / educ_male, ratio_labour = labour_female / labour_male)

#joining two datasets
human <- inner_join(hd, gii, by = "Country")
#checking the dimensions of my dataset
dim(human)
#saving the human dataset to the data folder
setwd("~/IODS-project/data")
write.table(human, file = "human.csv")

#Aleksandra Dobrego
#November 29, 2019
#It's an R Studio Exercise 5: Data Wrangling

#although I have done the data wrangling last week, lets download the data from the web:
human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", stringsAsFactors = F)

#exploring the dataset
str(human)
dim(human)
#the dataset has 195 observations (rows) and 19 variables (columns)
#it is a United Nations data for Human Development Index in different countries depending on such parameters as education, labour, life expectancy and others

#mutating the data: transforming the GNI to numeric
library(stringr)
str(human$GNI)
human <- mutate(human, GNI = str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric)
str(human$GNI)

#excluding some variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F") #choosing columns to keep
human <- dplyr::select(human, one_of(keep)) #keeping only the columns above
names(human) #checking the columns

#removing rows with NAs
complete.cases(human) #a completeness indicator - FALSEs are the ones with missing columns
data.frame(human[-1], comp = complete.cases(human)) #double check - yep, correct
human <- filter(human, complete.cases(human)) #removing the NAs

#removing the regions' observations
human$Country #lets find the ones related to regions
tail(human$Country, n = 7) #last 7 observations are regions
human <- human[1:155, ] #choosing everything until last 7 observations

#row names as country names
rownames(human) <- human$Country #now countries are rownames
human <- dplyr::select(human, -Country) #removing the Country column
write.csv(human, file = "human.csv")
read.csv("human.csv")
