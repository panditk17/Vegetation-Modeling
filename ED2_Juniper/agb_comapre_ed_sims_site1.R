## codes to compare agb oiutputs from the model output
setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))
vvv=expression(paste("AGB (KgCm"^"-2",")"))


params<-matrix(c(0.89,2.3,3,0.34,959,0.7,2.82,3.8,0.42,2164,0.74,2.73,5,0.12,577,1.34,1.67,
                 4.3,0.28,244,0.84,1.70,5,0.37,1698,0.88,1.75,3.3, 0.38,1601,0.84,1.95,4.8,
                 0.13,231,1.35,1.74,4.2,0.4,2024,1.46,1.89,4.6,0.17,542,1.05,2.83,3.8,0.5,
                 1823),nrow=10,byrow =TRUE)


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
  
  
  filename<-paste0("c:/karun_documents/juniper/ED_out_best/val2_",p1,p2,p3,p4,p5,"/annual_agb_co_1969_2019.csv")
 
  
  all_sims<-matrix(ncol=0,nrow=16)
  
 
  best1<-read.csv(filename)
  ed2_data<-best1[35:50,4]
  ed2_data<-t(ed2_data)
  yryr<-c(2004:2019)
  ed_out<-rbind(yryr,ed2_data)
  ed_out<-t(ed_out)
  head<-paste0(p1,p2,p3,p4,p5)
  colnames(ed_out)<-c("year",head)
  
  
  
  #ed_out<-rbind(yryr,ed2_data)
  #ed_out<-t(ed_out)
  all_sims<-cbind(all_sims,ed_out)
  
}


write.csv(all_sims,"allsims_agb_annualsite2.csv")

graphics.off()
plotname1 <- paste0("AGB_annual_comp_site2.png")

png(plotname1,res = 300,width =8,height=6,units='in')


par(mfrow = c(1, 1))
par(cex = 0.6)
par(mar = c(4, 4, 2.5, 0.5), oma = c(4, 3, 0.2, 0.3))
#par(mar = c(5,0,0,0), oma = c(6, 2.5, 3, 0.3))
par(tcl = -0.25)
par(mgp = c(1.5, 0.35, 0))

upup<-1.6
lll<-0
coloth<-"cadetblue2"
colrf<-"darkgoldenrod2"
plot(all_sims[,4],type="l",ylab=vvv,xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup),cex.axis=1.5,cex.lab=2)
#par(new=TRUE)
axis(side=1,at=seq(1,16,2), cex.axis=1.5, labels = c(seq(2004,2019,2)), cex.lab=2, tck = 0.02, col.ticks = "black")


xvals<-seq(1,16,1)
yvals<-seq(0,2,0.2)
abline(v=xvals,col="lightgray",lty=3)
abline(v=12.5,col="gray3",lty=3,lwd=2)
#par
lines(all_sims[,6], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,8], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,10], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,12], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,14], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,16], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[18], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,20], type="l",ylab="", xlab="Year",col=coloth, xaxt="n",ylim= range(lll,upup))
#par
lines(all_sims[,2], type="l",ylab="", lwd=2,xlab="Year",col="steelblue2", xaxt="n",ylim= range(lll,upup))
#par



legend(x="topleft", ncol=1,legend=c("EDv2.2 GPP", "RF GPP","MODIS gpp"),
       col=c("steelblue2","darkgoldenrod2","green3"), lty=1,lwd=3,cex=1.4)

mtext("Annual GPP (Site 1)", side = 3, line = -2, cex = 1.1)
mtext("Calibration", side = 3, line = -10, adj=0.5,cex = 1)
mtext("Validation", side = 3, line = -10, adj=0.9, cex = 1)
#mtext(text="LS",side=3,line=0,at=c(1,1),adj=8, outer=TRUE,cex=1.4)

dev.off()
