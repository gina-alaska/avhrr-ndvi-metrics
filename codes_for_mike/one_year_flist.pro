;this program accepts user's inputs: data_dir, wrk_dir, year, produces two one-year file lists: flist_ndvi,flist_bq in wrk_dir.
; flist_ndvi includes one-year NDVI file names, and flist_bq includes NDVI_bq file names.

;example inputs:
;data_dir='/raid/scratch/cesu/eMODIS/ver_new_201110'
;wrk_dir='/raid/scratch/cesu/eMODIS/ver_new_201110'
;year='2008'

pro one_year_flist, data_dir, wrkdir,year

if !version.os_family EQ 'Windows' then begin
cmd ='dir /s/B '
sign='\'
endif else begin
cmd='ls '
sign='/'
endelse

;---- profuce two file lists

flist1=wrkdir+sign+year+'_flist_ndvi'

flist2=wrkdir+sign+year+'_flist_ndvi_bq'

cmd_ndvi= cmd+data_dir+sign+year+sign+'*VI_NDVI*.tif >'+flist1

cmd_ndvi_bq = cmd+data_dir+sign+year+sign+'*VI_QUAL*.tif >'+flist2

spawn,cmd_ndvi

spawn,cmd_ndvi_bq

return

end
