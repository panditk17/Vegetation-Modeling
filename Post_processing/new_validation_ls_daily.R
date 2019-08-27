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
var_name = "GPP (KgC/m2/yr)"

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
      
      fileyy<- sum(fileyyy)
      
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



sim_best<-as.numeric(abc_1[,1])

testdata<-read.csv(file="/home/karunpandit/GPP_2015_RCEW.csv")

test<- testdata[,9]/1000*365


testdata1<-read.csv(file="/home/karunpandit/GPP_2017_RCEW.csv")

test1<- testdata1[,13]/1000*365


#remove NA data from test and simulated

subsim_best_a<-sim_best[1:71]
subsim_best_b<-sim_best[141:365]
subsim_best<-append(subsim_best_a,subsim_best_b)
sdsimsub_best<-sd(subsim_best)
meansimsub_best<-mean(subsim_best)


subtest_a<-test[1:71]
subtest_b<-test[141:365]
subtest<- append(subtest_a,subtest_b)
sdtestsub<-sd(subtest)
meantestsub<-mean(subtest)


code="#7570b3"
#code = "darkslateblue"
#code1 = "green4"
code1 = "#1b9e77"
code2 = "#d95f02"
#code2="firebrick3"


var_name=expression(paste("GPP (KgC/m"^"2","/yr)"))


graphics.off()
par("mar")
#par(mar=c(2,2,1,0.2))
plotname1 <- paste0("validation_ls_new",var,".png")

png(plotname1,res = 300,width =6,height=4,units='in')

par(mar=c(4,7,1,2))


plot(test,type="l",col=code1,xaxt="n", lwd=1.15,ylab=var_name,xlab="Days", ylim = range(0,2.2))

axis(side=1,at=seq(0, 365, 50), labels = c(seq(0,365,50)), tck = -0.03, col.ticks = "black")

abline(h=0, col="black", lty=2)

par(new=TRUE)

plot(test1,type="l",col=code,lwd=1.15, xaxt="n", ylab="",xlab="", ylim = range(0,2.2))

par(new=TRUE)
plot(abc_1[,1],type="l",col=code2, lwd=1.15, ylab="",xlab="",xaxt="n",ylim= range(0,2.2))

legend(-10,2.3, legend=c("Observation at LS in 2015","Observation at LS in 2017","Simulation with best parameters for LS"), cex=0.65, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1.1, bty="n")



dev.off()

