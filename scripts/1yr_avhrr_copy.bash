#!/bin/bash
#copy one year of emaodis 250m data to $WRKDIR/nps/ndvi


year=$1

source ./1yr_avhrr_env.bash

org=$rawdata_dir

#org=/projects/UAFGINA/project_data/emodis/distribution/Alaska/historical/TERRA


des=$work_dir/$year

mkdir -p $des

tmpdir=$org/$year


cd $des

if [ ! -e $des/*.tar ];then

find $tmpdir -type f -name "*.tar" > tarlist

for f in $(cat tarlist); do

fbase=`basename $f`

#   echo "copy $d/*NDVI*.QKM*.zip to $des and unzip it..."

#  ffname=`ls $d/*NDVI*.QKM*.zip` 
 
#  fbname=`basename $ffname`

#  cp $ffname $des

#  unzip $fbname

cp $f .

tar -xvf $des/$fbase

done

fi

echo "finish copying and unzipping the files!"


