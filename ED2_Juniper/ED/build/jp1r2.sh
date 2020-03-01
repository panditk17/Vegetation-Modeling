#!/bin/bash

#SBATCH -J one_ED2
#SBATCH -o log_sbatch.o%j
#SBATCH -n 28
#SBATCH -p defq
#SBATCH -t 50:00:00

# Generally needed modules:
#module load slurm
 

for  P1 in $(seq $1 $2 $3)
do
  for P2 in $(seq $4 $5 $6)
  do
for P3 in $(seq $7 $8 $9)
do 
for P4 in $(seq ${10} ${11} ${12})
do 
for P5 in $(seq ${13} ${14} ${15})

do

cp r2_jp1.xml config_jp1_r2$P1$P2$P3$P4$P5.xml
cp namelist_jp1_r2 ED2IN_JP1_R2$P1$P2$P3$P4$P5

mkdir /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_fold$P1$P2$P3$P4$P5

sed -i s/NUM/6/g config_jp1_r2$P1$P2$P3$P4$P5.xml


sed -i s/SLA/$P1/g config_jp1_r2$P1$P2$P3$P4$P5.xml
sed -i s/STOMATAL_SLOPE/$P2/g config_jp1_r2$P1$P2$P3$P4$P5.xml
sed -i s/GROWTH_RESP_FACTOR/$P3/g config_jp1_r2$P1$P2$P3$P4$P5.xml
sed -i s/QQQ/$P4/g config_jp1_r2$P1$P2$P3$P4$P5.xml
sed -i s/VM0/$P5/g config_jp1_r2$P1$P2$P3$P4$P5.xml

sed -i s/dirout/jp1_fold$P1$P2$P3$P4$P5/g ED2IN_JP1_R2$P1$P2$P3$P4$P5

sed -i s/config_jp1/config_jp1_r2$P1$P2$P3$P4$P5/g ED2IN_JP1_R2$P1$P2$P3$P4$P5

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/kpandit/hdnew/lib ./ed_2.1-opt -f ED2IN_JP1_R2$P1$P2$P3$P4$P5

cp jp1_r2.R jp1_r2$P1$P2$P3$P4$P5.R

cp /home/kpandit/EDsh/ED_J/output/gpp_fn/gpp_fn_fold_jp1.R /home/kpandit/EDsh/ED_J/output/gpp_fn/gpp_fn_fold_jp1$P1$P2$P3$P4$P5.R 
sed -i s/jp1_temp/jp1_fold$P1$P2$P3$P4$P5/g jp1_r2$P1$P2$P3$P4$P5.R
sed -i s/summary_jp1/jp1_osm$P1$P2$P3$P4$P5/g jp1_r2$P1$P2$P3$P4$P5.R
sed -i s/gpp_fn_fold_jp1/gpp_fn_fold_jp1$P1$P2$P3$P4$P5/g jp1_r2$P1$P2$P3$P4$P5.R

sed -i s/foldname/jp1_fold$P1$P2$P3$P4$P5/g /home/kpandit/EDsh/ED_J/output/gpp_fn/gpp_fn_fold_jp1$P1$P2$P3$P4$P5.R
sed -i s/gpp_fn_fold_jp1/gpp_fn_fold_jp1$P1$P2$P3$P4$P5/g /home/kpandit/EDsh/ED_J/output/gpp_fn/gpp_fn_fold_jp1$P1$P2$P3$P4$P5.R

/cm/shared/apps/r/3.4.1/bin/Rscript /home/kpandit/EDsh/ED_J/ED/build/jp1_r2$P1$P2$P3$P4$P5.R

  read header
  while IFS="," read -r x ; 
    do 
    echo "$x, $P1, $P2, $P3, $P4, $P5" >> /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_list_a
    done < /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_fold$P1$P2$P3$P4$P5/jp1_osm$P1$P2$P3$P4$P5

rm /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_fold$P1$P2$P3$P4$P5/hhh*
rm /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_fold$P1$P2$P3$P4$P5/ggg*
rm /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_fold$P1$P2$P3$P4$P5/jp1_osm$P1$P2$P3$P4$P5

rm -r /home/kpandit/EDsh/ED_J/output/gpp_fn/jp1_fold$P1$P2$P3$P4$P5
#rm /home/kpandit/EDsh/ED_J/output/gpp_fn/ls_fold$P1$P2/daily_out

done
done
done
done
done
