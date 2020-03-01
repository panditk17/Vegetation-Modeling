setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))
vvv=expression(paste("GPP (KgCm"^"-2",")"))


m_gpp_site1<-read.csv('gpp_series_site2_modis.csv')
s_modis<-m_gpp_site1[128:863,]


params<-matrix(c(0.89,2.3,3,0.34,959,0.7,2.82,3.8,0.42,2164,0.74,2.73,5,0.12,577,1.34,1.67,
                 4.3,0.28,244,0.84,1.70,5,0.37,1698,0.88,1.75,3.3, 0.38,1601,0.84,1.95,4.8,
                 0.13,231,1.35,1.74,4.2,0.4,2024,1.46,1.89,4.6,0.17,542,1.05,2.83,3.8,0.5,
                 1823),nrow=10,byrow =TRUE)

all_sims<-matrix(ncol=0,nrow=736)


for (uuu in seq(1,10,1)) {
  par1<-params[uuu,]
  par1<-params[uuu,]
  p1<-par1[1]
  p1<-sprintf("%.2f",p1)
  p2<-par1[2]
  p3<-par1[3]
  #p3<-sprintf("%.1f",p3)
  p4<-par1[4]
  #p4<- options(p4,digits=2)
  p4<-sprintf("%.2f",p4)
  p5<-par1[5]
  

  filename<-paste0("c:/karun_documents/juniper/ED_out_best/val2_",p1,p2,p3,p4,p5,"/daily_gpp_co1969_2019.csv")
  
  
  best1<-read.csv(filename)
  
  
  sh_best1<-best1[12411:18250,]
  library(berryFunctions)
  
  sh_best1a<-insertRows(sh_best1, 152, new = 0, rcurrent = FALSE)
  sh_best1a[152,8] = 2004
  sh_best1a[152,9] = 2
  sh_best1a[152,10] = 29
  
  sh_best1a<-insertRows(sh_best1a, 1613, new = 0, rcurrent = FALSE)
  sh_best1a[1613,8] = 2008
  sh_best1a[1613,9] = 2
  sh_best1a[1613,10] = 29
  
  sh_best1a<-insertRows(sh_best1a, 3074, new = 0, rcurrent = FALSE)
  sh_best1a[3074,8] = 2012
  sh_best1a[3074,9] = 2
  sh_best1a[3074,10] = 29
  
  
  sh_best1a<-insertRows(sh_best1a, 4535, new = 0, rcurrent = FALSE)
  sh_best1a[4535,8] = 2016
  sh_best1a[4535,9] = 2
  sh_best1a[4535,10] = 29
  
  
  yearly_data=matrix(NA,nrow=0,ncol=2)
  
  
  for ( yryr in seq(2003,2019,1)) {
    shbest6 <- sh_best1a[which(sh_best1a[,8]==yryr),]
    
    
    ttt<-nrow(shbest6)
    ppp<-floor(ttt/8)*8
    qqq<-ppp+1
    
    shbest6a<-shbest6[1:ppp,]
    shbest6b<-shbest6[qqq:ttt,]
    
    abc6_1<-sum(shbest6b[,6])
    abc6_aa<-c(yryr,abc6_1)
    
    aaa6<- as.numeric(as.character(shbest6a[,6]))
    bbb6<- gl(ppp,8,ppp)
    abc6_2<-aggregate(aaa6~bbb6, FUN=sum)
    abc6_2<-abc6_2[,2]
    
    
    fff<-length(abc6_2)
    yyy<-rep(yryr,fff)
    
    
    abc6_bb<-cbind(yyy,abc6_2)
    
    shbest6<-rbind(abc6_bb,abc6_aa)
    
    yearly_data<-rbind(yearly_data,shbest6)
  }
  
  
  
  modis_data<-s_modis[,2]*0.0001
  ed_data <-yearly_data[2:737,2]/365
  head<-paste0(p1,p2,p3,p4,p5)
  #colnames(ed_data)<-c("yr",head)
  
  xlxl<-as.character(s_modis[,1])
  datadata<-cbind(xlxl,ed_data)
  colnames(datadata)<-c("date",head)
  
  all_sims<-cbind(datadata[,2],all_sims)
  
}

sims_gpp_modis<-cbind(xlxl,modis_data,all_sims)

write.csv(sims_gpp_modis,"allsims_modis_site2.csv")

fileout=paste0("mod_ed_gpp_",p1,p2,p3,p4,p5,".csv")
write.csv(datadata,fileout)

MODIS_gpp<-sims_gpp_modis[1:736,2]
ED_gpp<-sims_gpp_modis[1:736,5]

plot(ED_gpp,MODIS_gpp,pch=16)


plotname1 <- paste0("daily_gpp_site2.png")

png(plotname1,res = 300,width =8,height=6,units='in')


par(mfrow = c(1, 1))
par(cex = 0.6)
par(mar = c(4, 4, 2.5, 0.5), oma = c(4, 3, 0.2, 0.3))
#par(mar = c(5,0,0,0), oma = c(6, 2.5, 3, 0.3))
par(tcl = -0.25)
par(mgp = c(1.5, 0.35, 0))

coloth<-"lightgray"
plot(sims_gpp_modis[,4],type="l",ylab=vvv,xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1),cex.axis=1.4,cex.lab=1.6)
#par(new=TRUE)
xvals<-seq(0,736,25)
yvals<-seq(0,0.1,0.02)
#abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=seq(23,765,46), cex.axis=1.5, labels = c(seq(2004,2020,1)), cex.lab=2, tck = 0.02, col.ticks = "black")

#par
lines(sims_gpp_modis[,5], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[,6], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
#par
lines(sims_gpp_modis[,8], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[,9], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[,10], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[11], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[,12], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[,3], type="l",ylab="", lwd=1.9,xlab="Year",col=coloth, xaxt="n",ylim= range(0,0.1))
#par
lines(sims_gpp_modis[,8], type="l",ylab="", xlab="Year",col="green3", xaxt="n",ylim= range(0,0.1))

lines(sims_gpp_modis[,2], type="l",ylab="", lwd=1.9,xlab="Year",col="red2", xaxt="n",ylim= range(0,0.1))


legend(x="topright", ncol=1,legend=c("Lowest RMSE", "MODIS","selected simulations"),
       col=c("green3","red2","gray"), lty=1,lwd=3,cex=1.4)

mtext("ED2 vs MODIS GPP (Site 2) ", side = 3, line = -2, cex = 1.1)
mtext("8-days accumulated ", side = 3, line = -4, cex = 0.9)

dev.off()
