AVHRR NDVI metrics Algorithm Explaination:

1. program running environment:

   IDL+ENVI
  
   set environmental variable in ~/.bashrc 

   export IDL_STARTUP=$directory_where_"startup_nps"_is/startup_nps

 
2. process to run avhrr_ndvi_metrics program
  
   inputs: one-year-raw-ndvi file (ak_nd_1982) and one-year-smoothed-ndvi file (ak_nd_1982_sm)
  
   program: avhrr_calculate_ndvi_metrics_tile.pro
  
   to run the program in linux:
    
   cd ~/nps/cesu/avhrr_ndvi

   ./scripts/avhrr_ndvi_metrics.bash
          
   output: metrics file (ak_nd_1982_metrics)

   avhrr_ndvi_metrics.bash



3. Algorithm explaination

detail algorthm explaination is referred to "ndvi_metrics_algorithm_doc_201201.docx"

