setwd('/home/kpandit/scratch/regional/out_newmet_fire2')
library('rhdf5')

rm(list=ls()) 

library(rhdf5)


year<-2026

filexx <- paste0("hhh-D-",year,"-07-15-000000-g01.h5")

latlat <- h5read(filexx,"LATITUDE")
lonlon<-h5read(filexx,"LONGITUDE")
GPP<- h5read(filexx,"DMEAN_GPP_PY")

data1<-cbind(latlat,lonlon,GPP);

write.csv(data1,"fire_2026_GPP_ED.csv")




