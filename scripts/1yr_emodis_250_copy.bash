#!/bin/bash
#copy one year of emaodis 250m data to $WRKDIR/nps/ndvi


year=$1

source ./1yr_emodis_250_env.bash

org=$rawdata_dir

#org=/projects/UAFGINA/project_data/emodis/distribution/Alaska/historical/TERRA


des=$work_dir/$year

mkdir -p $des

tmpdir=$org/$year


cd $des

find $tmpdir -type d -name "comp_???" > dlist

for d in $(cat dlist); do
   echo "copy $d/*NDVI*.QKM*.zip to $des and unzip it..."

  ffname=`ls $d/*NDVI*.QKM*.zip` 
 
  fbname=`basename $ffname`

  cp $ffname $des

  unzip $fbname


done

echo "finish copying and unzipping the files!"


