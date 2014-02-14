;This program process a vector, it get rid of no-sense point such as -2000 (80), intepolate with adjunct points
;This program do not call oneyear_extension, that means do not interpolate jan,nov,and dec into feb to oct data series
;do interpolate, interpolate threshold, if all time series are threshold values, means this pixel is not vegitation, perhaps water, do not calcualte metrics of this pixel
;threshold is fill value, do not do interpolate, snowcld=60, need interpolate, for points with 81-100, need interpolate
 

pro avhrr_interpol_noextension_1yr, v_ndvi, v_bq, v_cldm, v_bn,v_ndvi_interp,v_bq_interp,v_cldm_interp,v_bn_interp,stnum,ednum,flg_metrics

;input: v_ndvi,v_bq, v_cldm, v_bn,
;output: v_ndvi_interp, v_bq_interp,v_cldm_interp,v_bn_interp,stnum,ednum,flg_metrics
;v_bq 1-good, 0-bad,
;v_cldm <100, clearl >=100, cloudy
;v_ndvi, 0-200
;flg_metrics=0, -1 no data, 0= not valid data, 1-vaild metrics
;
;----determine if we calculate ndvi metrics
cloudy =100     ; cldmask <100, clear; >=100, cloud
qq_bad=0        ;bad quality
qa_good=15      ;>=15,good quality 
ndvi_low=100   ; minimum valid ndvi value    
flg_metrics= 0 ; initial not calculate metrics 
num_chk =3     ; check at leat there thare num_chk points with NDVI value greater than ndvi_chk, for eMODIS, uses 5
ndvi_chk=125   ;check value, for eMODIS, use 125

;---check no data, if n_element(time_sries)= number of no_data, then set flg_metrics=-1

num=n_elements(v_ndvi)

idxdad=where(v_bq eq 0,cntbad)

if cntbad EQ num then begin 

v_ndvi_interp=v_ndvi

v_bq_interp=v_bq_interp 

v_cldm_interp=v_cldm

v_bn_interp=v_bn

flg_metrics=-1

return

endif

;---detemine the good points(they are good quality,clear sky, and ndvi value greater than 110), if the number of point >=5, then calculate metrics
;110 is determined by compare mean of maximun ndvi of AVHRR (0.68) with that of eMODIS (0.76), for eMODIS, we use 125 as cut-off value,
;so ndvi_chk=0.68*125/0.76=112.
;otherwise, do not calcualte metrics. If all data points are qa=0, it means ocean. set flg_metrics=-1, normal NDVI range is 100 to 200.

idxv=where((v_bq GE qa_good ) and  (v_cldm LT cloudy ) and v_ndvi GE ndvi_chk,cntv ) ; cntv-valid ndvi data, good quality and clear day

;num_chk is 5 for eMODIS (5/42), and 3 for AVHHR (3/28), otherwise, do not calculate metrics

mxidx_chk=0

if cntv GE num_chk then begin

;add a new condition that maximun NDVI point must be in between the 20% of maximu start and end points

mxv=max(v_ndvi(idxv))

idxmx=where(v_ndvi EQ mxv,cntmx )

if cntmx GT 1 then begin

  idxmxst=idxmx(0)

  idxmxed=idxmx(cntmx-1)

endif else begin

  idxmxst=idxmx(0)
  
  idxmxed=idxmx(0)
   
endelse
  
idx20p=where(v_ndvi-100 GE 0.2*(mxv-100),cnt)

stidx20p=idx20p(0)

edidx20p=idx20p(n_elements(idx20p)-1)

num=n_elements(v_ndvi)

if stidx20p EQ 0 or edidx20p EQ num-1 then begin

if (idxmxst GT 2) and (idxmxed LT num - 3) then begin
  
  mxidx_chk=1

endif else begin

  mxidx_chk=0

endelse

endif else begin

;  if (idxmxst GE stidx20p + 1) and (idxmxed LE edidx20p - 1) then begin

  
  mxidx_chk=1

;endif else begin
;  mxidx_chk=0
;endelse
  
  
endelse

endif

if mxidx_chk EQ 1 and cntv GE num_chk then begin 
  
;if cntv GT num_chk then begin

cutoff_interp_v4,v_ndvi,v_bq,v_cldm,v_ndvi_g,flg_metrics  ; cutoff_interp, first change bad value into 100, then cut off less than 100 data,

;----- output interpolated data
v_ndvi_interp=v_ndvi_g

v_bq_interp=v_bq

v_cldm_interp=v_cldm

v_bn_interp=v_bn

return

endif else begin

flg_metrics=0

v_ndvi_interp=v_ndvi

v_bq_interp=v_bq

v_cldm_interp=v_cldm

v_bn_interp=v_bn

return

endelse

end