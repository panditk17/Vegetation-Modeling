setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))

library(randomForest)


data_ttt<-read.csv("ndata_train_site2.csv")
data_vvv<-read.csv('ndata_test_site2.csv')

pred_test<-data_vvv[,7:11]
resp_test<-data_vvv[,3]

predictors<-data_ttt[,7:11]# define predictors
response<-data_ttt[,3]#define dependent 

refmodel.rf<-randomForest(x=predictors, y=response,ntree=100,oob.prox=TRUE)#see help file for options

refmodel.pred<-predict(refmodel.rf,newdata=pred_test)#adding ,newdata=data allows for testing data
refmodel.pred2<-predict(refmodel.rf,newdata=data_vvv)#adding ,newdata=data allows for testing data


p_root <- round(runif(1,0.099, 2.001),2)
p_q<-round(runif(1,0.039,4.001),2)
p_ss<-round(runif(1,2.99,12.001),1)
p_leaf <- round(runif(1,0.099, 2.001),2)
p_cc<-sample(99:10001,1)

p_all<-cbind(p_root,p_q,p_ss,p_leaf,p_cc)
one_data_test<-as.data.frame(p_all)
colnames(one_data_test)<-c("root","q","ss","leaf","cc")

model_gpp<-predict(refmodel.rf,newdata=one_data_test)#adding ,newdata=data allows for testing data

test_gpp<- 0.65



compared<-cbind(observed = data_vvv[,3], predicted = refmodel.pred)
write.csv(compared,"compare_obs_pred.csv")

plot(data_vvv[,3],refmodel.pred)
diff<-(data_vvv[,3]-refmodel.pred)^2
meandiff<-mean(diff)
rmse<-sqrt(meandiff)
## Show "importance" of variables: higher value mean more important:
round(importance(refmodel.rf), 2)
