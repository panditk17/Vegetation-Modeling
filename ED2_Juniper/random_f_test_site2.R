setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))


library(randomForest)

#whole_site2<-read.csv('new_whole_data_site2.csv')

## 75% of the sample size
#smp_size <- floor(0.75 * nrow(whole_site2))

## set the seed to make your partition reproducible
#set.seed(123)
#train_ind <- sample(seq_len(nrow(whole_site2)), size = smp_size)

#train <- whole_site2[train_ind, ]
#valid <- whole_site2[-train_ind, ]

#write.csv(train,"ntraining_site2.csv")
#write.csv(valid,"nvalid_site2.csv")

train<-read.csv("training_site2.csv")
valid<-read.csv("valid_site2.csv")

train<-train[,2:22]
valid<-valid[,2:22]

predictors_train<-train[,1:5]
valid_params<-valid[,1:5]

gpp_obs<-read.csv("gpp_data_site1.csv")


all_rmse<-matrix(0,nrow=0,ncol=1)
all_ran_out<-matrix(0,nrow=0,ncol=1)
long_out<-matrix(0.50,nrow=10,ncol=7)

for (j in seq(1,20,1)) {
  
  p_root<- round(runif(1,0.099, 2.001),2)
  p_q<-round(runif(1,0.039,4.001),2)
  p_ss<-round(runif(1,2.99,12.001),1)
  p_leaf <- round(runif(1,0.099, 2.001),2)
  p_cc<-sample(99:10001,1)
  
  p_all<-cbind(p_root,p_q,p_ss,p_leaf,p_cc)
  
  #p_all[j]<-cbind(p_root[j],p_q[j],p_ss[j],p_leaf[j],p_cc[j])
  
  #one_data_test<-as.data.frame
  colnames(p_all)<-c("root","q","ss","leaf","cc")
  
  
  
  for (i in seq(6,17,1)) {
    response_train<-train[,i]
    response_valid<-valid[,i]
    refmodel.rf<-randomForest(x=predictors_train, y=response_train,ntree=100,oob.prox=TRUE)#see help file for options
    
    refmodel.pred<-predict(refmodel.rf,newdata=valid)#adding ,newdata=data allows for testing data
    
    
    ran_out<-predict(refmodel.rf,newdata=p_all)#adding ,newdata=data allows for testing data
    
    obs_pred<-cbind(refmodel.pred,response_valid)
    
    diff_sq<-(obs_pred[,1]-obs_pred[,2])^2
    mse<-mean(diff_sq)
    rmse<-sqrt(mse)
    
    
    all_rmse<-rbind(rmse,all_rmse)
    
    all_ran_out<-rbind(ran_out,all_ran_out)
    
  }
  
  
  rmse_data<-mean(all_rmse)
  
  ran_comp<-cbind(gpp_obs,all_ran_out)
  diff_ran<-(ran_comp[,2]-ran_comp[,3])^2
  mse_ran<-mean(diff_ran)
  rmse_ran<-sqrt(mse_ran)
  
  ran_data<-cbind(p_all,rmse_ran,rmse_data)
  
  if (rmse_ran < max(long_out[,6])) { 
    
    long_out<-rbind(ran_data,long_out)
    
    
    #long_out<-long_out[-which.max(long_out[,6]),]
    long_out<-long_out[order(long_out[,6]),]
    long_out<-long_out[1:10,]
    
    
    
  }
  
}

write.csv(long_out,"out_site2.csv")
rmse_rmse<-mean(long_out[,7])
