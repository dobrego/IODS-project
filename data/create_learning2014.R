#Aleksandra Dobrego
#November 8, 2019
#It's an R Studio Exercise 2: Part 1 (Data Wrangling)

install.packages("dplyr")
library("dplyr")

#reading the data
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = T)
#structure
str(learning2014) #variables are integer, except for gender which is a factor
#dimensions
dim.data.frame(learning2014) #contains 183 rows (observations) and 60 columns (variables)

#questions related to deep, stra, surf
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
#creating columns out of combined questions and scaling them
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)
#gender, age, attitude and points are ready
#choosing columns for dataset
chosen_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
#creating a new dataset
my_learning <- select(learning2014, one_of(chosen_columns))
#excluding the points that are zero
my_learning <- filter(my_learning, Points > 0)

#setting working directory to IODS project data folder
setwd("~/IODS-project/data")
#saving new dataset there
write.table(my_learning, file = "learning2014.csv")

#reading the data again
read.table("learning2014.csv")
#making sure the data is correct
str(read.table("learning2014.csv"))
head(read.table("learning2014.csv"))
