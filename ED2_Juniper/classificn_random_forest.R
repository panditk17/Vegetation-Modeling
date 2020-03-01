library(randomForest)
datain<-read.csv(file="11_training.csv")
ref<-as.data.frame(datain) #attach as data frame
datain<-read.csv(file="11_validation.csv")
ref_test<-as.data.frame(datain) #attach as data frame

predictors<-ref[,1:17]# define predictors
response<-ref[,18]#define dependent 
refmodel.rf<-randomForest(x=predictors, y=response,ntree=1000,oob.prox=TRUE)#see help file for options
refmodel.pred<-predict(refmodel.rf,newdata=ref_test)#adding ,newdata=data allows for testing data
refmodel.pred#display
write.table(refmodel.pred,"ref_result.csv",sep=",",append=FALSE)#writes the fitted trees to file
table(observed = ref_test[,18], predicted = refmodel.pred)
## Show "importance" of variables: higher value mean more important:
round(importance(refmodel.rf), 2)
