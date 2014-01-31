#!/bin/bash
#multiple year process

ylist=$1   # command line define the year list in " yyyy1 yyyy2 yyyy3 ..." 

#ylist="2009 2011"


for y in $ylist

do
   echo "produceing $y ndvi metrics"

   ./1yr_avhrr_main_v2.bash $y

done

echo "finish $ylist NDVI metrics calculation!"

exit 0 
