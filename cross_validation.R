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
                  ,lambda   = subGrid[,'lambda']
                  ,eta = subGrid[,'eta']
                  ,min_child_weight = subGrid[,'min_child_weight']
                  ,subsample = subGrid[,'subsample']
                  ,colsample_bytree = subGrid[,'colsample_bytree']
                  ,max_depth = subGrid[,'max_depth']
  )
  
  fit <- xgb.train  ( params            = params
                      ,data             = k.xgbTrain
                      ,nround           = subGrid[,'nround']
                      ,watchlist        = watchlist
                      ,print.every.n    = 50
                      ,early.stop.round = 20
                      ,maximize         = FALSE
                      
  )
  
  
  cv.preds <- predict(fit, k.xgbTest)
  cv.errors[m]<- RMSE(k.testResp, cv.preds)
  # cv.errors[m]<-wgtdNormalizedGini(k.testResp, cv.preds)
  
  
}

