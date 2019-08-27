# Codes to read cohort level outputs, patch level outputs and polygon level outputs
# and calculate polygon level outputs from cohort outputs over time
# Karun Pandit

    path1<-"/home/karunpandit/ls_sens_a/def"
    path2<-'/home/karunpandit/sla12'
    path3<-'/home/karunpandit/sla2'
    
    setwd(path1)
    
      # remove previous files
      rm(list=ls()) 
      
      
      # install necessary packages
      library(rhdf5)
#      library(ncdf4)
      
      
      
      
      styr <- 2012
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
      
      setwd(path2)
      
      rm(list=ls() [!ls() %in% c("abc_1","abc_2","styr","endyr","path3")]) 
      
      #styr <- 2001
      #endyr <- 2009
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
  
cden<-data.frame(cde_2)    

cde_a<-cden[1,2]

bcdn<-data.frame(bcd_2)
bcd_a<-bcdn[1,2]

diff<-bcd_a-cde_a

div<-max(bcd_a,cde_a)

si<-diff/div
      
      dev.new()
      #par(mfrow=c(1,1))
     plot(abc_1[,1],type="l",ylab=var_name,xlab="Year",col="#d95f02", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,1))
      
      axis(side=1,at=seq(1, 2921, 365), labels = F, tck = 0.015, col.ticks = "black")
      axis(side=1,at=seq(182.5, 2920, 365), labels = c(1:8), cex.axis=1.3, tck = -0.005, col.ticks = "black")
      #axis(side=1,at=seq(1, 2191, 365), labels = c("JULY","JULY","JULY","JULY","JULY","JULY","JULY"), tck = -0.04, col.ticks = "black")
      abline(h=0, col="black", lty=2)
      
      par(new=TRUE)
      plot(bcd_1[,1],type="l",ylab=var_name,xlab="Year",col="#1b9e77", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,1))
      
      #plot(bcd_1[,1],type="l",ylab="",xlab="",col="blue3", xaxt="n",ylim=range(0,1))
      
   par(new=TRUE)
   plot(cde_1[,1],type="l",ylab=var_name,xlab="Year",col="#7570b3", xaxt="n",cex.lab=1.4,cex.axis=1.3,ylim= range(0,1))
   
     # plot(cde_1[,1],type="l",ylab="",xlab="",col="green4", xaxt="n",ylim= range(0,1))

      legend(500,1,c("SLA"), cex=1.8, text.font=1.5,xjust=-0.1, bty="n")
       
      #legend(20,1.2, c("sla = 15","stomatal slope (2)","stomatal slope(15)"), lty= 1, lwd=c(1.5,1.5,1.5), cex=.9, col=c("red","blue3","green4"),bty="n", text.font=2,x.intersp=2, adj=0.2,xjust=0.1, text.width=NULL)
      
      plotname1 <- paste0("comp_daily1",var,".png")
      dev.copy(png, filename=plotname1)
      dev.off()
      
      dev.new()
      plot(abc_2[,2],type="l",col="red",xaxt="n", ylab="",xlab="", ylim = range(0,2))
      axis(side=1,at=seq(1, 8, 1), labels = c(2001:2008), tck = -0.03, col.ticks = "black")
      #axis(side=1,at=seq(1, 2191, 365), labels = c("JULY","JULY","JULY","JULY","JULY","JULY","JULY"), tck = -0.04, col.ticks = "black")
      abline(h=0, col="black", lty=2)
      
      par(new=TRUE)
      
      plot(bcd_2[,2],type="l",col="blue3",xaxt="n", ylab="",xlab="", ylim = range(0,2))
       par(new=TRUE)

      plot(cde_2[,2],type="l",col="green4",xaxt="n", ylab="",xlab="", ylim = range(0,2))

           
      legend(1,2, c("stomatal slope(7)","stomatal slope (2)","stomatal slope (15)"), lty= 1, lwd=c(1.5,1.5),1.5, cex=.9, col=c("red","blue3","green4"),bty="n", text.font=2,x.intersp=1, adj=0.2,xjust=0.1, text.width=NULL)
      
      
      plotname2 <- paste0("comp__annual1",var,".png")
      dev.copy(png, filename=plotname2)
     

dev.off() 

