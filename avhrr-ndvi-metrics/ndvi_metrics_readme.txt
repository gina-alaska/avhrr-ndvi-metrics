NDVI metrics Algorithm Explaination:


A. Algorithm process steps
 

1. unzip the ndvi files ($script)
 
  ndvi files comes from EMODIS website. download them and store 
  them in ~/nps/cesu/modis_ndvi_250m/TERRA. They are zip files.

  The scripts to unzip them is: 

  unzip_ndvi_v2.bash

2. stack and subset 7-day data files of one year, and keep only good data into one-year data
     
 inputs: file list of monthly ndvi file of one year,
         file list of monthly ndvi_bq files of the same year
 
 program:  oneyear_data_layer_subset_good_ver9.pro
   
 subroutines: start_batch.pro,read_ndvi_ver9.pro,subset.pro

 outputs: "yyyy_oneyear_layer_subset_good"       
 
3. stack three one-year data files into a three-year data file (optional)
  
   inputs: file list of one-year good data files, normally three sequency years  
   
   program: layer_stack.pro
     
   subroutines: start_batch.pro
  
   outputs: a multiple year (normally 3 years) stacked data file named: "yyyy_multiyear_layer_stack"

4. calculate one-year metrics
  
   inputs: a one-year or three-year data file
  
   program: smooth_calculate_metrics_tile_ver9.pro
          
   outputs: "yyyy_oneyear_layer_subset_good_smooth" and "yyyy_oneyear_layer_subset_good_metrics"


B. Algorithm explaination in detail

detail algorthm explaination is included in ../docs/"ndvi_metrics_algorithm_doc_201201.docx"















  
 
