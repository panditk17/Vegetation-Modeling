# Codes to read cohort level outputs, patch level outputs and polygon level outputs
# and calculate polygon level outputs from cohort outputs over time
# Karun Pandit
# last updated Feb 2019

setwd('/home/karunpandit/wbs_long_e')

# remove previous files
rm(list=ls()) 


# install necessary packages
library(rhdf5)
#      library(ncdf4)




styr <- 2015
endyr <- 2016
stmn <- 1
endmn <- 12

var = "DMEAN_GPP_PY"
var_name = "GPP (KgC/m^2/yr)"
vvv=expression(paste("GPP (KgC/m"^"2","/yr)"))
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
      
      fileyy <- h5read(filexx,var)
      
      
      
      ddd1<- dim(fileyy)
      
      #yr <- matrix(0,ddd1)
      
      
      
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




aaa<- as.numeric(as.character(abc_1[,1]))
nnn<- length(aaa)
bbb<- gl(nnn,365,nnn)
abc_2<-aggregate(aaa~bbb, FUN=mean)


# ........................

testdata<-read.csv("/home/karunpandit/GPP_2015_RCEW.csv")
test_15<-testdata[,8]/1000*365
meantest15<-mean(test_15)


testdata17<-read.csv("/home/karunpandit/GPP_2017_RCEW.csv")
test_17<-testdata17[,13]/1000*365
meantest17<-mean(test_17)
vvv=expression(paste("GPP (KgC/m"^"2","/yr)"))


#par(mar=c(5.1,5.1,4.1,1.1)) # margin in lines bottom, left, top , right
#par(mai=c(1.02,0.82,0.82,0.42))
graphics.off()
par("mar")
#par(mar=c(2,2,1,0.2))
plotname1 <- paste0("comp_daily1",var,".png")

png(plotname1,res = 300,width =6,height=4,units='in')

par(mar=c(4,7,1,2))

plot(abc_1[,1],type="l",ylab=vvv,xlab="Days (2016)",col="#d95f02", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,2.4))

axis(side=1,at=seq(1, 365, 50), labels = F, tck = -0.02, col.ticks = "black")
axis(side=1,at=seq(0, 365,50), labels = c(seq(0,365,50)), cex.axis=1.1, tck = -0.02, col.ticks = "black")
par(xpd=FALSE)
abline(h=0, col="black", lty=2)

par(new=TRUE)
plot(test_15,type="l",ylab=vvv,xlab="",col="#1b9e77", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,2.4))


par(new=TRUE)
plot(test_17,type="l",ylab=vvv,xlab="",col="#7570b3", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,2.4))

par(xpd=FALSE)
#legend(1,1,c("SLA"), cex=1.8, text.font=1.5,xjust=-0.1, bty="n")

#legend("topright", legend=c("Max SLA = 15","Min SLA=2","Initial Params"), horiz=TRUE,pt.cex=0.2, lty= 1, lwd=c(1.5,1.5,1.5), col=c("#1b9e77","#7570b3", "#d95f02"), bty="n", text.font=2,x.intersp=0.8,y.intersp=0.3,xjust=0, text.width=0.01)
#legend("topright", legend=c("Max fineroot turnover","Min fineroot turnover","Initial fineroot turnover"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")
#legend("topright", legend=c("Max SLA","Min SLA","Initial SLA"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")


#legend("topright", legend=c(expression(paste("Max V"["m0"])),expression(paste("Min V"["m0"])),expression(paste("Initial V"["m0"]))), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")


legend("topleft", legend=c("Observation at WBS in 2015","Observation at WBS in 2017","Simulation with best parameters for WBS"), cex=0.7, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")
#legend("topright", legend=c("Max Q ratio","Min Q ratio","Initial Q ratio"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")

#legend("topright", legend=c("Max SLA","Min SLA","Initial SLA"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")
text(40,1.8,"RMSE (2015)  = 0.21",cex=0.7, adj=0)
text(40,1.67,"NSE (2015)  = 0.29", cex=0.7, adj=0)
text(40,1.54,"RMSE (2017)  = 0.35", cex=0.7,adj=0)
text(40,1.41,"NSE (2017)  = 0.32", cex=0.7,adj=0)

dev.off()


