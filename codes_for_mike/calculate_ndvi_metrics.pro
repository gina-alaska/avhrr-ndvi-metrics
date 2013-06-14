;This program calculate ndvi metrics from processed multiyear smoothes data file named "multiyear_layer_stack_smoothed"
;input:filen 
;output: one-year ndvi metrics

pro calculate_ndvi_metrics, fieln


;--- inputs

;wrkdir='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/'

filen='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/multiyear_layer_stack_1_smoothed'

p =strpos(filen,'/',/reverse_search)

len=strlen(filen)

wrkdir=strmid(filen,0,p+1)

filebasen=strmid(filen,p+1,len-p)

year=strmid(filen, len-4,4)


fileoutn=wrkdir+filebasen+'_metrics'

; initial envi environment

start_batch, wrkdir+'b_log',b_unit

;---- read in the image file

fn=' '
fid=0
dims=0
nb=0
fn=wrkdir+filen

ENVI_OPEN_FILE,fn,R_FID=fid
if (fid EQ -1) then return

envi_file_query,fid,dims=dims,nb=nb,nl=nl,ns=ns,data_type=data_type,bnames=bnames,interleave=interleave,offset=offset

;---- process data----------

;BSQ (samples,lines,bands)

data=intarr(ns,nl,nb)  ; used to store original data  

data_metrics=fltarr(ns,nl,15) ; data_metrics used to store metrics, 

;----j is pos, that is band sequence

for j=0L, nb-1 do begin

data(*,*,j) = ENVI_GET_DATA(DIMS=dims, FID=fid, POS=j) 

endfor


;--- process each spectruam at pixel(j,i)


for j=0l, ns-1 do begin

for i=0l, nl-1 do begin


;----- intepolate data

;----fill value is -2,000, replace with linear inpepolate value

tmp = transpose(data(j,i,*))

;---- for 7day per period, it has 52 period per year,before calcualte, interpol beginning and ending missing values

stbn=bnames[0]
edbn=bnames[n_elements(bnames) -1]

stday=strmid(stbn,5,3) 
edday=strmid(edbn,9,3)

st_num=fix( (fix(stday)-1)/7.0 )
 
ed_num=fix( (365-(fix(edday)+1) )/7.0 )


tmp52=intarr(st_num+nb+ed_num) ; used to store one year time series data

tmpnan=tmp52 ; used to store inerpolated vector


;len=n_elements(tmp)

 ;tmpnan is used to store data which converts fill value to NaN


;---in order to keep begining and ending correct, replace -2000 values with the first valid value for begin and end

;--- change fill value of -2000 into NaN

threshold = -2000 ; even use threshold = 0, nornal use -2000.0

idx = where(tmp LE threshold, cnt, complement=idxv)

if cnt GE 1 then begin

;get mean of first and last valid as fill value for 1-28, 223-365 days

num_idxv =n_elements(idxv)

fillv=fix( mean([tmp(idxv(0)),tmp(idxv(num_idxv-1)) ] ) ) 

tmp52[0:st_num-1]=fillv
tmp52[st_num:st_num+nb-1]=tmp
tmp52[st_num+nb:st_num+nb+ed_num-1]=fillv

;if idx(0) LT idxv(0) then begin

;tmp(idx(0):idxv(0)-1 ) =tmp( idxv(0) ) ; fro the begin to the first valid ,fill the first valid value

;endif

;edidxv=idxv(n_elements(idxv)-1)

;if idx(n_elements(idx)-1) GT edidxv then begin

;tmp( edidxv+1:idx(n_elements(idx)-1)) =tmp(edidxv)

;endif


;---- after fill valid values to beginning and ending, ro do check -2000 once


idx = where(tmp52 LE threshold, cnt, complement=idxv)


tmpx=fix(idxv) ;x coordinates values of valid values
tmpv=tmp52(idxv) ; valid values

len=n_elements(tmp52)

tmpu=indgen(len) ; interpolated x coorinidates

tmpnan=interpol(tmpv,tmpx,tmpu) ;interpolate

endif else begin

tmpnan(*)=tmp(*)

endelse


;-----call user defined user_smoth.pro to calculate weight least square smooth  -----

user_smooth, tmpnan,vout

save,tmpnan,vout,filename='vv2.dat'

user_metrics, vout, tmpnan, vmetrics ; vout--smoothed vector, vorg--orginal vector, vmetrics--metrics

num_metrics=(size(vmetrics))(1)

data(j,i,0:num_metrics-1)=vmetrics

;----- call subroutine user_metrics.pro to calculate metrics

endfor

endfor


;---- output image file ---------

;fname = 'test.img' 
;openw, unit, fname, /get_lun 
;writeu, unit, data 
;free_lun, unit 
; 
; Write the ENVI header and  
; add the image to the Available 
; Bands List 
; 
;----- required keywords are data_type,interleave, nb,nl,ns,offset
;ENVI_SETUP_HEAD, fname=fname, $ 
;  ns=ns, nl=nl, nb=nb,dims=dims, $ 
;  interleave=interleave, data_type=data_type, $ 
;  offset=offset, /write

;---output file

;--- get the map_info from fid

map_info=envi_get_map_info(fid=fid)


fileout=wrkdir+filen+'_metrics'

ENVI_WRITE_ENVI_FILE,data_metrics,out_name= fileout,data_type=data_type,map_info=map_info,$
                     nb=nb,ns=ns,nl=nl,offset=offset,interleave=interleave

;---- exit batch mode

ENVI_BATCH_EXIT

print,'finishing calculation of metrics ...'

end