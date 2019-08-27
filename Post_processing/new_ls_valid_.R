# Codes to read cohort level outputs, patch level outputs and polygon level outputs
# and calculate polygon level outputs from cohort outputs over time
# Karun Pandit

setwd('/home/karunpandit/best_l1') # Define working directory

# remove previous files
rm(list=ls()) 

# install necessary packages
library(rhdf5)
#library(ncdf4)

styr <- 2015
endyr <- 2016
stmn <- 1
endmn <- 12

var = "DMEAN_GPP_PY"
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
      
      
      fileyy<- -sum(fileyyy)
      
      yr <- year
      cmm1 = sprintf("%02d",cmm)
      date1 <- paste0(yr,cmm1)
      date2 <- yr
      date3<- paste0(yr,"-",cmm1,"-",cddd)
      abab<- cbind(fileyyy,date1,date2,date3)
      abc_1 <- rbind(abc_1,abab)
      
    }
  }
}

simtot1<-as.numeric(abc_1[,1])
month1<-as.numeric(abc_1[,2])

testdata<-read.csv(file="/home/karunpandit/GPP_2015_RCEW.csv")
test<- testdata[,9]/1000*365
month3<- as.character(testdata[,3])
test_av <-aggregate(test~month3,FUN=mean)


testdata1<-read.csv(file="/home/karunpandit/GPP_2017_RCEW.csv")
test1<- testdata1[,14]/1000*365
month4<- as.character(testdata1[,4])
test_av1<-aggregate(test1~month4,FUN=mean)

test_av1a<-test_av1[1,]
test_av1b<-test_av1[2:4 ,]
test_av1c<-test_av1[5:12,]
test_av_1n<-rbind(test_av1b,test_av1a,test_av1c)

#month1a<-month1[1:71]
#month1b<-month1[141:365]
#submonth1<-append(month1a,month1b)

abc_2 <-aggregate(simtot1~month1,FUN=mean)
write.csv(abc_1,file="yeardata")


test_avsub1<-test_av[1:3,]
test_avsub2<-matrix(c(1,"NA"),nrow=1,ncol=2)
test_avsub2<-as.numeric(test_avsub2)
test_avsub3<-test_av[4:11,]
test_avsub<-rbind(test_avsub1,test_avsub2,test_avsub3)


all2<-cbind(simtot1,test,test1,month1)


library(ggplot2)
library(reshape2)

mall<-cbind(abc_2,test_avsub[,2],test_av_1n[,2])


ttt<-t(mall)


rownames(ttt)<-c("months","one","two","three")
#colnames(ttt)<-c("Oct","Nov","Dec","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep")
colnames(ttt)<-c("O","N","D","J","F","M","A","M","J","J","A","S")
var_name=expression(paste("GPP (KgC/m"^"2","/yr)"))

dev.new()
plotname1 <- paste0("validation_monthly_ls_new",var,".png")

png(plotname1,res = 300,width =6,height=4,units='in')

par(mar=c(4,7,1,2))
colours<-c("#d95f02","#1b9e77","#7570b3")
barplot(as.numeric(ttt[2:4,]),col=colours,xlab="Months",ylab=var_name,width=2,beside=TRUE,axes=TRUE,ylim=range(0,2.2),space=c(0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1,0,0))
legend(0,2, legend=c("Observation at LS in 2015","Observation at LS in 2017","Simulation with best parameters for LS"), fill =c("#1b9e77","#7570b3", "#d95f02"),cex=0.65, xjust=0,x.intersp=0.1, pt.cex=1,y.intersp=1.1, bty="n")

#plot(test,type="l",ylab=var_name,xlab="2015",col="green3", xaxt="n",ylim= range(0,2.2))
axis(side=1,at=seq(4, 99, 8), labels =as.character(colnames(ttt)), tck = -0.01, col.ticks = "black")

text(330,1.8,"RMSE for 2015 = ")
dev.off()

