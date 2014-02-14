;this program use slope method to determine start end end day indices , input ndvi, threshold_val
;we calulate the both up and down slopes at threshold_val, return start and end day indics, and wl0 and wl1 
function determine_wl, ndvi, threshold_val

;---- threshold=0.05, normalized ndvi value, use half of maximun of ndvi as threshold_val 


;--- from the maximun point down to the left side, find out the point which intersection with threshold_val point

numofdayidx = n_elements(ndvi)

xarry = findgen(numofdayidx)

idxmax=where(ndvi EQ max(ndvi),cnt)

for k=idxmax(0),0,-1 do begin

if ndvi(k) LE threshold_val then begin

up_x = k


result = LINFIT( xarry(up_x:up_x+3), ndvi(up_x:up_x+3) ) 

if result[1] NE 0.0 then begin

x1=-result(0)/result(1)

endif else begin

slopeup=( ndvi(up_x+2)-ndvi(up_x) )/2.0

up_y=ndvi(up_x)

x1=up_x-up_y/slopeup

endelse

break

endif

endfor

;----from maximun point to right, lookin for threshold_val point

idxmaxdn=idxmax(n_elements(idxmax)-1)

for k=idxmaxdn, numofdayidx-1 do begin

if ndvi(k) LE threshold_val then begin

dn_x = k

result=linfit( xarry(dn_x-3:dn_x),ndvi(dn_x-3:dn_x) )

if result[1] NE 0.0 then begin

x2=-result(0)/result(1)

endif else begin

slopedn=( ndvi(dn_x)-ndvi(dn_x-2) )/2.0

dn_y=ndvi(dn_x)

x2=dn_x-dn_y/slopedn

endelse

break

endif

endfor

;---- some conditions to exlcude false SOS and EOS detrived by slope method

if x1 LT 5 or x1 GT 30 then begin
wl0=30
wl1=32
x1=-9999
endif

if x2 LT 30 or x1 GT 50 then begin
wl0=30
wl1=32
x2=-9999
endif

wl0 =fix( numofdayidx-x2 + x1 +2 ) ; add 2 to off season time range 
wl1= wl0+2 ; add 2 to wl0

if wl0 LT 25 or wl0 GT 40 then begin ; 25--25*7=175 days, green range=365-175=190 days, 40--40*7=280 days, green range=365-280= 85 days

wl0=30

wl1=32

endif

return,[wl0,wl1,x1,x2]

end
