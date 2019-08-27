# Codes to read cohort level outputs, patch level outputs and polygon level outputs
# and calculate polygon level outputs from cohort outputs over time
# Karun Pandit
# remove previous files
rm(list=ls()) 

# install necessary packages
library(rhdf5)
#      library(ncdf4)

# ........................

path1<- '/home/karunpandit/ls_sens_a/def'
path2<- '/home/karunpandit/ls_sens_a/lt_2'
path3<- '/home/karunpandit/ls_sens_a/lt_01'

setwd(path1)

styr <- 2001
endyr <- 2016
stmn <- 1
endmn <- 12

var = "DMEAN_GPP_PY"
#var_name = "NEP (KgC/m2/yr)"


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


setwd(path2)
#setwd('/home/karunpandit/new_sens/rt01')

rm(list=ls() [!ls() %in% c("abc_1","abc_2","styr","endyr","path3")])


stmn <- 1
endmn <- 12

var = "DMEAN_GPP_PY"
var_name = "NEP (KgC/m2/yr)"


bcd_1<-matrix(nrow=0,ncol=4)


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
      
      
      
      bcd_1 <- rbind(bcd_1,abab)
      
      
    }
  }
}




aaaa<- as.numeric(as.character(bcd_1[,1]))
nnnn<- length(aaaa)
bbbb<- gl(nnnn,365,nnnn)
bcd_2<-aggregate(aaaa~bbbb, FUN=mean)

#********************************************************************************

setwd(path3)
#setwd('/home/karunpandit/new_sens/rt2')


rm(list=ls() [!ls() %in% c("abc_1","abc_2","bcd_1","bcd_2","styr","endyr")])

#styr <- 2001
#endyr <- 2009
stmn <- 1
endmn <- 12

var = "DMEAN_GPP_PY"
var_name = "NEP (KgC/m2/yr)"


cde_1<-matrix(nrow=0,ncol=4)


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
      
      
      
      cde_1 <- rbind(cde_1,abab)
      
      
    }
  }
}

aa<- as.numeric(as.character(cde_1[,1]))
nn<- length(aa)
bb<- gl(nn,365,nn)
cde_2<-aggregate(aa~bb, FUN=mean)



bcdcol<-as.numeric(bcd_1[,1])
bcd_mean<-mean(bcdcol)

cdecol<-as.numeric(cde_1[,1])
cde_mean<-mean(cdecol)


diff<-bcd_mean-cde_mean
div<-max(bcd_mean,cde_mean)

si<-diff/div

maxmax<-as.numeric(bcd_1[,1])
minmin<-as.numeric(cde_1[,1])
mn_max<-mean(maxmax)
mn_min<-mean(minmin)
diff_new<- mn_max-mn_min
div_new<-max(mn_max,mn_min)
si_new <- diff_new/div_new

max_a<-as.numeric(bcd_2[15,2])
min_a<-as.numeric(cde_2[15,2])
diff_a<-max_a-min_a
div_a<- max(max_a,min_a)
si_a<-diff_a/div_a

si_all<-cbind(si,si_new,si_a)
write.csv(si_a,file="si_all_out")

vvv=expression(paste("GPP (KgC/m"^"2","/yr)"))

graphics.off()
par("mar")
#par(mar=c(2,2,1,0.2))
plotname1 <- paste0("sianalysuis_initial",var,".png")

png(plotname1,res = 300,width =6,height=4,units='in')

par(mar=c(4,7,1,2))

plot(abc_1[,1],type="l",ylab=vvv,xlab="Year",col="#d95f02", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,1.4))

axis(side=1,at=seq(1, 5476, 365), labels = F, tck = 0.015, col.ticks = "black")
axis(side=1,at=seq(182.5, 5476, 365), labels = c(1:15), cex.axis=1.3, tck = -0.005, col.ticks = "black")
par(xpd=FALSE)
abline(h=0, col="black", lty=2)

#par(new=TRUE)
#plot(bcd_1[,1],type="l",ylab="",xlab="Year",col="#1b9e77", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,1.4))


#par(new=TRUE)
#plot(cde_1[,1],type="l",ylab="",xlab="Year",col="#7570b3", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,1.4))

par(xpd=FALSE)
#legend(1,1,c("SLA"), cex=1.8, text.font=1.5,xjust=-0.1, bty="n")

#legend("topright", legend=c("Max SLA = 15","Min SLA=2","Initial Params"), horiz=TRUE,pt.cex=0.2, lty= 1, lwd=c(1.5,1.5,1.5), col=c("#1b9e77","#7570b3", "#d95f02"), bty="n", text.font=2,x.intersp=0.8,y.intersp=0.3,xjust=0, text.width=0.01)
#legend("topright", legend=c("Max fineroot turnover","Min fineroot turnover","Initial fineroot turnover"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")
#legend("topright", legend=c("Max SLA","Min SLA","Initial SLA"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")
legend("topright", legend=c("Simulation from initial parameters"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")


#legend("topright", legend=c(expression(paste("Max V"["m0"])),expression(paste("Min V"["m0"])),expression(paste("Initial V"["m0"]))), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")


#legend("topright", legend=c("Max stomatal slope","Min stomatal slope","Initial stomatal slope"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")
#legend("topright", legend=c("Max Q ratio","Min Q ratio","Initial Q ratio"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")

#legend("topright", legend=c("Max SLA","Min SLA","Initial SLA"), cex=0.8, xjust=0,lty=1, lwd=c(1.8,1.8,1.8), col=c("#1b9e77","#7570b3", "#d95f02"),x.intersp=0.1, pt.cex=1,y.intersp=1, bty="n")

dev.off()

