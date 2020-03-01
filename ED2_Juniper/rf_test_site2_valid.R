setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))


library(randomForest)

#whole_site1<-read.csv('new_whole_data_site1.csv')

## 75% of the sample size
#smp_size <- floor(0.75 * nrow(whole_site1))

## set the seed to make your partition reproducible
#set.seed(123)
#train_ind <- sample(seq_len(nrow(whole_site1)), size = smp_size)

#train <- whole_site1[train_ind, ]
#valid <- whole_site1[-train_ind, ]

#write.csv(train,"ntraining_site1.csv")
#write.csv(valid,"nvalid_site1.csv")

train<-read.csv("training_site1.csv")
valid<-read.csv("valid_site1.csv")

train<-train[,2:22]
valid<-valid[,2:22]
predictors_train<-train[,1:5]
valid_params<-valid[,1:5]

gpp_obs<-read.csv("modis_gpp_valid_site1.csv")


#all_rmse<-matrix(0,nrow=0,ncol=1)
#all_ran_out<-matrix(0,nrow=0,ncol=1)
long_out<-matrix(nrow=0,ncol=11)

for (j in seq(1,10,1)) {
  all_ran_out<-matrix(0,nrow=0,ncol=1)
  all_rmse<-matrix(0,nrow=0,ncol=1)
  
  params<-matrix(c(0.31,2.34,9.7,0.18,9704,0.39,2.45,9,0.52,8228,0.44,2.56,7.3,0.13,8209,
                   0.52,0.19,6.8,0.18,9285,0.13,2.03,6.2,0.37,9230,0.52,2.84,5.8,0.35,7600,
                   0.42,1.67,8.2,0.30,8942,0.38,2.86,7.3,0.46,8250,0.13,1.43,8.9,0.12,8398,
                   0.28,1.62,8.2,0.56,9009),nrow=10,byrow =TRUE)
  
  p_root <- params[j,1]
  p_q<-params[j,2]
  p_ss<-params[j,3]
  p_leaf<-params[j,4]
  p_cc<-params[j,5]
  

  p_all<-cbind(p_root,p_q,p_ss,p_leaf,p_cc)
  
  #p_all[j]<-cbind(p_root[j],p_q[j],p_ss[j],p_leaf[j],p_cc[j])
  
  #one_data_test<-as.data.frame
  colnames(p_all)<-c("root","q","ss","leaf","cc")
  
  
 # i=19
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

write.csv(long_out,"nout_site11_avalid.csv")
