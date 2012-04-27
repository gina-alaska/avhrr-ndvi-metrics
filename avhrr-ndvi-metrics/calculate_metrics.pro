;This program calculate the metrics from input file of multiyear_layer_stack_smoothed file
;input: threeyear_layer_stack_smoothed file
;output: one-year metrics data of the middle year


pro calculate_metrics, filen

;input: filen---multiple-year file, ready to smooth, output file name is filen+'_metrics'

;---- initial envi, 
;test input parameters

filen = '/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/multiyear_layer_stack_1_smoothed'

p =strpos(filen,'/',/reverse_search)

len=strlen(filen)

wrkdir=strmid(filen,0,p+1)

filebasen=strmid(filen,p+1,len-p)

year=strmid(filen, len-4,4)


start_batch, wrkdir+'b_log',b_unit




flg=0;  0----successs, 1--- not sucess






envi_open_file,filen,r_fid=rt_fid


if rt_fid EQ 0 then begin 

flg=1  ; 0---success, 1--- not success

return  ; 

endif

envi_file_query,rt_fid,dims=dims,nb=nb,ns=ns,nl=nl,fname=fn,bnames=bnames

;---- read each slice to process

data_metrics=fltarr(ns,nl,12) ; 12 metrics stored in 13 bands for each pixel
 
data_metrics_bnames=['onp','onv','endp','endv','durp','maxp','maxv','ranv','rtup','rtdn','tindvi','mflg']

data=intarr(ns,nb) ; BIL format (num of samples, num of bands)


;----j=ns, i=nl, k=nb

for i=0l, nl-1 do begin  ; every line

data=envi_get_slice(/BIL,fid=rt_fid,line=i)

for j=0l, ns-1 do begin

;---- one spectrum process

print, ' process sample:'+strtrim(string(j),2), ', line:'+strtrim(string(i),2)


tmp=transpose(data(j,*) ) ; band vector, alread smoothed 

idx_mid = where(strmid(bnames,0,1) EQ 1 )

mid_year_bn=bnames(idx_mid)


mid_year_smooth=tmp(idx_mid)

;---- use smooth data to replace original data, if neccesary, we may change into orginal data

mid_year_interp=tmp(idx_mid)


user_metrics, mid_year_smooth, mid_year_interp, mid_year_bn, vmetrics ; vout--smoothed vector, vorg--orginal vector, vmetrics--metrics

num_out=n_elements(vmetrics)

data_metrics(j,i,0:num_out-1)=vmetrics


endfor  ; sample loop

endfor  ; line loop

;-----output metrics


map_info=envi_get_map_info(fid=rt_fid)
sz =size(data_metrics)
metrics_ns=sz(1)
metrics_nl=sz(2)
metrics_nb=sz(3)

fileout=wrkdir+filebasen+'_metrics'

ENVI_WRITE_ENVI_FILE,data_metrics,out_name= fileout,map_info=map_info,bnames=data_metrics_bnames,$
                     ns=metrics_ns,nl=metrics_nl,nb=metrics_nb
                     

;---- exit batch mode

ENVI_BATCH_EXIT

print,'finishing the calculation of ndvi metrics ...'

return

end

