;this program produce one-year-stacked ndvi data.
;inputs: datadir, wrkdir,year,ul_lon,ul_lat,lr_lon,lr_lat
;if do not need subsize data, ul_lon=0,ul_lat=0,lr_lon=0, and lr_lat=0
;outputs: one-year-stacked ndvi data stored at wrkdir 

;example inputs:
;datadir='/raid/scratch/cesu/eMODIS/ver_new_201110'
;wkdir='/raid/scratch/cesu/eMODIS/ver_new_201110'
;year='2008'
;ul=0
;lr=0


pro one_year_stacked_data, datadir, wrkdir, year,ul_lon,ul_lat,lr_lon,lr_lat

cd, wrkdir

;----produce two one-year file lists.

one_year_flist,datadir,wrdir,year

flist_ndvi='flist_ndvi'
flist_bq='flist_bq'

;---- call oneyear_data_layer_subset_good

;---- subset coorninates-------------
;----subsize spatial extent in upper left lon and lat and lower right lon and lat, decided by SWAN
;
;ul_lon=-160 & ul_lat=62
;lr_lon=-146 & lr_lat=56


;------ open envi-----

start_batch,'b_log',b_unit


oneyear_data_layer_subset_good_ver9, flist1,flist2,ul_lon,ul_lat,lr_lon,lr_lat


envi_batch_exit

print,'finish producing '+year+' one-year-stacked data!'

return

end

