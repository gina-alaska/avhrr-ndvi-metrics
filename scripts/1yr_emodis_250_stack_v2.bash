#!/bin/bash
#this script produces an one-year-stack-good ndvi file
#inputs: flist_ndvi, flist_bq, ul_lon,ul_lat,lr_lon,lr_lat
#output:one-year-stack-good file
#example inputs:
#flist_ndvi='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2010/2010_flist_ndvi'
#flist_bq = '/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2010/2010_flist_bq'
#ul_lon=-173.0d,ul_lat=72.0d
#lr_lon=-127.999116667d,lr_lat=54.000019444d
#if do not want subsize, input: 0,0,0,0 for four conor cooordinates


#check if input parameters are correct

source ./1yr_emodis_250_env.bash

if [ $# != 6 ];then
echo
echo "input flist_ndvi and flist_bq ul_lon ul_lat lr_lon lr_lat"
echo
exit 1
fi

flist_ndvi=$1
flist_bq=$2
ul_lon=$3
ul_lat=$4
lr_lon=$5
lr_lat=$6


#/usr/local/pkg/idl/idl-7.1/idl71/bin/idl <<EOF
#idl<<EOF
#/usr/local/pkg/idl/idl-8.2/idl/bin/idl<<EOF

$idl_dir/idl<<EOF
restore,filename='/u1/uaf/jzhu/nps/cesu/modis_ndvi_metrics/sav/codes.sav'
oneyear_data_layer_subset_good, '$flist_ndvi','$flist_bq','$ul_lon','$ul_lat', '$lr_lon','$lr_lat'
exit
EOF

#idl<<EOF
#tst,'$flist_ndvi','$flist_bq','$ul_lon','$ul_lat','$lr_lon','$lr_lat'
#EOF

exit 0  


