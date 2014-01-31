#!/bin/bash
#this script calcualte ndvi metrics.
#input: a one-year file name
#outputs: a smooth data file, a metrics file


if [ $# != 4 ];then

echo "input stacked_ndvi_file,stacked_qa_file,stacked_cldmask_file, ver"

exit 1

fi

#load environment variabels

source ./1yr_avhrr_env.bash

#cd $idlprg_dir

stacked_ndvi_file=$1
stacked_qa_file=$2
stacked_cldmask_file=$3
ver=$4
flg=0

fd=`dirname $stacked_ndvi_file`

#Send output to logfile
#LOG=$fd/calculate-metrics.log
#exec >>$LOG
#exec 2>>$LOG

echo "________________________"

#send start time

echo "calculating ndvi-metrics started at `date -u`"

#/usr/local/pkg/idl/idl-7.1/idl71/bin/idl<<EOF

$idl_dir/idl<<EOF
restore,filename='/u1/uaf/jzhu/nps/cesu/avhrr_usgs_ndvi/sav/codes_v7.sav'
avhrr_calculate_ndvi_metrics_tile,'$stacked_ndvi_file','$stacked_qa_file','$stacked_cldmask_file','$ver'
exit
EOF

#Send end time

echo "________________________"

echo $0 ended at `date -u`

exit
