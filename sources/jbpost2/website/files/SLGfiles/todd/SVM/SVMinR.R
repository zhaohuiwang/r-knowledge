#install e1071 package
install.packages('e1071', dependencies=T)

#load libraries

library(MASS)
library(e1071)

########################################################
###           SVM using cats data set in R           ###
###      Open source code available on Wikibooks     ###
########################################################

#load data set
data(cats)

#build SVM
model       <- svm(Sex~., data = cats)

#view results
summary(model)
plot(model, cats)

#divide data into training and test sets
index       <- 1:nrow(cats)
testindex   <- sample(index, trunc(length(index)/3))
testset     <- cats[testindex,]
trainset    <- cats[-testindex,]

#build SVM with training data
model       <- svm(Sex~., data = trainset)
prediction  <- predict(model, testset[,-1])

#confusion matrix
table(pred = prediction, true = testset[,1])

#tune model parameters
tuned       <- tune.svm(Sex~., data = trainset, gamma = 10^(-6:-1), cost = 10^(1:2))
summary(tuned)

########################################################
###           SVM using iris data set in R           ###
###             Code written by Melvin L             ###
########################################################

#unclassified, colored by species
plot(iris$Petal.Width, iris$Petal.Length, col = iris$Species)

#split data into train and test sets
s           <- sample(150,100)
col         <- c("Petal.Length", "Petal.Width", "Species")
iris_train  <- iris[s, col]
iris_test   <- iris[-s, col]

#fit svm
svmfit      <- svm(Species ~ ., data = iris_train, kernel = "linear", cost = 0.1, scale = F)

#see svm output
print(svmfit)

#visualize svm results
plot(svmfit, iris_train[,col])

#identify optimal cost parameter using cross validation
tuned       <- tune(svm, Species ~ ., data = iris_train, kernel = "linear", ranges = list(cost = c(0.001, 0.01, 0.1, 1, 10, 100)))
summary(tuned)

#predictions for the test data
p           <- predict(svmfit, iris_test[,col], type = "class")

#test model performance
table(p, iris_test[,3])
mean(p == iris_test[,3])