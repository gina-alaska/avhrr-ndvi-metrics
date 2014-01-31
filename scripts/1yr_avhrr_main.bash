#!/bin/bash
#this script call many scripts to finish one-year ndvi metrics calculation
#input:year
#outputs: a smooth data file, a metrics file

if [ $# != 1 ];then

echo "input year"

exit 1

fi

year=$1

#0. set variables, load environment variables,and craete a log file


ndvi_dir=~/nps/cesu/avhrr_usgs_ndvi

#load environment variabels

source $ndvi_dir/scripts/1yr_avhrr_env.bash

#make a directory

mkdir -p $work_dir/$year


#Send output to logfile

LOG=$work_dir/$year/${year}-ndvi-metrics.log

exec >>$LOG

exec 2>>$LOG
echo "________________________"
echo $0 started at `date -u`

#1.copy raw files from /projects/project-data/emodis to $WRKDIR/nps/ndvi

echo copy raw data to $work_dir/$year started at `date -u`

$script_dir/1yr_avhrr_copy.bash $year


#2.get the flist names for ndvi and bq 

$script_dir/1yr_avhrr_flist.bash $work_dir $year

flist_ndvi=$work_dir/$year/${year}_flist_ndvi

flist_bq=$work_dir/$year/${year}_flist_bq

flist_cldm=$work_dir/$year/${year}_flist_cldm

if [ ! -e $flist_ndvi ] ;then

exit 1

fi 

#3.make the single file for each composite day

echo stack one year data files started at `date -u`

$script_dir/1yr_avhrr_stack.bash $flist_ndvi $flist_bq $flist_cldm 0 0 0 0 

#4.calculate ndvi metrics

echo calculate ndvi-metrics started at `date -u`

$script_dir/1yr_avhrr_calmetrics.bash $work_dir/$year/${year}_stacked_ndvi $work_dir/$year/${year}_stacked_bq $work_dir/$year/${year}_stacked_cldm 'ver5'


echo calculate ndvi-metrics ended at `date -u`

#5.copy smoothed data file and ndvi-metrics file from $work_dir to $rawdata_dir/$year

mkdir -p $result_dir/${year}

mv $work_dir/${year}/* $result_dir/${year}

#rm -r $work_dir/${year}

echo copy ndvi-metrics and smooth data back to rawdata directory ended at `date -u`
  
exit
