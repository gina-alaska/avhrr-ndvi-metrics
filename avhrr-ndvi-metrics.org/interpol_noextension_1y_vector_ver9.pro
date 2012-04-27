;This program process a vector, it get rid of no-sense point such as -2000 (80), intepolate with adjunct points
;This program do not call oneyear_extension, that means do not interpolate jan,nov,and dec into feb to oct data series
;do interpolate, interpolate threshold, if all time series are threshold values, means this pixel is not vegitation, perhaps water, do not calcualte metrics of this pixel
;threshold is fill value, do not do interpolate, snowcld=60, need interpolate, for points with 81-100, need interpolate
 

pro interpol_noextension_1y_vector_ver9,  mid_year_cb, mid_year_bn,threshold,snowcld,v_interp,v_bq_interp, v_bname_interp,ratio, mid_stnum,mid_ednum,flg_metrics

;input: mid_year--- input vector, return data stored in v_interp, threshold--- get rid of those points with value below threshold, then interpol
;       mid_year_bn----band names of elements of vector
;output: v_interp---- result vector, v_bname_interp --- result of band names

;----- interpol into a complete year, 52 bands/year, so three year will be 52*3 bands

;-- located start and end idx for three years,

;---- for 7day per period, it has 52 period per year, before calcualte, interpol beginning and ending missing values

;ndvi flag: 0b- valid, 1b-cloudy,2b-bad quality,3b-negative reflectance,4b-snow,10b-fill, from eMODIS documentation


;----determine if we calculate ndvi metrics

flg_metrics= 0 ; initial not calculate metrics 
numofmidyrcb=n_elements(mid_year_cb)
numofmidyr=numofmidyrcb/2

;--- the first half of numofmidyr ndvi vector, the second half of nunofmidyr is bq vector

mid_year=mid_year_cb(0:numofmidyrcb/2 -1)
mid_year_bq=mid_year_cb(numofmidyrcb/2:numofmidyrcb-1)

;----- for fill pixels, do not calculate ndvi, just extend the band name to one year ---

idxv=where((mid_year_bq EQ 0b) or (mid_year_bq EQ 4b),cntv )

if cntv GT 5 then begin 
   idxv1=where(mid_year(idxv) GT 100 and max(mid_year(idxv))-100 GE 25, cntv1) ;maximum must be greater than 0.25
endif else begin
   cntv1=0
endelse
   
if cntv1 GT 5 then begin ; valid point are at least 5, otherwise, do not calculate metrics

flg_metrics=1

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