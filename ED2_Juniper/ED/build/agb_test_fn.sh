#!/bin/bash

#SBATCH -J ED2_AGB_SH
#SBATCH -o log_sbatch.o%j
#SBATCH -n 28
#SBATCH -p shortq
#SBATCH -t 10:00:00

# Generally needed modules:
#module load slurm
#module load ed2 
module load R/gcc/serial/3.5.0	
P1=$1
P2=$2 
P3=$3
P4=$4
P5=$5
P6=$6
P7=$7
P8=$8
P9=$9

cp agb_change_fn.xml config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml

cp agb_namelist_fn ED2IN_FNA$P1$P2$P3$P4$P5$P6$P7$P8$P9

rm -r /home/kpandit/scratch/sens/agbout/temp$P1$P2$P3$P4$P5$P6$P7$P8$P9

mkdir /home/kpandit/scratch/sens/agbout/temp$P1$P2$P3$P4$P5$P6$P7$P8$P9

sed -i s/NUM/6/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/VM0/$P1/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/sla/$P2/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/ROOT_TURNOVER_RATE/$P3/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/LEAF_TURNOVER_RATE/$P4/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/STOMATAL_SLOPE/$P5/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/CUTICULAR_COND/$P6/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/WATER_CONDUCTANCE/$P7/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/QQQ/$P8/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/GROWTH_RESP_FACTOR/$P9/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml

sed -i s/B1HT/10.487/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B2HT/-0.0147/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B1BL_SMALL/0.152/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B1BL_LARGE/0.152/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B2BL_SMALL/1.598/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B2BL_LARGE/1.598/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B1BS_SMALL/0.0346/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B1BS_LARGE/0.0346/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B2BS_SMALL/2.487/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B2BS_LARGE/2.487/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B1VOL/0.107/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml
sed -i s/B2VOL/2/g config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9.xml


sed -i s/dirout/temp$P1$P2$P3$P4$P5$P6$P7$P8$P9/g ED2IN_FNA$P1$P2$P3$P4$P5$P6$P7$P8$P9
sed -i s/agbconfig/config_fna$P1$P2$P3$P4$P5$P6$P7$P8$P9/g ED2IN_FNA$P1$P2$P3$P4$P5$P6$P7$P8$P9
#cp ttt /home/kpandit/EDsh/ED_sla8/output/gpp_fn/ttt
# sed -i s/ttt/tmtm/g /home/kpandit/EDsh/ED_sla8/output/gpp_fn/newr.R

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/kpandit/hdnew/lib ./ed_2.1-opt -f ED2IN_FNA$P1$P2$P3$P4$P5$P6$P7$P8$P9
#/cm/shared/apps/r/3.4.1/bin/Rscript /home/kpandit/EDsh/ED_sla8/output/gpp_fn/gpp_fn.hhhhhhhhR
