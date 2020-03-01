setwd('c:/Karun_documents/juniper')
rm(list=ls(all.names=TRUE))
vvv=expression(paste("AGB (KgCm"^"-2",")"))

params<-matrix(c(0.31,2.34,9.7,0.18,9704,0.39,2.45,9,0.52,8228,0.44,2.56,7.3,0.13,8209,
                 0.52,0.19,6.8,0.18,9285,0.13,2.03,6.2,0.37,9230,0.52,2.84,5.8,0.35,7600,
                 0.42,1.67,8.2,0.30,8942,0.38,2.86,7.3,0.46,8250,0.13,1.43,8.9,0.12,8398,
                 0.28,1.62,8.2,0.56,9009),nrow=10,byrow =TRUE)

all_sims<-matrix(ncol=0,nrow=16)

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
  
  
  filename<-paste0("c:/karun_documents/juniper/ED_out_best/val_",p1,p2,p3,p4,p5,"/annual_agb_co_1969_2019.csv")
  
  
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


write.csv(all_sims,"allsims_agb_annualsite1.csv")

graphics.off()
plotname1 <- paste0("AGB_annual_comp_site1.png")

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
