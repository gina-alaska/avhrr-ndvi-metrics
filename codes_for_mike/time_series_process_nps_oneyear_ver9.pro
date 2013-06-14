;jiang Zhu, 2/17/2011,jiang@gina.alaska.edu
;This program calls subroutines to interpolate a three-year time-series data,
;smooth mid-year time-series data, and calculate the metrics for the mid-year time-series data.
;The inputs are: 
;tmp (three-year-time-series-cvector), 
;bnames (three-year-time-series-vector name),
;threshold (fill value for no data, 60b),
;snowcld (fill value for snow and cloud, 60b),
;outputs are:
;mid_interp (mid-year interpolated vector),
;mid_smooth (mod-year smoothed vector),
;mid_bname (mid-year smoothed vector's band names),
;vmetrics (mid-year metrics).
 
;jzhu, 5/5/2011, use the program provided by Amy to do moving smooth and calculate the crossover
 
;jzhu, 9/8/2011, ver9 processes the one-year-stacking file which includes ndvi and bq together.  

pro time_series_process_nps_oneyear_ver9,tmp,bnames,threshold,snowcld,mid_interp,mid_smooth,mid_bname,vmetrics

a=-100
sfactor=0.01
ratio=0.3  ;number of valid points(not threshold or snowcld) of mid_year/number of total points of mid_year
metrics_cal_threshold=0.4 ;when ndvi is less than metrics_cal_threshold, do not calculate metrics
flg_metrics=0 ; 0---not calculate metrics
stnum=3  ; make first stnum points up
ednum=3  ; make last ednum points up

tmp_bn='1_'+ bnames  ; add "1." in front of elements


;---- calls interpol_extension_1y_vector_ver9.pro to process one-year data, do one-year vector extension, then inpterpolate

interpol_noextension_1y_vector_ver9,tmp,tmp_bn,threshold,snowcld,tmp_interp,tmp_bq,tmp_bn,ratio,stnum_real,ednum_real,flg_metrics

goto,lb_11
;-------------- determine if we calculate metrics

flg_metrics= 0 ; initial not calculate metrics 
numofmidyrcb=n_elements(tmp)
numofmidyr=numofmidyrcb/2
;--- the first half of numofmidyr ndvi vector, the second half of nunofmidyr is bq vector
tmp_interp=tmp(0:numofmidyrcb/2 -1)
tmp_bq=tmp(numofmidyrcb/2:numofmidyrcb-1)

;----- for fill pixels, do not calculate ndvi, just extend the band name to one year ---

idx10=where(tmp_bq EQ 10b or tmp_bq EQ 2b,cnt10) ; fill or bad points
if cnt10 EQ numofmidyr then begin   ; fill pixels
flg_metrics=-1
endif else begin
idxv=where( (tmp_bq EQ 0b or tmp_bq EQ 4b ) and tmp_interp GT 100b, cntv )
if cntv GT 5 then begin  ; number of valid point > 5, calculate metrics 
flg_metrics=1
endif

endelse

;-------------------------

lb_11:

if flg_metrics EQ 0 or flg_metrics EQ -1 then begin  ; no not calculate metrics
mid_interp=tmp_interp
mid_smooth=tmp_interp
mid_bq =tmp_bq
mid_bname=tmp_bn
vmetrics =fltarr(12) ; if do not calculate metrics, set every element = 0.0
vmetrics(*)=flg_metrics
return

endif else begin  


;----- calculate metrics-----------------------------

wls_smooth, tmp_interp,2,2,tmp_smooth

;---pick and store only mid-year data from three-year data
;mid_idx = where( strmid(tmp_bname_interp,0,1) EQ 1,cnt)
;mid_interp=tmp_interp(mid_idx)
;mid_smooth= tmp_smooth(mid_idx)
;mid_bname= tmp_bname_interp(mid_idx)

mid_interp = tmp_interp
mid_smooth = tmp_smooth
mid_bq= tmp_bq
mid_bname  = tmp_bn ; make it compabible to three-year data process

 
mid_interp1 =( mid_interp +a )*sfactor

mid_smooth1 =( mid_smooth +a )*sfactor
  
user_metrics_nps_by1yr, mid_smooth1, mid_interp1, mid_bq, mid_bname, metrics_cal_threshold,vmetrics ;vout--smoothed vector, vorg--orginal vector, vmetrics--metrics

return

endelse 

end
