;Jiang Zhu, jiang@gina.alaska.edu, 2/22/2011
;This program get rid off the points with value equal to threshold, 
;cahnge values to 101b or 102b of the points that their values are equal to snowcld,
;then interpol the vector.
;inputs are:
;vcomp (a three-year-time-series vector),
;threshold (fill value for missing pixel in 0-200, default is 80b ),
;snowcld (fill value for snoe,cloud,bad, and negative reflectance pixelin 0-200, default is 60b),
;ratio (to control if is sutable to calculate metrics)
;output:interpolated vector is returned in vcomp 
 
;jzhu, v_ndvi include ndvi and bq in one vector
;jzhu,12/7/2011, from cutoff_interp_ver9.pro, do not cut off fill value but set thenm as 100b

pro cutoff_interp,v_ndvi,  v_bq, v_cldm, v_ndvi_g,  flg_metrics
;   cutoff_interp,v_ndvi, v_bq, v_cldm, v_ndvi_g, flg_metrics
;v_ndvi----vector of ndvi,
;v_bq---- vector of qa
;v_cldm---vector of cloud mask

;output: v_ndvi_g 

;qa_bad=0             ; bad quality data

;qa_good=1           ; good quality data threshold value, 15 for 2005, 1 for before 2005  

ndvi_low=100         ; valid ndvi is ndvi >=ndvi_low and <=200, less than ndvi_low is bad value

cloudy=100           ; >=100 is cloudy, <100 is clear

flg_metrics=1       ; 1-valid metrics, 0-not valid metrics


;---get valid data vector

tmpnan=v_ndvi ; tmpnan will be used to store return vector

;---- first set bad points to be ramdonly 100 to 101b

idx_bad=where(v_ndvi LT ndvi_low,cnt_bad)

if cnt_bad GT 0 then begin ; <1> need do some interpolation, interpolate 100 to 101 for bad ndvi or bad quality data
  
random_val = byte( fix( (randomu(1, n_elements(idx_bad) ) )*2 )+100 )
tmpnan(idx_bad)=random_val

;tmpnan(idx_bad)=100

endif

;---- interpolate between range determined by points with 20% of maximun value

idx_50percent=where( tmpnan-ndvi_low GE 0.2*max(tmpnan-ndvi_low ), cnt50 )

if cnt50 LT 5 then begin ; <0> do not have enough valid points, do not calculate metrics

v_ndvi_g = tmpnan

flg_metrics=0

return

endif else begin  ; <0>



stidx=idx_50percent(0)

;stidx=0

edidx=idx_50percent(n_elements(idx_50percent)-1)

;edidx=n_elements(tmpnan)-1

tmp50=tmpnan(stidx:edidx) ;

;tmp50=tmpnan

tmp50_bq=v_bq(stidx:edidx);

;tmp50_bq=v_bq

tmp50_cldm=v_cldm(stidx:edidx)

;tmp50_cldm=v_cldm

;within the range determined by 20% of maximum ndvi value, keep good values with cldmask value less than cloudy and ndvi value great than ndvi_low  

idxv=where(tmp50 GE ndvi_low  and tmp50_cldm LT cloudy, cnt50v,complement=idxnon);


if cnt50v GT 0 then begin ; <2> have points need to interpolate

tmpx=fix(idxv) ;x coordinates values of valid values

tmpv=tmp50(idxv) ; valid values

;---interpolate the missing points: cloud,bad, fill, and negative reflectance pixels

len=n_elements(tmp50)

tmpu=indgen(len) ; interpolated x coorinidates

tmpinterp=interpol_line100b(tmpv,tmpx,tmpu)

tmpnan(stidx:edidx) = tmpinterp

endif ; <2>

;---get rid of odd points, 0.4

filter_2odd, tmpnan, 40, tmpnan1

;---output vector

v_ndvi_g = tmpnan1

endelse ;<0>

return

end
