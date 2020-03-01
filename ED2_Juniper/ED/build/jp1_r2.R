setwd('/home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_temp') 
source('/home/kpandit/EDsh/ED_J/output/gpp_fn/gpp_fn_fold_jp1.R')
styr  = 1955
endyr = 2019

year <- gpp_fn_fold_jp1(styr,endyr,out)


write.csv(year,file='annual_out')


# c, file = "/home/kpandit/EDsh/ED_sla8/output/gpp_fn/ls_temp/summary_ls", col.names = FALSE)



#<-upper_18_a/lower_18_a
write.table(year, file = "/home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_temp/summary_jp1", col.names = FALSE)
