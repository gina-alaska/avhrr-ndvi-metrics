#!/bin/bash
#this script produces an one-year-stack-good ndvi file
#inputs: flist_ndvi, flist_qa, flist_cldmask,ul_lon,ul_lat,lr_lon,lr_lat
#output:one-year-stack-good file
#example inputs:
#flist_ndvi='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2010/2010_flist_ndvi'
#flist_qa = '/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2010/2010_flist_bq'
#flist_cldmask=' '
#ul_lon=-173.0d,ul_lat=72.0d
#lr_lon=-127.999116667d,lr_lat=54.000019444d
#if do not want subsize, input: 0,0,0,0 for four conor cooordinates


#check if input parameters are correct

source ./1yr_avhrr_env.bash

if [ $# != 7 ];then
echo
echo "input flist_ndvi,flist_bq,flist_cldm,ul_lon,ul_lat,lr_lon,lr_lat"
echo
exit 1
fi

flist_ndvi=$1
flist_bq=$2
flist_cldm=$3
ul_lon=$4
ul_lat=$5
lr_lon=$6
lr_lat=$7

#stack one year of data

$idl_dir/idl<<EOF
restore,filename='/u1/uaf/jzhu/nps/cesu/avhrr_usgs_ndvi/sav/codes_v5.sav'
avhrr_stack_oneyear_data, '$flist_ndvi','$flist_bq','$flist_cldm','$ul_lon','$ul_lat', '$lr_lon','$lr_lat'
exit
EOF

exit 0  


