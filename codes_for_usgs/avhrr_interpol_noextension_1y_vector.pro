;This program process a vector, it get rid of no-sense point such as -2000 (80), intepolate with adjunct points
;This program do not call oneyear_extension, that means do not interpolate jan,nov,and dec into feb to oct data series
;do interpolate, interpolate threshold, if all time series are threshold values, means this pixel is not vegitation, perhaps water, do not calcualte metrics of this pixel
;threshold is fill value, do not do interpolate, snowcld=60, need interpolate, for points with 81-100, need interpolate
 

pro avhrr_interpol_noextension_1y_vector, tmp,tmp_bn,ratio,tmp_interp,tmp_bn_interp,interp_flg
;   avhrr_interpol_noextension_1y_vector, tmp,tmp_bn,ratio,tmp_interp,tmp_bn_interp,interp_flg
;inputs: tmp, tmp_bn, ratio

;outputs: tmp_interp, tmp_bn_interp, interp_flg

mid_year=tmp

mid_year_bq=tmp_bn


idxv1=where(mid_year GT 100 and max(mid_year)-100 GE 25, cntv1) ;maximum must be greater than 0.25

if cntv1 GT 5 then begin ; valid point are at least 5, otherwise, do not calculate metrics

interp_flg=1

cutoff_interp_ver10,mid_year_cb,mid_year_g,flg_metrics  ; cutoff_interp_ver10, first change fill value as 100, then cut off negative,

;----- call oneyear_extension
;oneyear_extension100b, mid_year_g, mid_year_bq, mid_year_bn,mid_stnum,mid_ednum,days_mid
;daycom=days_mid

;----- output interpolated data
v_interp=mid_year_g  ; processed vector to v
v_bq_interp=mid_year_bq ; processed bq vector
v_bname_interp=mid_year_bn ;processed band name cevtor

return


endif else begin

flg_metrics=0

idx10=where(mid_year_bq EQ 10b or mid_year_bq EQ 2b,cnt10) ; fill or bad points

if cnt10 EQ numofmidyr then begin   ; fill pixels
flg_metrics=-1
endif

;oneyear_extensionfillval, mid_year, mid_year_bq, mid_year_bn, mid_stnum,mid_ednum,days_mid

v_interp=mid_year
v_bq_interp=mid_year_bq
v_bname_interp=mid_year_bn

return

endelse

end