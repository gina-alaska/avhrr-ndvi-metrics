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

pro avhrr_time_series_process,tmp_ndvi,tmp_bq,tmp_cldm,tmp_bn,vmetrics,vsmooth

;define constants
a=-100
sfactor=0.01
ratio=0.3  ;number of valid points(not threshold or snowcld) of one-year devided by number of total points of one-year
metrics_cal_threshold=0.4 ;when ndvi is less than metrics_cal_threshold, do not calculate metrics
flg_metrics=0 ; 0---not calculate metrics
stnum=3  ; make first stnum points up
ednum=3  ; make last ednum points up
;CurrentBand=7 ;
;DaysPerBand=7  ; day interval between two consecituve bands =7 days

;---- calls interpol_extension_1y_vector_ver9.pro to process one-year data, do one-year vector extension, then inpterpolate

 avhrr_interpol_noextension_1yr,tmp_ndvi,tmp_bq,tmp_cldm,tmp_bn,tmp_ndvi_interp,tmp_bq_interp, tmp_cldm_interp,tmp_bn_interp,stnum_real,ednum_real,flg_metrics

;avhrr_interpol_noextension_1y,v_ndvi,  v_bq,  v_cldm,   v_bn,  v_ndvi_interp,  v_bq_interp,   v_cldm_interp,  v_bn_interp,  stnum,     ednum,     flg_metrics

if flg_metrics EQ 0 or flg_metrics EQ -1 then begin  ; no not calculate metrics

tmp_ndvi=tmp_ndvi_interp

vsmooth=tmp_ndvi_interp

tmp_bq =tmp_bq_interp

tmp_cldm=tmp_cldm_interp 

tmp_bn=tmp_bn_interp

vmetrics =fltarr(12) ; if do not calculate metrics, set every element = 0.0

vmetrics(*)=flg_metrics

return

endif else begin  


;----- calculate metrics-----------------------------

wls_smooth, tmp_ndvi_interp,2,2,tmp_smooth

tmp_interp = tmp_ndvi_interp

vsmooth = tmp_smooth

tmp_bq= tmp_bq

tmp_cldm= tmp_cldm_interp

tmp_bn  = tmp_bn_interp ; make it compabible to three-year data process

;----scle from 0-200 to -1 to 1 
tmp_interp1 =( tmp_interp +a )*sfactor

tmp_smooth1 =( tmp_smooth +a )*sfactor
  
 avhrr_user_metrics_nps_by1yr, tmp_smooth1, tmp_interp1, tmp_bq, tmp_bn, metrics_cal_threshold,vmetrics ;vout--smoothed vector, vorg--orginal vector, vmetrics--metrics
;avhrr_user_metrics_nps_by1yr, ndvi,        ndvi_raw,    bq,     bn,     metrics_cal_threshold, out_v

return

endelse 

end


