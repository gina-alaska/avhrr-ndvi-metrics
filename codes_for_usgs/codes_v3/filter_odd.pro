;this program filter out odd points in the vector v, one-year ndvi curve should be both sides are low and middle is hight.
;if ther are some points with very low values,
;they are considered as odd points, take them off and interpol them.
;input, v---vector,output: returned vector named rtr
; if minpoint-lowvalu > 0.4 take this point out
pro filter_odd, r, ratio, rtr

if min(r) EQ max(r) then begin

rtr=r

return

endif


rtr = r  ;  rtr will be used to store result vector

v =deriv(r)  ; velocity

num=n_elements(v)

;--- mark points  which need interpolatem, 1--mark, 0--no mark

mark=intarr(num) 


a=deriv(v)   ;acceleration

;--- locate low limit points

num=(size(r))(1)

idx1=where(V LT 0.0 ,cnt)  ; possible low limit points, v from negative to positive, that point is low limit

if cnt EQ 0  then begin   ; can nnot found low limit points, 

rtr=r

return

endif

num1=(size(idx1))(1) ; idx1(1) will be the possible low point

for k=0, num1-1 do begin ; found real low limit points

if idx1(k) GT 0 and idx1(k)+2 LE num-1 then begin  ; negative ponit is not the last point nor first point

 if v(idx1(k)) LT 0.0 and v(idx1(k)+1 ) GT 0.0  then begin  ; possible low limit points

;-- locate the exact point of low limit

 tmp =[r(idx1(k)-1),r(idx1(k)),r(idx1(k)+1 ),r(idx1(k)+2)]

 low=min(tmp)

 idx_low=where(tmp EQ low)

 idx_lowlmt=idx1(k)+idx_low(0)-1  ; low limit idx

;----- check this low limit with adjuctive upper limit points to decide if average
 
;idxup=where(v GT 0.0,cnt0 )  ; v from positive to negative, there is upper limit 
; found left adjunctive upper limitidx_lftup = where(idxup LT idx_lowlmt,cnt1) 
;idx_rgtup = where(idxup GT idx_lowlmt,cnt2) 
 ;if cnt0 GT 0 and cnt1 GT 0 and cnt2 GT 0 then begin ; found two adjunctive points 
 ;lftupv =r( idx_lftup( n_elements(idx_lftup) - 1 ) )
;rgtupv =r( idx_rgtup(0) ) 
; minv=float( min( [lftupv,rgtupv]) )


;----- use one of the adjunctive points which has small value to compare with the low limit pont, see if need replace this low limit point 

minv=float( min([ r(idx_lowlmt-1), r(idx_lowlmt+1) ] ) )

lowv=float(r(idx_lowlmt))

if  lowv GE 0 and lowv/minv LT ratio then begin

  
    mark(idx_lowlmt)=1
 
endif

  
endif
 
endif
 

endfor

;----- according to mark to do interpolate

idxneed = where(mark EQ 1 ,cnt,complement=idxv )

if cnt GT 0 then begin

idxc = indgen(n_elements(r))

rtr = interpol(r(idxv),idxv,idxc)

endif else begin

rtr=r

endelse


return

end 