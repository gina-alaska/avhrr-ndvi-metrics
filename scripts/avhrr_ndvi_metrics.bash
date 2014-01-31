######!/bin/bash
#this script accept two input files: ak_yyyy_nd, ak_yyyy_nd_sm, calculate avhrr ndvi metrics, output the metrics data file in the same directory where input files is

# 0. check if user input correct data files

if [ $# != 2 ];then
echo "Usage: avhrr_ndvi_metrics.bash full_path_file_name_nd, full_path_file_name_nd_sm"
exit 1
fi

nd_file=$1
nd_sm_file=$2

# 1. Define directories
#avhrr_home_dir=$wher_avhrr_ndvi_is
avhrr_home_dir=~/nps/cesu/avhrr_ndvi_window

#avhrr_data_dir=$where_avhrr_ndvi_data_is (ak_nd_1982,ak_nd_1982_sm)
avhrr_data_dir=/u1/uaf/jzhu/nps/cesu/avhrr_ndvi_window/data1

#avhrr_prog_dir=$whre_avhrr_ndvi_idl_program_is
avhrr_prog_dir=$avhrr_home_dir/avhrr-ndvi-metrics

#avhrr_scrpt_dir=$where_avhrr_ndvi_script_is
avhrr_script_dir=$avhrr_home_dir/scripts

# 2. set up environment variables

export IDL_STARTUP=$avhrr_home_dir/startup_nps

# 3. run idl program

/usr/local/pkg/idl/idl-7.1/idl71/bin/idl <<EOF
restore, filename='$avhrr_prog_dir/avhrr_ndvi_metrics.sav'
avhrr_calculate_ndvi_metrics_tile, '$nd_file', '$nd_sm_file'
exit
EOF

exit
