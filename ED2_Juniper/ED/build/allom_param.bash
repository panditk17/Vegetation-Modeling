#!/bin/bash

#SBATCH -J ED2
#SBATCH -o log_sbatch.o%j
#SBATCH -n 28
#SBATCH -p shortq
#SBATCH -t 10:00:00

# Generally needed modules:
#module load slurm
#module load ed2 
cp change_me1.xml config_1.xml

cp namelist_pft1 ED2IN_FN1

mkdir /home/kpandit/scratch/one_den_allom_par1


sed -i s/NUM/6/g config_1.xml
sed -i s/VM0/16.5/g config_1.xml
sed -i s/sla/6.3/g config_1.xml
sed -i s/ROOT_TURNOVER_RATE/0.2/g config_1.xml
sed -i s/LEAF_TURNOVER_RATE/0.2/g config_1.xml
sed -i s/STOMATAL_SLOPE/8.4/g config_1.xml
sed -i s/GROWTH_RESP_FACTOR/0.45/g config_1.xml
sed -i s/STORAGE_TURNOVER_RATE/0.624/g config_1.xml
sed -i s/WATER_CONDUCTANCE/.000019/g config_1.xml
sed -i s/CUTICULAR_COND/8400/g config_1.xml
sed -i s/Q/1.2/g config_1.xml

sed -i s/B1HT/10.487/g config_1.xml
sed -i s/B2HT/-0.0147/g config_1.xml

sed -i s/B1BS_SMALL/0.0346/g config_1.xml
sed -i s/B2BS_SMALL/2.4837/g config_1.xml
sed -i s/B1BS_LARGE/0.0346/g config_1.xml
sed -i s/B2BS_LARGE/2.4837/g config_1.xml

sed -i s/B1BL_SMALL/0.152/g config_1.xml
sed -i s/B2BL_SMALL/1.598/g config_1.xml
sed -i s/B1BL_LARGE/0.152/g config_1.xml
sed -i s/B2BL_LARGE/1.598/g config_1.xml

sed -i s/B1VOL/0.107/g config_1.xml
sed -i s/B2VOL/2/g config_1.xml


sed -i s/dirout/one_den_allom_par1/g ED2IN_FN1


LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/kpandit/hdnew/lib ./ed_2.1-opt -f ED2IN_FN1
  

