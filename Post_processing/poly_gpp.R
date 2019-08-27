# Codes to read cohort level outputs, patch level outputs and polygon level outputs
# and calculate polygon level outputs from cohort outputs over time
# Karun Pandit
# remove previous files
rm(list=ls()) 

# install necessary packages
library(rhdf5)
#      library(ncdf4)

# ........................

path<- '/home/karunpandit/ls_fold123'
#path<- '/home/karunpandit/new_best_sims/best_l1'

setwd(path)
#setwd('/home/karunpandit/new_sens/rt01')

styr <- 2014
endyr <- 2016
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
bcd_3<-aggregate(aaaa~bbbb, FUN=sum)


