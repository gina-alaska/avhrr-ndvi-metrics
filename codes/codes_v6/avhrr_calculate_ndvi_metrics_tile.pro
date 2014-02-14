;Jinag Zhu, jiang@gina.alaska.edu, 6/18/2013
;This program take three files (stacked_ndvi, stacked_bq, and stacked_cldm) as inputs.
;It do interpolate, smooth, and calculate metrics.
;the output is:
;a smoothed data file named YYYY_layer_stack_smoothed,
;a metrics file named YYYY_layer_stack_smoothed_metrics.
;flg indicating if this program run successfully.
;This program is modified from MODIS-detrived metrics algorithm.

pro avhrr_calculate_ndvi_metrics_tile,filen_ndvi,filen_bq, filen_cldm,ver,flg

;flg (indicate if the program run successful, 0--successful, 1--not successful)
;filen_ndvi, filen_bq, filen_cldm are AVHRR one-year-stacked files for ndvi, bq, and cldm, respectively.
;


filen_ndvi='/center/w/jzhu/nps/avhrr/usgs/2005/2005_stacked_ndvi'
filen_bq='/center/w/jzhu/nps/avhrr/usgs/2005/2005_stacked_bq'
filen_cldm='/center/w/jzhu/nps/avhrr/usgs/2005/2005_stacked_cldm'
ver='v6'
flg=0

;---make sure the program can work in both windows and linux.

if !version.OS_FAMILY EQ 'Windows' then begin

sign='\'

endif else begin
sign='/'

endelse

;----1. produces output metrics file name

p =strpos(filen_ndvi,sign,/reverse_search)

len=strlen(filen_ndvi)

wrkdir=strmid(filen_ndvi,0,p+1)

filebasen=strmid(filen_ndvi,p+1,len-p)

year=strmid(filebasen,0,4)

;----define output file name 

fileout_smooth=wrkdir+filebasen+'_smooth_'+ver

openw,unit_smooth,fileout_smooth,/get_lun

fileout_metrics=wrkdir+filebasen+'_metrics_'+ver

openw,unit_metrics,fileout_metrics,/get_lun

;---start ENVI batch mode
 
start_batch, wrkdir+'b_log',b_unit

;---setup a flag to inducate this program work successful. flg=0, successful, flg=1, not successful

flg=0;  0----successs, 1--- not sucess

;---2. open the input filen_ndvi

envi_open_file,filen_ndvi,/NO_REALIZE,r_fid=rt_fid_ndvi


if rt_fid_ndvi EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;---open the input filen_bq

envi_open_file,filen_bq,/NO_REALIZE,r_fid=rt_fid_bq


if rt_fid_bq EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;---open the input filen_cldm

envi_open_file,filen_cldm,/NO_REALIZE,r_fid=rt_fid_cldm


if rt_fid_cldm EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif




;---3. get the information of the input filen_ndvi

envi_file_query, rt_fid_ndvi,data_type=data_type, xstart=xstart_ndvi,ystart=ystart_ndvi,$
                 interleave=interleave_ndvi,dims=dims_ndvi,ns=ns_ndvi,nl=nl_ndvi,nb=nb_ndvi,bnames=bnames_ndvi

bnames_smooth = bnames_ndvi

pos=lindgen(nb_ndvi)

;---inital tile process

  tile_id_ndvi = envi_init_tile(rt_fid_ndvi, pos, num_tiles=num_of_tiles_ndvi, $
    interleave = (interleave_ndvi > 1), xs=dims_ndvi(1), xe=dims_ndvi(2), $
    ys=dims_ndvi(3), ye=dims_ndvi(4) )




;---- get the information of input file_bq

envi_file_query, rt_fid_bq,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

;---inital tile process

  tile_id_bq = envi_init_tile(rt_fid_bq, pos, num_tiles=num_of_tiles_bq, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )

;---- get the information of input file_cldm

envi_file_query, rt_fid_cldm,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

;---inital tile process

  tile_id_cldm = envi_init_tile(rt_fid_cldm, pos, num_tiles=num_of_tiles_cldm, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )


;---define a data buff to store the band names of the metrics

bnames_metrics = ['onp','onv','endp','endv','durp','maxp','maxv','ranv','rtup','rtdn','tindvi','mflg']

vmetrics=fltarr(12); use for store metrics

;----5. precess ecah time-series

for i=0l, num_of_tiles_ndvi-1 do begin  ; every line

;data=envi_get_slice(/BIL,fid=rt_fid,line=i)

data_ndvi = envi_get_tile(tile_id_ndvi, i)
data_bq   = envi_get_tile(tile_id_bq,   i)
data_cldm = envi_get_tile(tile_id_cldm, i) 

sz=size(data_ndvi)

num_band=sz(2) ; number of points in a time-series vector

;---produce bname for the time series

;bname = avhrr_produce_band_name(num_band, fix(year) )

;---time-series-vector loop, process each time-series-vector in the tile i

for j=0l, sz(1)-1 do begin

;---print out the information about which tile and which time-series vector is being processed.

print, 'process tile: '+strtrim(string(i),2) +' of '+strtrim(string( num_of_tiles_ndvi-1 ),2), $
       ', sample: '+strtrim(string(j),2) +' of '+ strtrim(string( sz(1)-1  ),2)




;--- convert a time-series data into a vector

tmp_ndvi=transpose(data_ndvi(j,*) ) ; band vector
tmp_bq  =transpose(data_bq(j,*) )
tmp_cldm=transpose(data_cldm(j,*) )
tmp_bn=bnames_smooth

if i EQ 436  and j EQ 694 then begin

print, 'test'

endif


;--calcualte ndvi metrics of the time series 
;--time series include 42 bands, band name will be like 19820101,19820111,19820121,19820201...
;
 avhrr_time_series_process,tmp_ndvi,tmp_bq, tmp_cldm, tmp_bn, vmetrics, vsmooth

;avhrr_time_series_process,tmp_ndvi,tmp_bq, tmp_cldm, tmp_bn, vmetrics, vsmooth

;---define data_smoothed to store smoothed data if it is the first time-series vector process

if i EQ 0 and j EQ 0l then begin  ; the very first sample loop, only execuated once

nb_smooth =n_elements(bnames_smooth)
data_smooth=bytarr(sz(1),nb_smooth)

nb_metrics=n_elements(vmetrics)
data_metrics=fltarr(sz(1),nb_metrics)

endif

;data_smooth(j,*) = byte(round(vsmooth) )

data_smooth(j,*) = vsmooth
data_metrics(j,*) = vmetrics

endfor  ; sample loop

writeu,unit_smooth,data_smooth

writeu,unit_metrics,data_metrics



endfor  ; line loop

;---close files

free_lun, unit_smooth

free_lun, unit_metrics


;---output head info file for smooth data

map_info=envi_get_map_info(fid=rt_fid_ndvi)

;---output smooth data

;fileout_smoothed = wrkdir+filebasen+'_smoothed'
;ENVI_WRITE_ENVI_FILE,data_smooth,out_name= fileout_smoothed,map_info=map_info,bnames= bnames_smooth,$
;                     ns=ns,nl=nl,nb=nb_smooth

data_type=1 ; btye type for smooth

envi_setup_head, fname=fileout_smooth, ns=ns_ndvi, nl=nl_ndvi, nb=nb_smooth,bnames=bnames_smooth, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year smoothed data', /write


;---output head info for metrics data

data_type=4 ; float for metrics

envi_setup_head, fname=fileout_metrics, ns=ns_ndvi, nl=nl_ndvi, nb=nb_metrics,bnames=bnames_metrics, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one year metrics data', /write



envi_tile_done, tile_id_ndvi

envi_tile_done, tile_id_bq

envi_tile_done, tile_id_cldm


;---- exit batch mode

ENVI_BATCH_EXIT

print,'finishing calculation of metrics ...'

return

end

