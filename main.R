
source("cross_validation.R")
install.packages("titanic")
library(titanic)
library(pROC)

#Let's test the cross validation code using the Iris dataset 

#we will first use the xgb cross validation sample function

summary(Titanic)


#remove all categorical featuers for simplicity
train <- titanic_train[, !(colnames(titanic_train) %in% c("Survived","PassenderId","Name","Ticket","Cabin" ))  ]

#convert all the other features to numeric 
train <- as.data.frame(apply(train, 2, function(x) as.numeric(as.factor(x) ) )) 

resp <- as.numeric(titanic_train$Survived)

cv.errors <- cross_validation_xgb(k=5,train.data = train, resp = resp, objective = "binary:logistic")

