;this program filter out odd points in the vector v, one-year ndvi curve should be both sides are low and middle is hight.
;if ther are some points with very low values,
;they are considered as odd points, take them off and interpol them.
;input, v---vector,output: returned vector named rtr
; if minpoint-lowvalu > diffval take this point out
;input data range 0 to 200, and valid range is lowvalu to 200, lowvalu=100, diffval=40


pro filter_2odd, rin, diffval, r

if min(rin) EQ max(rin) then begin

r = rin

return

endif

r = rin-100  ;  r will be used to store result vector


num=(size(r))(1) ; number of points in the vector r


for k =0, num-4 do begin ; check four points to find the odd 1 point or 2 consecutive odd points

; one odd in three points

if r(k)-r(k+1) GT diffval and r(k+2)-r(k+1) GT diffval then begin

 r(k+1)=0.5*( r(k)+r(k+2) )

endif else begin    ; two odds in four points

  if r(k)-r(k+1) GT diffval and r(k+3)-r(k+1) GT diffval and r(k)-r(k+2) GT diffval and r(k+3)-r(k+2) GT diffval then begin
  
  slope=(r(k+3)-r(k))/3.0
  r(k+1)=1.0*slope+r(k)
  r(k+2)=2.0*slope+r(k)  
  
  endif
  
  
endelse  


endfor

r=r+100

return

end 