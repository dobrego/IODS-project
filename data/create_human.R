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

