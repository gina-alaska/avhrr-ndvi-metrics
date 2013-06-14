;THis program batch proccess one year data and produces ndvi metircs

data_dir = '/home/jiang/scratch/EMODIS-NDVI-DATA/wrk/ver_old'

wrk_dir  = '/home/jiang/scratch/EMODIS-NDVI-DATA/wrk/ver_old'

year='2008'

;---- produce two file lists

one_year_flist, data_dir, wrk_dir,year,flist1,flist2

if !version.os_family EQ 'Windows' then begin
cmd='dir /s/B '
sign='\'
endif else begin
cmd='ls '
sign='/'
endelse



;---- produces one-year-stack data file

ul=0 & lr=0  ; 0 indicates do not subsize

;ul=[-206833.75D, 1303877.50D]
;lr=[ 424916.25D,  856877.50D]
;flist1=wrkdir+'flist_ndvi_'+year
;flist2=wrkdir+'flist_ndvi_bq_'+year


;------ open envi-----

start_batch,'b_log',b_unit

oneyear_data_layer_subset_good,flist1,flist2,ul,lr

;---- produces a three-year stack data file

wrkdir=wrk_dir+sign+year

flistn=wrkdir+sign+year+'_oneyear_flist'

multiyear_layer_stack= wrkdir+sign+year+'_multiyear_layer_stack'

layer_stack, wrkdir, flistn, multiyear_layer_stack

;produce a year metrics file

smooth_calculate_metrics_tile,multiyear_layer_stack 

end
