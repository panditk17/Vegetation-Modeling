setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))


library(randomForest)


train<-read.csv("training_site2.csv")
valid<-read.csv("valid_site2.csv")

train<-train[,2:22]
valid<-valid[,2:22]
predictors_train<-train[,1:5]
valid_params<-valid[,1:5]

gpp_obs<-read.csv("modis_gpp_valid_site2.csv")



long_out<-matrix(nrow=0,ncol=11)

for (j in seq(1,10,1)) {
  all_ran_out<-matrix(0,nrow=0,ncol=1)
  all_rmse<-matrix(0,nrow=0,ncol=1)
  
  params<-matrix(c(0.89,2.3,3,0.34,959,0.7,2.82,3.8,0.42,2164,0.74,2.73,5,0.12,577,1.34,1.67,
                   4.3,0.28,244,0.84,1.70,5,0.37,1698,0.88,1.75,3.3, 0.38,1601,0.84,1.95,4.8,
                   0.13,231,1.35,1.74,4.2,0.4,2024,1.46,1.89,4.6,0.17,942,1.05,2.83,3.8,0.5,
                   1823),nrow=10,byrow =TRUE)
  
  p_root <- params[j,1]
  p_q<-params[j,2]
  p_ss<-params[j,3]
  p_leaf<-params[j,4]
  p_cc<-params[j,5]
  
  
  p_all<-cbind(p_root,p_q,p_ss,p_leaf,p_cc)
  
  #p_all[j]<-cbind(p_root[j],p_q[j],p_ss[j],p_leaf[j],p_cc[j])
  
  #one_data_test<-as.data.frame
  colnames(p_all)<-c("root","q","ss","leaf","cc")
  
  

  for (i in seq(18,21,1)) {
    response_train<-train[,i]
    response_valid<-valid[,i]
    refmodel.rf<-randomForest(x=predictors_train, y=response_train,ntree=100,oob.prox=TRUE)#see help file for options
    
    refmodel.pred<-predict(refmodel.rf,newdata=valid)#adding ,newdata=data allows for testing data
    
    
    val_out<-predict(refmodel.rf,newdata=p_all)#adding ,newdata=data allows for testing data
    
    obs_pred<-cbind(refmodel.pred,response_valid)
    
    diff_sq<-(obs_pred[,1]-obs_pred[,2])^2
    mse<-mean(diff_sq)
    rmse<-sqrt(mse)
    
    
    all_rmse<-rbind(rmse,all_rmse)
    
    all_ran_out<-rbind(val_out,all_ran_out)
    
    all_ran_out_t<-t(all_ran_out)
    
  }
  
  rmse_data<-mean(all_rmse)
  
  
  ran_comp<-cbind(gpp_obs,all_ran_out)
  diff_ran<-(ran_comp[,2]-ran_comp[,3])^2
  mse_ran<-mean(diff_ran)
  rmse_ran<-sqrt(mse_ran)
  
  
  ran_data<-cbind(p_all,rmse_ran,rmse_data,all_ran_out_t)
  long_out<-rbind(long_out,ran_data)
  
  rm(all_ran_out)
  rm(all_ran_out_t)
  rm(all_rmse)
  
}

write.csv(long_out,"newout_site22_avalid.csv")
