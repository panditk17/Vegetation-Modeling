#!/bin/bash

#SBATCH -J ED2_GPP_LN
#SBATCH -o log_sbatch.o%j
#SBATCH -n 28
#SBATCH -p defq
#SBATCH -t 240:00:00

# Generally needed modules:
#module load slurm
#module load ed2 

module load R/gcc/serial/3.5.0

  
/cm/shared/apps/r/3.4.1/bin/Rscript /home/kpandit/EDsh/ED_J/output/new_morris.R
