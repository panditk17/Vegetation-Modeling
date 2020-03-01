

setwd('c:/Karun_documents/juniper') 


#setwd('/home/karunpandit/sla_2') 

# remove previous files
rm(list=ls()) 


library(randomForest)
datain<-read.csv(file="Rout.csv")
#data must have a header included as first row
#data must be columns as follows
# lai, canG, cgv,maxheight,diameter,area,cgv50,cgv60,cgv70,height70,bottom, biomass
#Rout must be randomized already

trees<-as.data.frame(datain) #attach as data frame

#predictors<-trees[,1:11]# define predictors
#response<-trees[,12]#define dependent 
#treemodel.rf<-randomForest(x=predictors, y=response,ntree=1000,oob.prox=TRUE)#see help file for options
#treemodel.pred<-predict(treemodel.rf)#adding ,newdata=data allows for testing data
#treemodel.pred#display
#write.table(treemodel.pred,"RFtest2.csv",sep=",",append=FALSE)#writes the fitted trees to file

#cross validation (leave-one-out):

m<-nrow(trees) #number of trees

diffvector<-c(1:m) #empty space for output

for(i in 1:m){ #for each tree, we're gonna take one out
  if(i==1){                       #special first row(not that efficient, but effective)
    predictors<-trees[2:m,1:11] #take out first predictor
    response<-trees[2:m,12]     #take out first response
    predictortest<-trees[1,1:11] #test precitcor is removed row
  }
  if(i>=2 && i<m-1){               #this will work for all of the other rows but the last
    predtemp1=trees[1:i-1,1:11]  #rows before i
    predtemp2=trees[i+1:m,1:11]	#rows after i	
    j=m-i                        #NA remover
    predtemp2=predtemp2[1:j,]   #removes NAs
    
    predictors<-rbind(predtemp1,predtemp2) #concatenate
    
    resptemp1=trees[1:i-1,12]   #repeat for responses
    resptemp2=trees[i+1:m,12]   #column 12 is response variable (biomass)
    resptemp2=resptemp2[1:j]
    response<-c(resptemp1,resptemp2)
    predictortest<-trees[i,1:11]
    
  }
  if(i==147){
    predictors<-trees[1:m-1,1:11] #special case for last tree
    response<-trees[1:m-1,12]
    predictortest<-trees[m,1:11]
  }
  
  treemodel.rf<-randomForest(x=predictors, y=response,ntree=1000,oob.prox=TRUE,na.action=na.ignore) #run RF on dataset minus 1
  treemodel.pred<-predict(treemodel.rf,newdata=trees[i,1:11]) #predict tree that we took out
  
  diffvector[i]<-(treemodel.pred-trees[i,12])^2 #compare output to the actual value
  
}


rmseout<-sqrt(sum(diffvector)/m) #compute RMSE
rmseout




