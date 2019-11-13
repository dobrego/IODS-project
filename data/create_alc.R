#Aleksandra Dobrego
#November 13, 2019
#It's an R Studio Exercise 3: Part 1 (Data Wrangling). Data here: https://github.com/dobrego/IODS-project/tree/master/data

#all needed libraries
library(dplyr)
library(ggplot2)

#setting working directory to my data folder
setwd("~/IODS-project/data")
#reading the data
studentmat <- read.table("student-mat.csv", sep = ";", header = T)
studentpor <- read.table("student-por.csv", sep = ";", header = T)
#exploring structure and dimensions
str(studentmat)
str(studentpor)
dim(studentmat)
dim(studentpor)

#joining datasets and keeping only the students present in both data sets
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
joineddataset <- inner_join(studentmat, studentpor, by = c(join_by))
#exploring strucre and dimensions
str(joineddataset)
dim(joineddataset)

#combining duplicated answers
joineddata <- select(joineddataset, one_of(join_by))
notjoined_columns <- colnames(studentmat)[!colnames(studentmat) %in% join_by]
for(column_name in notjoined_columns) {
  two_columns <- select(joineddataset, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
    joineddata[column_name] <- round(rowMeans(two_columns))
  } else {
    joineddata[column_name] <- first_column
  }
}

#creating a new column which shows average weekday and weekend alcohol consumption
joineddata <- mutate(joineddata, alc_use = (Dalc + Walc) / 2)
#creating a new clogical column high_use
joineddata <- mutate(joineddata, high_use = alc_use > 2)

#looking at the dataset
glimpse(joineddata)
#saving the dataset
write.table(joineddata, file = "joineddata.csv")


