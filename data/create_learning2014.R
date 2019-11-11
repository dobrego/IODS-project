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

#November 11, 2019
#It's an R Studio Exercise 2: Part 2 (Analysis)

#1
#reading a file
my_learning <- read.table("learning2014.csv")
#exploring structure and dimensions
str(my_learning) 
#3 numeric variables (deep = deep learning, stra = strategic learning, surf = surface learning), 3 integer variables (points, age, attitude) and 1 factor variable (gender)
dim(my_learning) #the dataset has 166 observations and 7 variables

#2
#graphical overview of the data: Attitude and Points coloured by gender
ggplot(my_learning, aes(x = Attitude, y = Points, col = gender)) +
  geom_point() 
#summaries of variables
summary(my_learning) # we have twice more males than females
#distribution of other variables
hist(my_learning$Age) #not normal
hist(my_learning$Attitude) #normal
hist(my_learning$deep) #not normal
hist(my_learning$stra) #?? 
hist(my_learning$surf) #normal
hist(my_learning$Points) #normal
#relationship between variables
ggpairs(my_learning, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
#conclusion of variables: correlation is actually very low for all variables, but the highest is for attitude&points

#3
#multiple regression model with attutude, strategic questions and deep learning questions; exam points is a dependent variable
model <- lm(Points ~ Attitude + stra + deep, data = my_learning)
#summary of the model
summary(model)
#interpretation of model results and stats: 
#p value is very low, which means hat, at least, one of the predictor variables is significantly related to the outcome variable
#only attitude can explain points well, that is, changes is attitude will affect points
#as others are not significating, we can remove them from the model
#removing stra from the model
modelnostra <- lm(Points ~ Attitude + deep, data = my_learning)
summary(modelnostra)
#also removing deep from the model
modelnostranodeep <- lm(Points ~ Attitude, data = my_learning)
summary(modelnostranodeep) #it is the best model (it minimizes the prediction errors = residuals)

#4
#i am going back to the original model and explaining it
model <- lm(Points ~ Attitude + stra + deep, data = my_learning)
summary(model)
#relationship between variables and the target (null hypothesis: actual value of Attitude is 0)
#only changes in attitude affect the exam points
#interpreting the multiple R-squared: 
#correlation coefficient between observed values and predicted values
#here R = 0.2097, which means that only 20% of of the variance in the points can be explained by chosen variables

#5
model <- lm(Points ~ Attitude + stra + deep, data = my_learning)
#plot of Residuals vs Fitted Values: used to explore whether errors depend on explanatory variables
plot(model, which = c(1))
#our resfit plot looks reasonable
#normal QQplot: used to explore whether the errors are normally distributed
plot(model, which = c(2))
#our QQplot looks reasonable
#plot of residuals vs leverage: identify which observations have unusually high impact on the model
plot(model, which = c(5))
#our plot looks bad: there is an outlier and leverage is high
