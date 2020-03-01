setwd('C:/Karun_documents/juniper/outputs_point_juniper')
rm(list=ls(all.names=TRUE))
vvv=expression(paste("GPP (kgCm"^"-2","yr"^"-1",")"))
#vvv=expression(paste("kgC/m"^"2","/yr"))


s1gd<-read.csv('C:/Karun_documents/juniper/outputs_point_juniper/out_def/annual_gpp_co1901_2020.csv')
s1gd[,8]<- s1gd[,3]+s1gd[,4] + s1gd[,6]

s1ga<-read.csv('C:/Karun_documents/juniper/outputs_point_juniper/out_allom/annual_gpp_co1901_2020.csv')
s1ga[,8]<- s1ga[,3]+s1ga[,4] + s1ga[,6]

s1gap<-read.csv('C:/Karun_documents/juniper/outputs_point_juniper/out_allompar/annual_gpp_co1901_2020.csv')
s1gap[,8]<- s1gap[,3]+s1gap[,4] + s1gap[,6]


s2gd<-read.csv('C:/Karun_documents/juniper/outputs_point_juniper/twopft6def/annual_gpp_co1901_2020.csv')
s2gd[,8]<- s2gd[,3]+s2gd[,4] + s2gd[,6]

s2ga<-read.csv('C:/Karun_documents/juniper/outputs_point_juniper/twopft6allom/annual_gpp_co1901_2020.csv')
s2ga[,8]<- s2ga[,3]+s2ga[,4] + s2ga[,6]

s2gap<-read.csv('C:/Karun_documents/juniper/outputs_point_juniper/twopft6allompar/annual_gpp_co1901_2020.csv')
s2gap[,8]<- s2gap[,3]+s2gap[,4] + s2gap[,6]



graphics.off()
plotname1 <- paste0("GPP_all_annual.png")

png(plotname1,res = 300,width =10.5, height=7,units='in')

ylts<-c(0,1.35)

par(mfrow = c(2, 3))
par(cex = 0.6)
par(mar = c(2.7, 4, 1, 1), oma = c(6, 3, 3, 0.3))
#par(mar = c(5,0,0,0), oma = c(6, 2.5, 3, 0.3))
par(tcl = -0.25)
par(mgp = c(1.5, 0.35, 0))

juncol="green3"
shcol="blue3"
grcol="orange3"
totcol="darkgreen"



plot1<- plot(x=s2gd[,2],y = s1gd[,4], type="l",xaxt="n",yaxt="n",xlab="year",
             ylab=vvv,cex.lab=1.6,ylim=ylts,col=juncol)
#par(new=TRUE)
xvals<-seq(0,120,20)
yvals<-seq(0,1.5,0.25)
abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=xvals, cex.axis=1.5, labels = xvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")
axis(side=2,at=yvals, cex.axis=1.5, labels = yvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")

#par(xpd=FALSE)
abline(h=0, col="black", lty=2)
#abline(v=0, col="black", lty=2)

#mtext("C3 grass GPP", side = 3, line = -2, cex = 1.2)
lines(s1gd[,3],type="l",ylab=vvv,xlab="Year",col=grcol, xaxt="n",ylim= ylts)
#par(new=TRUE)
lines(s1gd[,6],type="l",ylab=vvv,xlab="Year",col=shcol, xaxt="n",ylim= ylts)
#lines(s1gd[,8],type="l",ylab=vvv,xlab="Year",col=totcol, xaxt="n",ylim= ylts)


plot2<- plot(x=s1ga[,2],y = s1ga[,4], type="l",xaxt="n",yaxt="n",xlab="year",
             ylab=vvv,cex.lab=1.6,ylim=ylts,col=juncol)
#par(new=TRUE)
xvals<-seq(0,120,20)
yvals<-seq(0,1.5,0.25)
abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=xvals, cex.axis=1.5, labels = xvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")
axis(side=2,at=yvals, cex.axis=1.5, labels = yvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")

#par(xpd=FALSE)
abline(h=0, col="black", lty=2)
#abline(v=0, col="black", lty=2)

#mtext("C3 grass GPP", side = 3, line = -2, cex = 1.2)
lines(s1ga[,3],type="l",ylab=vvv,xlab="Year",col=grcol, xaxt="n",ylim= ylts)
#par(new=TRUE)
lines(s1ga[,6],type="l",ylab=vvv,xlab="Year",col=shcol, xaxt="n",ylim= ylts)
#lines(s1ga[,8],type="l",ylab=vvv,xlab="Year",col="green2", xaxt="n",ylim= ylts)




plot3<- plot(x=s1gap[,2],y = s1gap[,4], type="l",xaxt="n",yaxt="n",xlab="year",
             ylab=vvv,cex.lab=1.6,ylim=ylts,col=juncol)
#par(new=TRUE)
xvals<-seq(0,120,20)
yvals<-seq(0,1.5,0.25)
abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=xvals, cex.axis=1.5, labels = xvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")
axis(side=2,at=yvals, cex.axis=1.5, labels = yvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")

#par(xpd=FALSE)
abline(h=0, col="black", lty=2)
#abline(v=0, col="black", lty=2)

#mtext("C3 grass GPP", side = 3, line = -2, cex = 1.2)
lines(s1gap[,3],type="l",ylab=vvv,xlab="Year",col=grcol, xaxt="n",ylim= ylts)
#par(new=TRUE)
lines(s1gap[,6],type="l",ylab=vvv,xlab="Year",col=shcol, xaxt="n",ylim= ylts)
#lines(s1ga[,8],type="l",ylab=vvv,xlab="Year",col="green2", xaxt="n",ylim= ylts)




plot4<- plot(x=s2gd[,2],y = s2gd[,4], type="l",xaxt="n",yaxt="n",xlab="year",
             ylab=vvv,cex.lab=1.6,ylim=ylts,col=juncol)
#par(new=TRUE)
xvals<-seq(0,120,20)
yvals<-seq(0,1.5,0.25)
abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=xvals, cex.axis=1.5, labels = xvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")
axis(side=2,at=yvals, cex.axis=1.5, labels = yvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")

#par(xpd=FALSE)
abline(h=0, col="black", lty=2)
#abline(v=0, col="black", lty=2)

#mtext("C3 grass GPP", side = 3, line = -2, cex = 1.2)
lines(s2gd[,3],type="l",ylab=vvv,xlab="Year",col=grcol, xaxt="n",ylim= ylts)
#par(new=TRUE)
lines(s2gd[,6],type="l",ylab=vvv,xlab="Year",col=shcol, xaxt="n",ylim= ylts)
#lines(s2gd[,8],type="l",ylab=vvv,xlab="Year",col=totcol, xaxt="n",ylim= ylts)


plot2<- plot(x=s2ga[,2],y = s2ga[,4], type="l",xaxt="n",yaxt="n",xlab="year",
             ylab=vvv,cex.lab=1.6,ylim=ylts,col=juncol)
#par(new=TRUE)
xvals<-seq(0,120,20)
yvals<-seq(0,1.5,0.25)
abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=xvals, cex.axis=1.5, labels = xvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")
axis(side=2,at=yvals, cex.axis=1.5, labels = yvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")

#par(xpd=FALSE)
abline(h=0, col="black", lty=2)
#abline(v=0, col="black", lty=2)

#mtext("C3 grass GPP", side = 3, line = -2, cex = 1.2)
lines(s2ga[,3],type="l",ylab=vvv,xlab="Year",col=grcol, xaxt="n",ylim= ylts)
#par(new=TRUE)
lines(s2ga[,6],type="l",ylab=vvv,xlab="Year",col=shcol, xaxt="n",ylim= ylts)
#lines(s2ga[,8],type="l",ylab=vvv,xlab="Year",col="green2", xaxt="n",ylim= ylts)




plot3<- plot(x=s2gap[,2],y = s2gap[,4], type="l",xaxt="n",yaxt="n",xlab="year",
             ylab=vvv,cex.lab=1.6,ylim=ylts,col=juncol)
#par(new=TRUE)
xvals<-seq(0,120,20)
yvals<-seq(0,1.5,0.25)
abline(h=yvals,v=xvals,col="gray",lty=3)
axis(side=1,at=xvals, cex.axis=1.5, labels = xvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")
axis(side=2,at=yvals, cex.axis=1.5, labels = yvals, cex.axis=1.5,cex.lab=1.5, tck = -0.02, col.ticks = "black")

#par(xpd=FALSE)
abline(h=0, col="black", lty=2)
#abline(v=0, col="black", lty=2)

#mtext("C3 grass GPP", side = 3, line = -2, cex = 1.2)
lines(s2gap[,3],type="l",ylab=vvv,xlab="Year",col=grcol, xaxt="n",ylim= ylts)
#par(new=TRUE)
lines(s2gap[,6],type="l",ylab=vvv,xlab="Year",col=shcol, xaxt="n",ylim= ylts)
#lines(s2gap[,8],type="l",ylab=vvv,xlab="Year",col="green2", xaxt="n",ylim= ylts)



mtext(text="Site I",side=2,line=1,at=c(1,1),adj=3, outer=TRUE,cex=1.25 )
mtext(text="Site II",side=2,line=1,at=c(1,1),adj=8, outer=TRUE,cex=1.25)

mtext(text="Default parameters",side=3,line=1,at=c(1,1),adj=5.6, outer=TRUE,cex=1.15)
mtext(text="Allometry updated",side=3,line=1,at=c(1,1),adj=3.6, outer=TRUE,cex=1.15)
mtext(text="Allometry & parameters updated",side=3,line=1,at=c(1,1),adj=1.05, outer=TRUE,cex=1.15)

#mtext(text="US",side=2,line=0,at=c(1,1),adj=30, outer=TRUE,cex=1.4)
#mtext(text="RMS",side=2,line=0,at=c(1,1),adj=26.5, outer=TRUE,cex=1.4)
box("inner", col="black",  lwd = 1)



graphics.off()
plotname1 <- paste0("GPP_all_legend.png")

png(plotname1,res = 300,width =10.5,height=7,units='in')
plot.new()

legend(x="center", ncol=3,legend=c("Juniper", "Shrub", "C3 grass"),
       col=c(juncol,shcol,grcol), lty=1,lwd=3)





dev.off()
