setwd('C:/Karun_documents/fire_related_docs/chart_fire_ndvi_gpp')
rm(list=ls(all.names=TRUE))

data_all<-read.csv('new_all_grids.csv')


var_name="GPP (kgC/m2/yr)"
var="gpp"
vvv=expression(paste("GPP (kgCm"^{-2},"yr"^{-1},")"))


library(Hmisc)
library(ggplot2)
library(gridExtra)


colnames(data_all)<- c("type","GPP_2015","GPP_2016","GPP_2017","GPP_2018","GPP_2019",
                       "NDVI_2015","NDVI_2016","NDVI_2017","NDVI_2018","NDVI_2019")

data_f<-data_all[data_all[, 1] == 2,]
data_nf<-data_all[data_all[, 1] == 1,]


NDVI_all<-data_all[,7:11]
GPP_all<-data_all[,2:6]
NDVI_f<-data_f[,7:11]
GPP_f<-data_f[,2:6]
NDVI_nf<-data_nf[,7:11]
GPP_nf<-data_nf[,2:6]


#NDVI_all<-as.matrix(NDVI_all)
#GPP_all<-as.matrix(GPP_all)

columns<-c(1,2,3,4,5)
z<-seq(1,5,1)


# correlation for fire plots

f_rows<-matrix(nrow=0,ncol=3)

for (z in columns) {
  corr_f<-rcorr(GPP_f[,z],NDVI_f[,z], type = c("pearson"))
  tab_f_corr=corr_f[["r"]]
  tab_f_test=corr_f[["P"]]
  tab_f_n=corr_f[["n"]]
  f_test<-cbind(tab_f_n[1,2],tab_f_corr[1,2],round(tab_f_test[1,2],digit=10))
  f_rows<-rbind(f_rows,f_test)
}

# for non fire grids
nf_rows<-matrix(nrow=0,ncol=3)

for (z in columns) {
  corr_nf<-rcorr(GPP_nf[,z],NDVI_nf[,z], type = c("pearson"))
  tab_nf_corr=corr_nf[["r"]]
  tab_nf_test=corr_nf[["P"]]
  tab_nf_n=corr_nf[["n"]]
  nf_test<-cbind(tab_nf_n[1,2],tab_nf_corr[1,2],round(tab_nf_test[1,2],digit=10))
  nf_rows<-rbind(nf_rows,nf_test)
}



# correlation for all plots

all_rows<-matrix(nrow=0,ncol=3)

for (z in columns) {
  corr_all<-rcorr(GPP_all[,z],NDVI_all[,z], type = c("pearson"))
  tab_corr_all=corr_all[["r"]]
  tab_all_test=corr_all[["P"]]
  tab_all_n=corr_all[["n"]]
  all_test<-cbind(tab_all_n[1,2],tab_corr_all[1,2],round(tab_all_test[1,2],digit=10))
  all_rows<-rbind(all_rows,all_test)
}

# table all correlations

all_corr_tab <- as.data.frame(cbind(all_rows,f_rows,nf_rows))
write.csv(all_corr_tab,"table_correlation.csv")


graphics.off()
plotname1 <- paste0("GPP_vs_NDVI_scatter",var,".png")

aaaq<-png(plotname1,res = 300,width =12,height=16,units='in')
par(mfcol=c(5,3))
#par(mar=c(2, 2, 1, 1), xpd=TRUE)
par(mar = c(4, 5, 4, 0.5), oma = c(2, 2, 5, 5))

#par(mfrow = c(5, 1))


#

#plotname1 <- paste0("GPP_scatter2",var,".png")

#bbbq<-png(plotname1,res = 300,width =12,height=16,units='in')
#par(mfrow=c(5,1))
#par(mar=c(2, 2, 1, 1), xpd=TRUE)
#par(mar = c(4, 5, 4, 0.5), oma = c(2, 1, 1, 0.3))

#par(mfrow = c(5, 1))

seqcol<- c(1,2,3,4,5)
ccc=1

for (ccc in seq (1,5,1)) {
  
  if (ccc ==1) {year=2015}
  if (ccc==2) {year= 2016}
  if (ccc==3) {year= 2017}
  if (ccc==4) {year = 2018}
  if (ccc==5) {year= 2019}
  
  plot(GPP_f[,ccc],NDVI_f[,ccc], 
       xlab=vvv,ylab="NDVI", 
       pch=19, cex.axis=1.5,cex.lab=1.8,cex.main=2,col="red3")
  abline(lm(NDVI_f[,ccc] ~ GPP_f[,ccc]))
  text1<-paste0("r = ",round(f_rows[ccc,2],digit=3))
  text2<-paste0("p < ",round (f_rows[ccc,3],digit=3))
  mtext(text1, side = 3, line = -1.4, cex = 1,adj=0.995)
  mtext(text2, side = 3, line = -2.8, cex = 1,adj=0.995)
  mtext(year, side = 3, line = 0.2, cex = 1.5,adj=0.5)
  
}


seqcol<- c(1,2,3,4,5)
ccc=1

for (ccc in seq (1,5,1)) {
  
  if (ccc ==1) {year=2015}
  if (ccc==2) {year= 2016}
  if (ccc==3) {year= 2017}
  if (ccc==4) {year = 2018}
  if (ccc==5) {year= 2019}
  
  plot(GPP_nf[,ccc],NDVI_nf[,ccc], 
       xlab=vvv,ylab="NDVI", 
       pch=19, cex.axis=1.5,cex.lab=1.8,cex.main=2,col="green3")
  abline(lm(NDVI_nf[,ccc] ~ GPP_nf[,ccc]))
  text1<-paste0("r = ",round(nf_rows[ccc,2],digit=3))
  text2<-paste0("p < ",round (nf_rows[ccc,3],digit=3))
  mtext(text1, side = 3, line = -1.4, cex = 1,adj=0.995)
  mtext(text2, side = 3, line = -2.8, cex = 1,adj=0.995)
  mtext(year, side = 3, line = 0.2, cex = 1.5,adj=0.5)
  
}


seqcol<- c(1,2,3,4,5)
ccc=1

for (ccc in seq (1,5,1)) {
  
  if (ccc ==1) {year=2015}
  if (ccc==2) {year= 2016}
  if (ccc==3) {year= 2017}
  if (ccc==4) {year = 2018}
  if (ccc==5) {year= 2019}
  
  plot(GPP_all[,ccc],NDVI_all[,ccc], 
       xlab=vvv,ylab="NDVI", 
       pch=19, cex.axis=1.5,cex.lab=1.8,cex.main=1.9,col="royalblue3")
  abline(lm(NDVI_all[,ccc] ~ GPP_all[,ccc]))
  text1<-paste0("r = ",round(all_rows[ccc,2],digit=3))
  text2<-paste0("p < ",round (all_rows[ccc,3],digit=3))
  mtext(text1, side = 3, line = -1.4, cex = 1,adj=0.995)
  mtext(text2, side = 3, line = -2.8, cex = 1,adj=0.995)
  mtext(year, side = 3, line = 0.2, cex = 1.5,adj=0.5)
  
}


mtext("       Burnt area                  Unburnt area                    Whole area", side = 3, line = 0.1, cex=2,outer = TRUE)

dev.off()
