setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))


library(randomForest)

whole_site1<-read.csv('new_whole_data_site1.csv')

## 75% of the sample size
smp_size <- floor(0.75 * nrow(whole_site1))

## set the seed to make your partition reproducible
set.seed(123)
train_ind <- sample(seq_len(nrow(whole_site1)), size = smp_size)

train <- whole_site1[train_ind, ]
valid <- whole_site1[-train_ind, ]

write.csv(train,"ntraining_site1.csv")
write.csv(valid,"nvalid_site1.csv")

#train<-read.csv("training_site1.csv")
#valid<-read.csv('valid_site1.csv')

predictors_train<-train[,1:5]
valid_params<-valid[,1:5]

all_rmse<-matrix(0,nrow=0,ncol=1)

for (i in seq(12,21,1)) {
  response_train<-train[,i]
  response_valid<-valid[,i]
  refmodel.rf<-randomForest(x=predictors_train, y=response_train,ntree=100,oob.prox=TRUE)#see help file for options
  
  refmodel.pred<-predict(refmodel.rf,newdata=valid)#adding ,newdata=data allows for testing data
  refmodel.pred2<-predict(refmodel.rf,newdata=valid_params)#adding ,newdata=data allows for testing data
  
  obs_pred<-cbind(response_valid,refmodel.pred)
  diff_sq<-(obs_pred[,1]-obs_pred[,2])^2
  mse<-mean(diff_sq)
  rmse<-sqrt(mse)
  
  
  all_rmse<-rbind(rmse,all_rmse)
  
}


mean_rmse<-mean(all_rmse)

p_all<-matrix(0,ncol=5)
j=1
p_root[j] <- round(runif(1,0.099, 2.001),2)
p_q[j]<-round(runif(1,0.039,4.001),2)
p_ss[j]<-round(runif(1,2.99,12.001),1)
p_leaf[j] <- round(runif(1,0.099, 2.001),2)
p_cc[j]<-sample(99:10001,1)

p_all<-cbind(p_root,p_q,p_ss,p_leaf,p_cc)

#p_all[j]<-cbind(p_root[j],p_q[j],p_ss[j],p_leaf[j],p_cc[j])

#one_data_test<-as.data.frame
colnames(p_all)<-c("root","q","ss","leaf","cc")


for (i in seq(12,21,1)) {
  response_train<-train[,i]
  response_valid<-valid[,i]
  refmodel.rf<-randomForest(x=predictors_train, y=response_train,ntree=100,oob.prox=TRUE)#see help file for options
  
  refmodel.pred<-predict(refmodel.rf,newdata=valid)#adding ,newdata=data allows for testing data
  refmodel.pred2<-predict(refmodel.rf,newdata=valid_params)#adding ,newdata=data allows for testing data
  
  obs_pred<-cbind(response_valid,refmodel.pred)
  diff_sq<-(obs_pred[,1]-obs_pred[,2])^2
  mse<-mean(diff_sq)
  rmse<-sqrt(mse)
  
  
  all_rmse<-rbind(rmse,all_rmse)
  
}






model_gpp<-predict(refmodel.rf,newdata=p_all)#adding ,newdata=data allows for testing data

test_gpp<- 0.65

diff_big<-(model_gpp-test_gpp)^2
mse_big<-mean(diff_big)
rmse_big<-sqrt(mse_big)






## Show "importance" of variables: higher value mean more important:
round(importance(refmodel.rf), 2)
