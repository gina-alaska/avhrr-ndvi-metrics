#!/bin/bash
#this script call many scripts to finish one-year ndvi metrics calculation
#input:year
#outputs: a smooth data file, a metrics file

if [ $# != 1 ];then

echo "input year"

exit 1

fi

year=$1

#make a directory

mkdir -p $WORKDIR/nps/ndvi/$year

#Send output to logfile
LOG=$WORKDIR/nps/ndvi/$year/ndvi-metrics.log
exec >>$LOG
exec 2>>$LOG
echo "________________________"

echo $0 started at `date -u`

#0. set variables

ndvi_dir=~/nps/cesu/modis_ndvi_250m

#load environment variabels

source $ndvi_dir/scripts/1yr_emodis_250_env.bash

year=$1

#1.copy raw files from /projects/project-data/emodis to $WRKDIR/nps/ndvi

echo copy raw data to $WORKDIR/nps/ndvi/$year started at `date -u`

$script_dir/1yr_emodis_250_copy.bash $year


#2.get the flist names for ndvi and bq 

$script_dir/1yr_emodis_250_flist.bash $WRKDIR/nps/ndvi $year

flist_ndvi=$WRKDIR/nps/ndvi/$year/${year}_flist_ndvi
flist_bq=$WRKDIR/nps/ndvi/$year/${year}_flist_bq

if [ ! -e $flist_ndvi ] ;then

exit 1

fi 

#3.make the single file for each composite day

echo stack one year data files started at `date -u`

$script_dir/1yr_emodis_250_stack.bash $flist_ndvi $flist_bq 0 0 0 0 

#4.calculate ndvi metrics

echo calculate ndvi-metrics started at `date -u`

$script_dir/1yr_emodis_250_calmetrics_v2.bash $WRKDIR/nps/ndvi/$year/${year}_oneyear_subset_good


echo calculate ndvi-metrics ended at `date -u`

#5.copy smoothed data file and ndvi-metrics file from $work_dir to $rawdata_dir/$year

cp $work_dir/$year/$year* $rawdata_dir/$year

mv -r $work_dir/$year

echo copy ndvi-metrics and smooth data back to rawdata directory ended at `date -u`
  
exit
