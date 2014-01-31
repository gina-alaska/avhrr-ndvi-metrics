#!/bin/bash
#this script call avhrr_ndvi_metrics.bash to process 1982 to 2000 avhrr ndvi metrics

avhrr_script_dir=/import/home/u1/uaf/jzhu/nps/cesu/avhrr_ndvi_window/scripts

avhrr_data_dir=/import/home/u1/uaf/jzhu/nps/cesu/avhrr_ndvi_window/data1

#export IDL_STARTUP=/import/home/u1/uaf/jzhu/nps/cesu/avhrr_ndvi_window/startup_nps

cd $avhrr_data_dir

ls $PWD/ak_nd_???? >flist

cd $avhrr_script_dir

while read filename

do


filen=$filename
filen_sm=${filename}sm

echo "process : $filen..."

$avhrr_script_dir/avhrr_ndvi_metrics.bash $filen $filen_sm

done<$avhrr_data_dir/flist

exit 
