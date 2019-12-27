setwd('C:/Karun_documents/fire_related_docs/chart_fire_ndvi_gpp')
rm(list=ls(all.names=TRUE))
all<-read.csv('new_all_grids.csv')
fire<-read.csv('new_fire_grids.csv')
nofire<-read.csv('new_no_fire_grids.csv')

library(ggplot2)
library(gridExtra)
library(grid)
vvv=expression(paste("GPP (kgCm"^{-2},"yr"^{-1},")"))
var="GPP"


nofire_cols = nofire[,2:6]
fire_cols = fire[,2:6]
both_cols = all[,2:6]

mean_f<-colMeans(fire_cols)
mean_nf<-colMeans(nofire_cols)
mean_both<-colMeans(both_cols)

sd_f<-apply(fire_cols,2,sd)
sd_nf<-apply(nofire_cols,2,sd)
sd_both<-apply(both_cols,2,sd)

data_f<-cbind(mean_f,sd_f)
year.names<-c("2015","2016","2017","2018","2019")
group.fire<-c("fire","fire","fire","fire","fire")
data_f<-cbind(year.names,group.fire,data_f)

group.nf<-c("nofire","nofire","nofire","nofire","nofire")
data_nf<-cbind(year.names,group.nf,mean_nf,sd_nf)

group.both<-c("total","total","total","total","total")
data_both<-cbind(year.names,group.both,mean_both,sd_both)

data_all<-rbind(data_f,data_nf,data_both)
data_all<-as.data.frame(data_all)

#mean<-as.numeric(as.character(data_all[,3]))
#sd<-as.numeric(as.character(data_all[,4]))
meanall<-as.numeric(as.character(data_all[,3]))
sdall<-as.numeric(as.character(data_all[,4]))

#row.names(data_f)<-c("2015","2016","2017","2018","2019")
graphics.off()
plotname1 <- paste0("GPP_chart1",var,".png")

png(plotname1,res = 300,width =9,height=12,units='in')
par(mfrow=c(2,1))
#par(mar=c(2, 2, 1, 1), xpd=TRUE)
par(mar = c(1, 4, 1, 0.5), oma = c(6, 3, 0.2, 0.3))


#par(mai=c(5,4,2,2))


yvals=c(seq(0,0.6,0.2))

p1<- ggplot(data_all, aes(x=data_all[,1],y= meanall, fill=data_all[,2])) + 
  geom_bar(stat="identity", color="black",position=position_dodge(.9),show.legend=FALSE) +
  #scale_x_discrete(labels = ) +
  scale_y_continuous(labels=yvals,breaks=yvals,limit=c(0,0.64)) +

  labs(title="", y=vvv,x="",tag="(a)",2.5,0.5) +
  ggtitle("GPP from model simulation") +
  theme(plot.title = element_text(hjust = 0.5,size=20))+
  
           geom_errorbar(aes(ymin=meanall-sdall,ymax=meanall+sdall), width=.2,
                position=position_dodge(.9)) +
  scale_fill_manual(name="",label=c("burnt","unburnt","total"), values = c("red3","green3","royalblue3")) +
  theme(panel.background = element_blank(),
  panel.grid.major.y = element_line(size = 0.5, linetype = 'dashed',
                                  colour = "gray"),
  axis.text=element_text(size=14,color="black"),
  axis.title=element_text(size=16, color ="black"),
  legend.text = element_text(colour="black", size = 16),
  plot.margin=unit(c(1,1,1,1), "cm"),
  legend.position= "bottom",
  plot.tag=element_text(size=22))+
  annotate("text", x=1, y=0.62, label= "pre-fire year",cex=6) +
  annotate("text",x=3.5,y=0.62,label="post-fire years",cex=6) +
  geom_vline(xintercept=1.5, linetype="dashed", color = "red",lwd=1)




nofire_cols_b = nofire[,7:11]
fire_cols_b = fire[,7:11]
both_cols_b = all[,7:11]

mean_f_b<-colMeans(fire_cols_b)
mean_nf_b<-colMeans(nofire_cols_b)
mean_both_b<-colMeans(both_cols_b)

sd_f_b<-apply(fire_cols_b,2,sd)
sd_nf_b<-apply(nofire_cols_b,2,sd)
sd_both_b<-apply(both_cols_b,2,sd)

data_f_b<-cbind(mean_f_b,sd_f_b)
#year.names<-c("2015","2016","2017","2018","2019")
#group.fire<-c("fire","fire","fire","fire","fire")
data_f_b<-cbind(year.names,group.fire,data_f_b)

#group.nf<-c("nofire","nofire","nofire","nofire","nofire")
data_nf_b<-cbind(year.names,group.nf,mean_nf_b,sd_nf_b)

#group.both<-c("total","total","total","total","total")
data_both_b<-cbind(year.names,group.both,mean_both_b,sd_both_b)

data_all_b<-rbind(data_f_b,data_nf_b,data_both_b)
data_all_b<-as.data.frame(data_all_b)

#mean<-as.numeric(as.character(data_all[,3]))
#sd<-as.numeric(as.character(data_all[,4]))
meanall_b<-as.numeric(as.character(data_all_b[,3]))
sdall_b<-as.numeric(as.character(data_all_b[,4]))
 
yvals_b=c(seq(0,0.4,0.1))

p2<-ggplot(data_all_b, aes(x=data_all_b[,1],y= meanall_b, fill=data_all_b[,2])) + 
  geom_bar(stat="identity", color="black",position=position_dodge(.9)) +
  #scale_x_discrete(labels = ) +
  scale_y_continuous(labels=yvals_b,breaks=yvals_b,limit=c(0,0.37)) +
  
  labs(title="", y="NDVI",x="",tag="(b)",2.5,0.5) +
  ggtitle("NDVI from Landsat") +
  theme(plot.title = element_text(hjust = 0.5,size=20))+
  
  geom_errorbar(aes(ymin=meanall_b-sdall_b,ymax=meanall_b+sdall_b), width=.2,
                position=position_dodge(.9)) +
  scale_fill_manual(name="",label=c("burnt area","unburnt area","total"), values = c("red3","green3","royalblue3")) +
  theme(panel.background = element_blank(),
        panel.grid.major.y = element_line(size = 0.5, linetype = 'dashed',
                                          colour = "gray"),
        axis.text=element_text(size=14,color="black"),
        axis.title=element_text(size=16, color ="black"),
        legend.text = element_text(colour="black", size = 16),
        plot.margin=unit(c(1,1,1,1), "cm"),
        plot.tag=element_text(size=22),
        legend.position= "bottom")+
  annotate("text", x=1, y=0.35, label= "pre-fire year",cex=6) +
  annotate("text",x=3.5,y=0.35,label="post-fire years",cex=6) +
  geom_vline(xintercept=1.5, linetype="dashed", color = "red",lwd=1)

p3<- grid.arrange(p1,p2,ncol=1)
print(p3)
#dev.print(p1,file="test.png",  width=800)
#scale_fill_hue(name="Supplement type", labels=c("no fire","fire","total"),colors=c("green","red","blue")) +


dev.off()

