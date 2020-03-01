#!/bin/bash

#SBATCH -J SEL-ED
#SBATCH -o log_sbatch.o%j
#SBATCH -n 28 
#SBATCH --cpus-per-task=1
#SBATCH -p defq
#SBATCH -t 12:00:00

# Generally needed modules:
#module load slurm
#module load ed2 

cp change_param.xml config.xml

cp namelist_his ED2IN_HIS


#mkdir /home/kpandit/scratch/test_output

sed -i s/NUM/18/g config.xml
sed -i s/sla/6/g config.xml
sed -i s/VM0/14/g config.xml
sed -i s/STOMATAL_SLOPE/10/g config.xml
sed -i s/LEAF_WIDTH/0.05/g config.xml
sed -i s/GROWTH_RESP_FACTOR/0.33/g config.xml
sed -i s/LEAF_TURNOVER_RATE/1/g config.xml
sed -i s/ROOT_TURNOVER_RATE/0.33/g config.xml
sed -i s/STORAGE_TURNOVER_RATE/0.624/g config.xml
sed -i s/WATER_CONDUCTANCE/.000019/g config.xml
sed -i s/CUTICULAR_COND/1000/g config.xml
sed -i s/Q/3.2/g config.xml


sed -i s/dirout/test_output/ ED2IN_HIS


LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/kpandit/hdnew/lib ./ed_2.1-opt -f ED2IN_HIS


