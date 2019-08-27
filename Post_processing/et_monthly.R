# Codes to read cohort level outputs, patch level outputs and polygon level outputs
# and calculate polygon level outputs from cohort outputs over time
# Karun Pandit

setwd('/home/karunpandit/wbs_f_c') # Define working directory

# remove previous files
rm(list=ls()) 

# install necessary packages
library(rhdf5)
#library(ncdf4)

styr <- 2016
endyr <- 2017
stmn <- 1
endmn <- 12

var = "DMEAN_VAPOR_AC_PY"
var_name = "ET (mm)"

abc_1<-matrix(nrow=0,ncol=4)

for (year in seq (styr, endyr,1)) {
  if (year==styr) {stmn=10} else {stmn=1} 
  if (year==endyr) {endmn=9} else {endmn=12}
  for (cmm in seq(stmn, endmn, 1)) {
    
    if (cmm == 1) {dd = 31}
    if (cmm == 2) {dd = 28}
    if (cmm == 3) {dd = 31}
    if (cmm == 4) {dd = 30}
    if (cmm== 5) {dd = 31}
    if (cmm== 6) {dd = 30}
    if (cmm== 7) {dd = 31}
    if (cmm== 8) {dd = 31}
    if (cmm== 9) {dd = 30}
    if (cmm== 10) {dd = 31}
    if (cmm== 11) {dd = 30}
    if (cmm== 12) {dd = 31}
    
    for (cdd in seq(1,dd,1)) {
      cmmm <- sprintf("%02d",cmm)
      cddd <- sprintf("%02d",cdd)
      
      filexx <- paste0("hhh-D-",year,"-",cmmm,"-",cddd,"-000000-g01.h5")
      
      fileyyy <- h5read(filexx,var)
      
      filell<-h5read(filexx,"DMEAN_VAPOR_LC_PY")
      fileww<-h5read(filexx,"DMEAN_VAPOR_WC_PY")
      filegg<-h5read(filexx,"DMEAN_VAPOR_GC_PY")
      filett<-h5read(filexx,"DMEAN_TRANSP_PY")
      fileoo<-filegg+filett
      
      
      fileyy<- -sum(fileyyy)*86400
      
      yr <- year
      cmm1 = sprintf("%02d",cmm)
      date1 <- paste0(yr,cmm1)
      date2 <- yr
      date3<- paste0(yr,"-",cmm1,"-",cddd)
      abab<- cbind(fileyy,date1,date2,date3)
      abc_1 <- rbind(abc_1,abab)
      
    }
  }
}


simtot1<-as.numeric(abc_1[,1])
month1<-as.numeric(abc_1[,2])


#meansimtot_ens<-mean(simtot)
#meansimtot_best<-mean(simtot2)
#sdsimtot_ens<-sd(simtot)
#sdsimtot_best<-sd(simtot2)

testdata<-read.csv(file="/home/karunpandit/GPP_2017_RCEW.csv")

test<- testdata[,5]

month3<- as.character(testdata[,4])



#sdsimsub_ens<-sd(simtotsub1)
#meansimsub_ens<-mean(simtotsub1)


abc_2<-aggregate(simtot1~month1, FUN=mean)


cde_2<-aggregate(test~month3, FUN=mean)

cde1<-cde_2[1:1,]
cde2<-cde_2[2:4,]
cde3<- cde_2[5:12,]
cde_22<-rbind(cde2,cde1,cde3)

all<-cbind(simtot1,month3,test)

library(ggplot2)
library(reshape2)

mall<-cbind(cde_22[,1],abc_2[,2],cde_22[,2])



ttt<-t(mall)

rownames(ttt)<-c("months","one","two")
#colnames(ttt)<-c("Oct","Nov","Dec","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep")
colnames(ttt)<-c("O","N","D","J","F","M","A","M","J","J","A","S")

dev.new()
plotname1 <- paste0("validation_ET_monthly_ls_new",var,".png")

png(plotname1,res = 300,width =6,height=4,units='in')

par(mar=c(4,7,1,2))



#dev.new()
colours<-c("#d95f02","#1b9e77")
barplot(as.numeric(ttt[2:3,]),col=colours,xlab="Months (2015)",ylab="ET (mm)",width=2,beside=TRUE,axes=TRUE,ylim=range(0,3.2),space=c(0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0))
legend(1,2.8, legend=c("Observed ET at WBS","Simulated ET for WBS"), fill =c("#d95f02","#1b9e77"),cex=0.7, xjust=0,x.intersp=0.1, pt.cex=1,y.intersp=1.1, bty="n")

#plot(test,type="l",ylab=var_name,xlab="2015",col="green3", xaxt="n",ylim= range(0,2.2))
axis(side=1,at=seq(4, 99, 8), labels =as.character(colnames(ttt)), tck = -0.01, col.ticks = "black")


#plotname1 <- paste0("monthly_ET_LOW_",var,".png")
#dev.copy(png, filename=plotname1)
dev.off()


