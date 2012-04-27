;Jinag Zhu, jiang@gina.alaska.edu, 2/22/2011
;This program interpolates and smoothes a multiyear_layer_stack file and calculate metrics of mid-year data.
;The input is:a oneyear_stack file
;the output is:
;a mid-year smoothed data file named multiyear_layer_stack_smoothed,
;a metrics file named multiyear_layer_stack_smoothed_metrics.
;flg indicating if this program run successfully.

;This program breaks the huge data into tiles and goes through tile loop to proces each tile. For each tile, go through
;each pixel to calulate the metrics and smoothed time series of the pixel. 
;jzhu, 1/17/2012,this program combines moving average and threshold methodm it calls geoget_ver16.pro and sosget_ver16.pro. 

pro smooth_calculate_metrics_tile_ver9,filen,flg

;flg (indicate if the program run successful, 0--successful, 1--not successful)
;---- initial envi,
;test only, input parameters

;---make sure the program can work in both windows and linux.

if !version.OS_FAMILY EQ 'Windows' then begin

sign='\'

endif else begin
sign='/'

endelse

;----produces output file names: smooth data file name and metrics file name.

p =strpos(filen,sign,/reverse_search)

len=strlen(filen)

wrkdir=strmid(filen,0,p+1)

filebasen=strmid(filen,p+1,len-p)

year=strmid(filebasen,0,4)

;----open smooth file and metrics file to ready to be writen.

fileout_smooth=wrkdir+filebasen+'_smooth'

openw,unit_smooth,fileout_smooth,/get_lun

fileout_metrics=wrkdir+filebasen+'_metrics'

openw,unit_metrics,fileout_metrics,/get_lun

;---start ENVI batch mode
 
start_batch, wrkdir+'b_log',b_unit

;---setup a flag to inducate this program work successful. flg=0, successful, flg=1, not successful

flg=0;  0----successs, 1--- not sucess


;---open the input file

envi_open_file,filen,/NO_REALIZE,r_fid=rt_fid


if rt_fid EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;envi_select,fid=rt_fid,pos=pos,dims=dims

;envi_file_query,rt_fid,dims=dims,nb=nb,ns=ns,nl=nl,fname=fn,bnames=bnames

;---get the information of the input file

envi_file_query, rt_fid,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames

pos=lindgen(nb)

;---inital tile process

  tile_id = envi_init_tile(rt_fid, pos, num_tiles=num_of_tiles, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )


;---define a data buff to store the band names of the metrics

bnames_metrics = ['onp','onv','endp','endv','durp','maxp','maxv','ranv','rtup','rtdn','tindvi','mflg']

;---define the fill value for mising pixel, and fill value for snow, cloud, bad, and negative reflectance pixel.

threshold = 80b ; fill value is -2000, after convert into 0-200, this value is equal to 80

snowcld = 60b ; snow and cloud are set into -4000, after convert into 0-200, they are 60

;---tile loop, goes through each tile to process

for i=0l, num_of_tiles-1 do begin  ; every line

;data=envi_get_slice(/BIL,fid=rt_fid,line=i)

data = envi_get_tile(tile_id, i)
  
sz=size(data)

num_band=sz(2) ; number of points in a time-series vector

;---time-series-vector loop, process each time-series-vector in the tile i

for j=0l, sz(1)-1 do begin

;---print out the information about which tile and which time-series vector is being processed.

print, 'process tile: '+strtrim(string(i),2), ', sample: '+strtrim(string(j),2)




;--- convert a time-series data into a vector

tmp=transpose(data(j,*) ) ; band vector

bname=bnames(0:num_band/2-1)

;if i EQ  0  and j EQ 8738 then begin
;print, 'test'
;endif



;---calls time_series_process to do three-year data interpolate, smooth, and calculate metrics

;time_series_process_nps,tmp,bnames,threshold,snowcld,mid_interp,mid_smooth,mid_bname,vmetrics

;---calls time_series_process_nps_oneyear.pro to do one-year data interpolate, smooth, and calculate metrics

time_series_process_nps_oneyear_ver9,tmp,bname,threshold,snowcld,mid_interp,mid_smooth,mid_bname,vmetrics

;---define data_smoothed to store smoothed data if it is the first time-series vector process

if j EQ 0l then begin  ; the very first sample loop, only execuated once

nb_smooth =n_elements(mid_smooth)

bnames_smooth=mid_bname

data_smooth=bytarr(sz(1),nb_smooth)

nb_metrics=n_elements(vmetrics)

data_metrics=fltarr(sz(1),nb_metrics)

endif

data_smooth(j,*) = byte(round(mid_smooth) )

data_metrics(j,*) = vmetrics


endfor  ; sample loop

;---write data_smooth of one tile

writeu,unit_smooth,data_smooth

writeu,unit_metrics,data_metrics


endfor  ; line loop

;---close files

free_lun, unit_smooth

free_lun, unit_metrics


;---output head info file for smooth data

map_info=envi_get_map_info(fid=rt_fid)

;---output smooth data

;fileout_smoothed = wrkdir+filebasen+'_smoothed'
;ENVI_WRITE_ENVI_FILE,data_smooth,out_name= fileout_smoothed,map_info=map_info,bnames= bnames_smooth,$
;                     ns=ns,nl=nl,nb=nb_smooth

data_type=1 ; btye type for smooth

envi_setup_head, fname=fileout_smooth, ns=ns, nl=nl, nb=nb_smooth,bnames=bnames_smooth, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one year smoothed data', /write


;---output head info for metrics data

;sz =size(data_metrics)
;metrics_ns=sz(1)
;metrics_nl=sz(2)
;metrics_nb=sz(3)

;fileout_metrics=wrkdir+filebasen+'_metrics'

;ENVI_WRITE_ENVI_FILE,data_metrics,out_name= fileout_metrics,map_info=map_info,bnames=data_metrics_bnames,$
;                     ns=metrics_ns,nl=metrics_nl,nb=metrics_nb


data_type=4 ; float for metrics

envi_setup_head, fname=fileout_metrics, ns=ns, nl=nl, nb=nb_metrics,bnames=bnames_metrics, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one year metrics data', /write


envi_tile_done, tile_id

;---- exit batch mode

ENVI_BATCH_EXIT

print,'finishing smooth and calculation of metrics ...'

return

end

