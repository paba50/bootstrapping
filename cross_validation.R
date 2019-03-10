install.packages("xgb")

RMSE <- function(observed, predicted) {
  rmse <- mean((observed - predicted)^2)
  return(rmse)
}

cross_validation_xgb <- function(k=4,train.data,resp, wgt=rep(1,nrow(train.data)), objective = "reg:linear" , lambda=1, 
                                 eta=0.3, min_child_weight=1, subsample=1, colsample_bytree=1, max_depth=6, nround=100) {
  
  #This sample code both builds the model for all the given parameters and 
  
  #parameters for cross validation
  #k = number of folds
  
  #Parameters specific to the xgb model
  #lambda = L2 regularization term on weights. Higher value means more conservative
  #eta = learning rate, lower step size avoids overfitting.  
  #min_child_weight = Minimum sum of instance weight needed in a child. if a tree split into a leafnode with the sum of instance weights
  #less than the min_child_weight then it will stop further splitting the tree. In linear regression task, 
  #this simply corresponds to minimum number of instances needed to be in each node. 
  #subsample = Subsample ratio of the training instances. Avoids overfitting. Subsampling will occur once in every boosting iteration.
  #colsample_bytree = subsampling columns. 
  #max_depth = maximum depth of a tree, higher value will make the model more complex and more likely to overfit 
  #nround =  maximum number of trees to grow/max number of iterations in linear 
  
  cv.errors = array(k)
  n <- nrow(train.data)/k
  
  for(m in 1:k){
    
    # Define fold ranges
    t1<-((m - 1) * n + 1)
    t2<-(m * n)
    test.range <- t1:t2
    
    k.train <- train.data[-test.range,]
    k.trainResp <- resp[-test.range]
    k.wgt_train <- wgt[-test.range]
    k.test  <- train.data[test.range,]
    k.testResp<- resp[test.range]
    k.wgt_test <- wgt[test.range]
    
    k.xgbTrain <- xgb.DMatrix(as.matrix(k.train), label = k.trainResp, weight = k.wgt_train)
    k.xgbTest <- xgb.DMatrix(as.matrix(k.test), label = k.testResp, weight = k.wgt_test)
    watchlist <-list(valid = k.xgbTest, train = k.xgbTrain)
    
    
    params <- list( objective = objective
                    ,lambda   = lambda
                    ,eta = eta
                    ,min_child_weight = min_child_weight
                    ,subsample = subsample
                    ,colsample_bytree = colsample_bytree
                    ,max_depth = max_depth
    )
    
    fit <- xgb.train  ( params            = params
                        ,data             = k.xgbTrain
                        ,nrounds           = nround
                        ,watchlist        = watchlist
                        ,print.every.n    = 50
                        ,early.stop.round = 20
                        ,maximize         = FALSE
                        ,eval_metric = "auc"
                        
    )
    
    
    cv.preds <- predict(fit, k.xgbTest)
    auc <- roc(response= k.testResp, predictor = cv.preds )
    #cv.errors[m]<- RMSE(k.testResp, cv.preds)
    cv.errors[m] <- auc$auc    
    
  }
  
  return(cv.errors)
  
  
  
}


