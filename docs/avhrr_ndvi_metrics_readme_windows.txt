AVHRR NDVI metrics Algorithm running in windows such as windows 7


1. Preparation:


a. copy avhrr_ndvi and its subdirectories and all files in the dir_your_choice
 
in my case, dir_your_choice=C:\Users\jiang\Documents\work\nps


In order to program the runs in IDL+ENVI development environment, you have to setup  an environment variable:IDL_STARTUP, and edit the startup_nps file.

b. set system environmental variable

start->control panel->system->Advanced system settings->Environment Variables:

new a variable:IDL_STARTUP, make its value equal to $dir_where_your_start_nps_is

for example, in my case, I set the value as 

C:\Users\jiang\Documents\work\nps\avhrr_ndvi\startup_nps

 

































c. edit the startup_nps file

The startup_nps file looks like:
#########################################################
ENVI, /RESTORE_BASE_SAVE_FILES
PREF_SET, 'IDL_PATH', '<IDL_DEFAULT>;+dir_where_avhrr_ndvi_is', /COMMIT
#########################################################

replace “dir_where_avhrr_ndvi_is” to your directory where the avhrr_ndvi is. In my case, “C:\Users\jiang\Documents\work\nps\avhrr_ndvi”

Please keep the “+” right before the “dir_where_avhrr_ndvi_is”
 






 
2. run avhrr_calulate_ndvi_metrics_tile program
  
double click IDL to start the IDLDE

in the idl command line, run following commands:

restore,'dir_your_choice/avhrr_ndvi/sav/avhrr_calculate_ndvi_metrics_tile.sav'
filen='dir_your_choice/avhrr_ndvi/data/ak_nd_1982'

filen_sm='dir_your_choice/avhrr_ndvi/data/ak_nd_1982sm'

avhrr_calculate_ndvi_metrics_tile, filen,filen_sm



3. Algorithm explaination

detail algorthm explaination is referred to "ndvi_metrics_algorithm_doc_201201.docx"

