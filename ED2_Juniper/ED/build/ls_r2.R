setwd('/home/kpandit/EDsh/ED_sla8/output/gpp_fn/ls_temp') 
source('/home/kpandit/EDsh/ED_sla8/output/gpp_fn/gpp_fn_ch_ls.R')
styr  = 2014
endyr = 2016

for (out in seq(1, 2, 1)) {

  if (out==1) {
year <- gpp_fn_ch_ls(styr,endyr,out)

}

  else if (out==2) {
    month <- gpp_fn_ch_ls(styr,endyr,out)
  }
  
}

write.csv(year,file='daily_out')
write.csv (month, file='monthly_out')

#write.csv(year,file='/home/kpandit/EDsh/sla_8/output/gpp_fn/daily_out1')




xyz<-read.csv(file="daily_out", header = TRUE, sep = ",")

#mondata<-read.csv(file="filename4", header = TRUE, sep = ",")

newxyz<- xyz[which(xyz$date2==2014 & xyz$date1>9),]
newxyz1<- xyz[which(xyz$date2==2015),]


newxyz2<- xyz[which(xyz$date2==2016 & xyz$date1<10),]

yeardata1<- rbind(newxyz,newxyz1,newxyz2)

write.csv(yeardata1,file="simdataall")


newxyz1a<- xyz[which(xyz$date2==2015 & xyz$date1>9),]
yeardata2<- rbind(newxyz1a,newxyz2)

write.csv(yeardata2,file="simdata_year")


simtot1<-yeardata1[1:71,]
simtot2<-yeardata1[141:730,]
yeardata<-rbind(simtot1,simtot2)



write.csv(yeardata,file='combined')
write.csv(yeardata2,file='combined2')


simtot<- yeardata[,4]
minsimtot<-min(simtot)
maxsimtot<-max(simtot)
sdsimtot<-sd(simtot)
mnsimtot<- mean(simtot)

sim18<- yeardata[,2]
minsim18<-min(sim18)
maxsim18<-max(sim18)
sdsim18 <- sd(sim18)
mnsim18<-mean(sim18)

sim5<- yeardata[,3]
minsim5<-min(sim5)
maxsim5<-max(sim5)
sdsim5 <- sd(sim5)
mnsim5<-mean(sim5)




# for annual data

simtot_a<- yeardata2[,4]
minsimtot_a<-min(simtot_a)
maxsimtot_a<-max(simtot_a)
sdsimtot_a<-sd(simtot_a)
mnsimtot_a<- mean(simtot_a)

sim18_a<- yeardata2[,2]
minsim18_a<-min(sim18_a)
maxsim18_a<-max(sim18_a)
sdsim18_a <- sd(sim18_a)
mnsim18_a<-mean(sim18_a)

sim5_a<- yeardata2[,3]
minsim5_a<-min(sim5_a)
maxsim5_a<-max(sim5_a)
sdsim5_a <- sd(sim5_a)
mnsim5_a<-mean(sim5_a)


testdata<-read.csv(file="/home/kpandit/EDsh/ED_sla8/output/gpp_fn/LS_FLUX_DATA_15_16.csv", header = TRUE, sep = ",")

testfull<- testdata[,9]/1000*365

write.csv(testfull,file="/home/kpandit/EDsh/ED_sla8/output/gpp_fn/testtest")

test1<-testdata[1:71,]
test2<-testdata[141:730,]
test<-rbind(test1,test2)
test<- test[,9]/1000*365


test_a<-testdata[366:730,]
test_a<- test_a[,9]/1000*365


outouttest<-cbind(simtot,test)
outouttest_a<-cbind(simtot_a,test_a)

write.csv(outouttest,file="/home/kpandit/EDsh/ED_sla8/output/gpp_fn/testdata")
write.csv(outouttest_a,file="/home/kpandit/EDsh/ED_sla8/output/gpp_fn/testdata_a")

#write.csv(test2,file="test2")

test_18<-test/2
test_5<-test/2

diff_tot<-((simtot-test)^2)
yy2_tot<-mean(diff_tot)
rmse_tot<-sqrt(yy2_tot)

diff_18<-((sim18-test_18)^2)
yy2_18<-mean(diff_18)
rmse_18<-sqrt(yy2_18)

diff_5<-((sim5-test_5)^2)
yy2_5<-mean(diff_5)
rmse_5<-sqrt(yy2_5)


sdtest<- sd(test)
sdtest_18<-sd(test_18)
sdtest_5<-sd(test_5)

vartest<- sdtest^2
vartest_18<-sdtest_18^2
vartest_5<-sdtest_5^2


NSE <- 1 - (yy2_tot/vartest)
NSE_18<- 1-(yy2_18/vartest_18)
NSE_5 <- 1 - (yy2_5/vartest_5)


#RMSE and NSE for annual
test_18_a<-test_a/2
test_5_a<-test_a/2

diff_tot_a<-((simtot_a-test_a)^2)
yy2_tot_a<-mean(diff_tot_a)
rmse_tot_a<-sqrt(yy2_tot_a)

diff_18_a<-((sim18_a-test_18_a)^2)
yy2_18_a<-mean(diff_18_a)
rmse_18_a<-sqrt(yy2_18_a)

diff_5_a<-((sim5_a-test_5_a)^2)
yy2_5_a<-mean(diff_5_a)
rmse_5_a<-sqrt(yy2_5_a)


sdtest_a<- sd(test_a)
sdtest_18_a<-sd(test_18_a)
sdtest_5_a<-sd(test_5_a)

vartest_a<- sdtest_a^2
vartest_18_a<-sdtest_18_a^2
vartest_5_a<-sdtest_5_a^2

NSE_a <- 1 - (yy2_tot_a/vartest_a)
NSE_18_a<- 1-(yy2_18_a/vartest_18_a)
NSE_5_a <- 1 - (yy2_5_a/vartest_5_a)



#calculate r2
yyyy<-simtot
xxxx<-test
xxyy<-xxxx*yyyy
sumxx<-sum(xxxx)
sumyy<-sum(yyyy)
sumxxyy<-sum(xxyy)
sqxx<-xxxx*xxxx
sqyy<-yyyy*yyyy
sumsqxx<-sum(sqxx)
sumsqyy<-sum(sqyy)

upper<-((661*sumxxyy-sumxx*sumyy)^2)
lower<- (661*sumsqxx-sumxx*sumxx)*(661*sumsqyy-sumyy*sumyy)

rsq<-upper/lower

#r2 for shrub
yyyy_18<-sim18
xxxx_18<-test/2
xxyy_18<-xxxx_18*yyyy_18
sumxx_18<-sum(xxxx_18)
sumyy_18<-sum(yyyy_18)
sumxxyy_18<-sum(xxyy_18)
sqxx_18<-xxxx_18*xxxx_18
sqyy_18<-yyyy_18*yyyy_18
sumsqxx_18<-sum(sqxx_18)
sumsqyy_18<-sum(sqyy_18)

upper_18<-((661*sumxxyy_18-sumxx_18*sumyy_18)^2)
lower_18<- (661*sumsqxx_18-sumxx_18*sumxx_18)*(661*sumsqyy_18-sumyy_18*sumyy_18)

rsq_18<-upper_18/lower_18


yyyy_5<-sim5
xxxx_5<-test/2
xxyy_5<-xxxx_5*yyyy_5
sumxx_5<-sum(xxxx_5)
sumyy_5<-sum(yyyy_5)
sumxxyy_5<-sum(xxyy_5)
sqxx_5<-xxxx_18*xxxx_5
sqyy_5<-yyyy_18*yyyy_5
sumsqxx_5<-sum(sqxx_5)
sumsqyy_5<-sum(sqyy_5)

upper_5<-((661*sumxxyy_5-sumxx_5*sumyy_5)^2)
lower_5<- (661*sumsqxx_5-sumxx_5*sumxx_5)*(661*sumsqyy_5-sumyy_5*sumyy_5)

rsq_5<-upper_5/lower_5


#r2 for annual calculations

yyyy_a<-simtot_a
xxxx_a<-test_a
xxyy_a<-xxxx_a*yyyy_a
sumxx_a<-sum(xxxx_a)
sumyy_a<-sum(yyyy_a)
sumxxyy_a<-sum(xxyy_a)
sqxx_a<-xxxx_a*xxxx_a
sqyy_a<-yyyy_a*yyyy_a
sumsqxx_a<-sum(sqxx_a)
sumsqyy_a<-sum(sqyy_a)

upper_a<-((365*sumxxyy_a-sumxx_a*sumyy_a)^2)
lower_a<- (365*sumsqxx_a-sumxx_a*sumxx_a)*(365*sumsqyy_a-sumyy_a*sumyy_a)

rsq_a<-upper_a/lower_a

#r2 for shrub
yyyy_18_a<-sim18_a
xxxx_18_a<-test_a/2
xxyy_18_a<-xxxx_18_a*yyyy_18_a
sumxx_18_a<-sum(xxxx_18_a)
sumyy_18_a<-sum(yyyy_18_a)
sumxxyy_18_a<-sum(xxyy_18_a)
sqxx_18_a<-xxxx_18_a*xxxx_18_a
sqyy_18_a<-yyyy_18_a*yyyy_18_a
sumsqxx_18_a<-sum(sqxx_18_a)
sumsqyy_18_a<-sum(sqyy_18_a)

upper_18_a<-((365*sumxxyy_18_a-sumxx_18_a*sumyy_18_a)^2)
lower_18_a<- (365*sumsqxx_18_a-sumxx_18_a*sumxx_18_a)*(365*sumsqyy_18_a-sumyy_18_a*sumyy_18_a)

rsq_18_a<-upper_18_a/lower_18_a


yyyy_5_a<-sim5_a
xxxx_5_a<-test_a/2
xxyy_5_a<-xxxx_5_a*yyyy_5_a
sumxx_5_a<-sum(xxxx_5_a)
sumyy_5_a<-sum(yyyy_5_a)
sumxxyy_5_a<-sum(xxyy_5_a)
sqxx_5_a<-xxxx_18_a*xxxx_5_a
sqyy_5_a<-yyyy_18_a*yyyy_5_a
sumsqxx_5_a<-sum(sqxx_5_a)
sumsqyy_5_a<-sum(sqyy_5_a)

upper_5_a<-((365*sumxxyy_5_a-sumxx_5_a*sumyy_5_a)^2)
lower_5_a<- (365*sumsqxx_5_a-sumxx_5_a*sumxx_5_a)*(365*sumsqyy_5_a-sumyy_5_a*sumyy_5_a)

rsq_5_a<-upper_5_a/lower_5_a


newdata<- cbind(mnsimtot,minsimtot,maxsimtot,sdsimtot,mnsim18,minsim18,maxsim18,sdsim18,mnsim5,minsim5,maxsim5,sdsim5,rsq,rsq_18,rsq_5,rmse_tot,rmse_18,rmse_5,NSE,NSE_18,NSE_5,mnsimtot_a,minsimtot_a,maxsimtot_a,sdsimtot_a,mnsim18_a,minsim18_a,maxsim18_a,sdsim18_a,mnsim5_a,minsim5_a,maxsim5_a,sdsim5_a,rsq_a,rsq_18_a,rsq_5_a,rmse_tot_a,rmse_18_a,rmse_5_a,NSE_a,NSE_18_a,NSE_5_a)

# check whether pft 5 is less than or more than 50% of total

write.csv(newdata,file="out_list")
write.table(newdata, file = "summary", col.names = FALSE)

write.table(newdata, file = "/home/kpandit/EDsh/ED_sla8/output/gpp_fn/ls_temp/summary_ls", col.names = FALSE)


#<-upper_18_a/lower_18_a
#write.table(yeardata, file = "/home/kpandit/EDsh/ED_sla8/output/gpp_fn/params_fn/outdata", col.names = FALSE)
