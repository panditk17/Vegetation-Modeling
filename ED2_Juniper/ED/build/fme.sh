#!/bin/bash

#SBATCH -J ED2
#SBATCH -o log_sbatch.o%j
#SBATCH -n 56
#SBATCH -p defq
#SBATCH -t 8:00:00

# Generally needed modules:
#module load slurm
#module load ed2 

module load R/gcc/serial/3.5.0

  
/cm/shared/apps/r/3.4.1/bin/Rscript /home/kpandit/EDsh/ED_sla8/output/gpp_fn/fme.R
