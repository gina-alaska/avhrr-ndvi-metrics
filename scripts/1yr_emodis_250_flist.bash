#!/bin/bash
#this script inputs: unzip_data_home_dir, year;
#outputs:two file lists, one is $year_flist_ndvi, another is $year_flist_ndvi_bq in $unzip_data_home/$year

if [ $# != 2 ]; then 

echo
echo "this script take one parameter: raw data directory"
echo
exit 1

fi

unzip_data_home_dir=$1

year=$2

dir_tmp=$unzip_data_home_dir/$year

if [ ! -d "$dir_tmp" ]; then
echo
echo "Your input raw data directory does not exist"
echo
exit 1
fi 

cd $dir_tmp

ls $PWD/*.VI_NDVI.*.tif>${year}_flist_ndvi
ls $PWD/*.VI_QUAL.*.tif>${year}_flist_bq

exit 0


