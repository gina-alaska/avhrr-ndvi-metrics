#!/bin/bash
#this script calcualte ndvi metrics.
#input: a threeyear file name
#outputs: a smooth data file, a metrics file


if [ $# != 1 ];then

echo "input a one-year data file"

exit 1

fi

#load environment variabels

source ./1yr_emodis_250_env.bash

cd $idlprg_dir

stacked_file=$1

fd=`dirname $stacked_file`

#Send output to logfile
LOG=$fd/calculate-metrics.log
exec >>$LOG
exec 2>>$LOG
echo "________________________"

#send start time
echo calculating ndvi-metrics started at `date -u`




/usr/local/pkg/idl/idl-7.1/idl71/bin/idl<<EOF
smooth_calculate_metrics_tile_ver9,'$stacked_file'
exit
EOF


#Send end time

echo "________________________"

echo $0 ended at `date -u`

exit
