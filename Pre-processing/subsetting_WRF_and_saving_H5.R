# codes to subset WRF model and extract different meteorological variables 
# for ED for a single point. The codes also convert accumulated precipitation 
# to instantaneous precipiration and save the extracted data into H5 format
#************************************************
# written by Karun Pandit
#************************************************


library(rhdf5)
library(ncdf4)


setwd("/home/karunpandit/HOL_MET_DATA_NEW")


for (i in 2014:2014) { 
  
  for (j in 1:12) {
    
    if (j == 1) {k2 = 31}
    if (j == 2) {k2 = 28}
    if (j == 3) {k2 = 31}
    if (j == 4) {k2 = 30}
    if (j == 5) {k2 = 31}
    if (j == 6) {k2 = 30}
    if (j == 7) {k2 = 31}
    if (j == 8) {k2 = 31}
    if (j == 9) {k2 = 30}
    if (j == 10) {k2 = 31}
    if (j == 11) {k2 = 30}
    if (j == 12) {k2 = 31}
    
    
   # Subsetting variables form WRF model 
    
    tmp <- wrf_opendap_loop(i,j,1,i,j,k2,1,"T2",170,72)
    pres <- wrf_opendap_loop(i,j,1,i,j,k2,1,"PSFC",170,72)
    prate_c <- wrf_opendap_loop(i,j,1,i,j,k2,1,"RAINNC",170,72)
    hgt <- wrf_opendap_loop(i,j,1,i,j,k2,1,"HGT",170,72)
    ugrd <- wrf_opendap_loop(i,j,1,i,j,k2,1,"U10",170,72)
    vgrd <- wrf_opendap_loop(i,j,1,i,j,k2,1,"V10",170,72)
    sh <- wrf_opendap_loop(i,j,1,i,j,k2,1,"Q2",170,72)
    dlwrf <- wrf_opendap_loop(i,j,1,i,j,k2,1,"GLW",170,72)
    nbdsf <- wrf_opendap_loop(i,j,1,i,j,k2,1,"SWDOWN",170,72)
    
    
    
    tmp <- as.vector(tmp)
    pres <- as.vector(pres)
    prate_c <- as.vector(prate_c)
    hgt <- as.vector(hgt)
    ugrd <- as.vector(ugrd)
    vgrd <- as.vector(vgrd)
    sh <- as.vector(sh)
    dlwrf <- as.vector(dlwrf)
    nbdsf <- as.vector(nbdsf)
    
    
    
    # calculating instantaneous precipitation form accumulated
    
    s=1
    
    t = length(prate_c)
    pr1 =  matrix (0,t)
    pr2 = matrix(0,t)
    
    for (s in 2:t) {
      
      
      pr1<- prate_c[c(s)]-prate_c[c(s-1)] 
      
      
      pr2[s] <- pr1 
    }
    
    bbb<- mean(pr2[2:4])
    
    pr2[1] <-bbb
    
    
    prate <- pr2/10800
    
    n = k2*8
    
    
    if (j == 1) {j  = "JAN"}
    if (j == 2) {j  = "FEB"}
    if (j == 3) {j  = "MAR"}
    if (j == 4) {j  = "APR"}
    if (j == 5) {j  = "MAY"}
    if (j == 6) {j  = "JUN"}
    if (j == 7) {j  = "JUL"}
    if (j == 8) {j  = "AUG"}
    if (j == 9) {j  = "SEP"}
    if (j == 10) {j = "OCT"}
    if (j == 11) {j = "NOV"}
    if (j == 12) {j = "DEC"}
    
    
    # writing H5 files for the extracted variables
    
    
    filename <- paste0("HOL_",i,j,".h5")
    
    # Create new hdf5 file
    h5createFile(filename)
    
    h5createDataset(filename, "tmp", c(n,1,1))
    h5createDataset(filename, "pres", c(n,1,1))
    h5createDataset(filename, "prate", c(n,1,1))
    h5createDataset(filename, "hgt", c(n,1,1))
    h5createDataset(filename, "ugrd", c(n,1,1))
    h5createDataset(filename, "vgrd", c(n,1,1))
    
    h5createDataset(filename, "sh", c(n,1,1))
    h5createDataset(filename, "dlwrf", c(n,1,1))
    h5createDataset(filename, "nbdsf", c(n,1,1))
    
    h5createDataset(filename, "nddsf", c(n,1,1))
    h5createDataset(filename, "vbdsf", c(n,1,1))
    h5createDataset(filename, "vddsf", c(n,1,1))
    
    
    
    
    h5write(tmp, file = filename, name = "/tmp")
    h5write(pres, file = filename, name = "/pres")
    h5write(prate, file = filename, name = "/prate")
    h5write(hgt, file = filename, name = "/hgt")
    h5write(ugrd, file = filename, name = "/ugrd")
    h5write(vgrd, file = filename, name = "/vgrd")
    h5write(sh, file = filename, name = "/sh")
    h5write(dlwrf, file = filename, name = "/dlwrf")
    h5write(nbdsf, file = filename, name = "/nbdsf")
    
  }
}
H5close()

