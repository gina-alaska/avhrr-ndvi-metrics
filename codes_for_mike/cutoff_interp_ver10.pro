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
 
;jzhu, vcomp_cb include ndvi and bq in one vector
;jzhu,12/7/2011, from cutoff_interp_ver9.pro, do not cut off fill value but set thenm as 100b

pro cutoff_interp_ver10, vcomp_cb, vcomp_g, flg_metrics

;vcomp_cb----vector need processed, which include both ndvi and related quality_flag
;return vcomp_g 
;threshold---if value of element in vcomp are less than threshold, this element needs interpolate,
;ratio---number of valid elements/total number of elements,
;in order to compainto nps data process, data is type, range is 0-200,100-20 are good data,
;80 is fill value, negative ndvi value corresponds to 80-99, 0 ndvi corresponds to 100,
;for 80-89, cahnge them into 100,101,or 102,
;80-89-->100, 90-99->101,100-->102

;default values for threshold, snowcld, and ratio are:
;threshold = 80 ; do not interpolate these points
;snowcld=60; need interpolate these points
;ratio should be 0.5

;0b-valid,1b-cloudy,2b-bad,3b-negative reflectance,4b-snow,10b-fill

flg_metrics=1 ; initial value


;---get valid data vector

num=n_elements(vcomp_cb)

;seperate the combined vector into ndvi and bq vectors

vcomp = vcomp_cb(0: num/2-1)

vcomp_bq=vcomp_cb(num/2:num-1)
 
;different choose in dealinng with no valid points 

;1. interpolate fill, cloudy, and bad points, replace snow and negative reflectance points with randomly 100b to 101.
   
;idxv = where( (vcomp_bq EQ 0b or vcomp_bq EQ 4b ) and vcomp GE 100b , cnt, complement=idx) ;(valid or snow) and positive 



tmpnan=vcomp ; tmpnan will be used to store return vector


;---- first set negative points and bad points to be ramdonly 100 to 101b
idx_negbad=where(vcomp LT 100b or vcomp_bq EQ 2b ,cnt_negbad)
if cnt_negbad GT 0 then begin ; <1> need do some interpolation
random_val = byte( fix( (randomu(1, n_elements(idx_negbad) ) )*2 )+100 )
tmpnan(idx_negbad)=random_val
endif

;---- interpolate between range determined by points with 20% of maximun value
idx_50percent=where( tmpnan-100 GE 0.2*max(tmpnan-100 ) and vcomp_bq EQ 0b, cnt50 )
if cnt50 LT 5 then begin ; <0> do not have enough valid points, do not calculate
vcomp_g=tmpnan
flg_metrics=0
return

endif else begin  ; <0>

totnum=n_elements(vcomp)
stidx=idx_50percent(0)
edidx=idx_50percent(n_elements(idx_50percent)-1)
;tmpb=tmpnan(0:stidx-1)
;tmpb_bq=tmpnan(0:stidx-1);

tmp50=tmpnan(stidx:edidx) ;
tmp50_bq=vcomp_bq(stidx:edidx);

;--- 0 to stidx-1, cahnge negative into randomly 100-101
;
;idx_negbad=where(tmpnan(0:stidx-1) LT 100 or vcomp_bq(0:stidx-1) EQ 2 ,cnt_negbad)
;if cnt_negbad GT 0 then begin ; <1> need do some interpolation
;random_val = byte( fix( (randomu(1, n_elements(idx_negbad) ) )*2 )+100 )
;tmpnan(idx_negbad)=random_val
;endif
;---- interpolate tmp50

idxv=where(tmp50_bq EQ 0b and tmp50 GT 101, cnt50v,complement=idxnon); keeps only good points, interpolate others
;---by interpolate 100 to 101 for negative and bad points, the minumum value of "not good" point will be 101. 

if cnt50v GT 0 then begin ; <2> have points need to interpolate
;---get the mean of first and last valid as fill value for 1-28, 223-365 days
tmpx=fix(idxv) ;x coordinates values of valid values
tmpv=tmp50(idxv) ; valid values
;---interpolate the missing points: cloud,bad, fill, and negative reflectance pixels
len=n_elements(tmp50)
tmpu=indgen(len) ; interpolated x coorinidates

;tmpnan=interpol(tmpv,tmpx,tmpu) ;interpolate, IDL provide method
;tmpnan=interpol_line_ver9(tmpv,tmpx,tmpu) ; interpolate by jzhu's method

tmpinterp=interpol_line100b(tmpv,tmpx,tmpu)
tmpnan(stidx:edidx)=tmpinterp

endif ; <2>

;---- edidx +1 to n_elements(vcomp)-1, change negative into 100-101b
;if edidx+1 LT totnum-1 then begin
;idx_negbad=where(tmpnan(edidx+1:totnum-1) LT 100b or vcomp_bq(edidx+1:totnum-1) EQ 2b ,cnt_negbad)
;if cnt_negbad GT 0 then begin ; <1> need do some interpolation
;random_val = byte( fix( (randomu(1, n_elements(idx_negbad) ) )*2 )+100 )
;tmpnan(edidx+1+idx_negbad)=random_val
;endif
;endif

;---get rid of odd points, 0.4
filter_2odd, tmpnan, 40, tmpnan1
;---output vector
vcomp_g = tmpnan1

return

endelse ; <0>

end
