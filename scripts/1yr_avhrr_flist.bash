#!/bin/bash
#this script inputs: unzip_data_home_dir, year;
#outputs:three file lists, they are $yyyy_flist_ndvi, $yyyy_flist_qa, $yyyy_flist_cldmask in $unzip_data_home/$year

if [ $# != 2 ]; then 

echo
echo "this script take two parameter: raw data main directory, year "
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

#if necesary, unzip the files

flist_tar=`ls *.tar`

for file in $flist_tar; do

file_prex=${file:0:15}

file_ndvi="${file_prex}_ndvi.tif"

if [ -e $file_ndvi ]; then

  echo "already done untar"
else
  tar -xvf $file
fi

done

ls $PWD/*_ndvi.tif>${year}_flist_ndvi
ls $PWD/*_qa.tif>${year}_flist_bq
ls $PWD/*_cldmask.tif>${year}_flist_cldm

exit 0


